create or replace package body hmx_utplsql_utl
as
/* <hmx-annotations>

.HMX_OBJECT_USAGE: Utilities to support utPLSQL

.HMX_OBJECT_NOTES:
    - For utPLSQL version v.3.2.3

.HMX_DEVELOPER_NOTES: See HMX General Developer Notes
.HMX_OBJECT_VERSION: 2026-11-10 17:33:15 +01:00
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */

    -- ---------------------------------------------------------------------------------------------
    -- Cursor to retrieve the required data
    cursor c_methods (i_object_id in varchar2)
    is
        -- only all functions, collect the return argument data type
        with funcs as
        (
            select package_name
                ,object_name    as method_name
                ,object_id
                ,subprogram_id
                ,overload       as overload
                ,case data_type
                        when 'CHAR'                             then 'C'
                        when 'VARCHAR2'                         then 'C'
                        when 'CLOB'                             then 'C'
                        when 'NCHAR'                            then 'C'
                        when 'NVARCHAR2'                        then 'C'
                        when 'NCLOB'                            then 'C'
                        when 'DATE'                             then 'D'
                        when 'NUMBER'                           then 'N'
                        when 'FLOAT'                            then 'N'
                        when 'BINARY_INTEGER'                   then 'N'
                        when 'TIMESTAMP'                        then 'T'
                        when 'TIMESTAMP WITH TIME ZONE'         then 'T'
                        when 'TIMESTAMP WITH LOCAL TIME ZONE'   then 'T'
                        else '?'
                    end as return_type
                ,'F'            as method_type
            from USER_ARGUMENTS
            where object_id = i_object_id
            and position = 0
        )
        -- all function and procedure arguments except the function return arguments
        ,args as
        (
            select package_name                                 as package_name
                ,subprogram_id                                  as subprogram_id
                ,object_name                                    as method_name
                ,coalesce(overload,'n/a')                       as overload
                ,listagg(lower(argument_name)
                            || ','
                            || case data_type
                                    when 'CHAR'                             then 'C'
                                    when 'VARCHAR2'                         then 'C'
                                    when 'CLOB'                             then 'C'
                                    when 'NCHAR'                            then 'C'
                                    when 'NVARCHAR2'                        then 'C'
                                    when 'NCLOB'                            then 'C'
                                    when 'DATE'                             then 'D'
                                    when 'NUMBER'                           then 'N'
                                    when 'FLOAT'                            then 'N'
                                    when 'BINARY_INTEGER'                   then 'N'
                                    when 'TIMESTAMP'                        then 'T'
                                    when 'TIMESTAMP WITH TIME ZONE'         then 'T'
                                    when 'TIMESTAMP WITH LOCAL TIME ZONE'   then 'T'
                                    else '?'
                                end
                        ,'; ' on overflow truncate 'x' with count
                        )
                    within group (order by position)            as argument_list
            from user_arguments
            where object_id = i_object_id
            and position > 0
            group by package_name
            ,subprogram_id
            ,object_name
            ,coalesce(overload,'n/a')
        )
        -- put it all together
        select all_methods.object_name      as obj_name
            ,all_methods.object_type        as obj_type
            ,all_methods.procedure_name     as method_name
            ,all_methods.subprogram_id      as subprogram_id
            ,all_methods.overload           as overload
      --    ,funcs.package_name             as f_package_name
            ,funcs.method_name              as f_method_name
      --    ,funcs.subprogram_id            as f_subprogram_id
      --    ,funcs.overload                 as f_overload
            ,funcs.return_type              as f_return_type
            ,funcs.method_type              as f_method_type
      --    ,args.package_name              as a_package_name
            ,args.method_name               as a_method_name
      --    ,args.subprogram_id             as a_subprogram_id
      --    ,args.overload                  as a_overload
            ,args.argument_list             as a_argument_list
        from USER_procedures  all_methods
        left join funcs
            on  (   funcs.package_name  = all_methods.object_name
                and funcs.subprogram_id = all_methods.subprogram_id
                )
        left join args
            on  (   args.package_name  = all_methods.object_name
                and args.subprogram_id = all_methods.subprogram_id
                )
        where all_methods.object_id = i_object_id
        and all_methods.subprogram_id > 0   -- no package constructors
        order by all_methods.object_name
            ,all_methods.subprogram_id
    --      ,all_methods.procedure_name
            ,all_methods.overload;

    -- ---------------------------------------------------------------------------------------------
    -- Generate the base utPLSQL test package spec in DBMS_OUTPUT for a given package.
    -- The generated code must be reviewed:
    -- - Search for question marks where non-obvious data types are used
    -- - ... more ...?
    procedure gen_test_package_spec
        (pi_package_name in varchar2
        )
    as
        l_object_id number := 0;
        l_subpgmnr  number := 0;
    begin

        <<get_package>>
        begin
            select object_id
            into l_object_id
            from user_objects
            where object_name = pi_package_name
            and object_type   = 'PACKAGE';
        exception
            when no_data_found
            then
                prt('*E: The package ' || pi_package_name || ' was not found.');
                raise;
        end get_package;

        prt('create or replace package ut_' || lower(pi_package_name) || '_02');
        prt('as');
        prt;
        prt('-- Generated using hmx_utlpsql.gen_test_package_spec on ' || to_char(current_timestamp,'yyyy-mm-dd hh24:mi:ss TZH:TZM') );
        prt;
        prt('    --%suite(Test package ' || lower(sys_context('USERENV','CURRENT_SCHEMA')) || '.' || lower(pi_package_name) || ')');
        prt('    --%suitepath(all hmx tests)');

        prt('    --%context(execute_' || lower(pi_package_name) || '_' || trim(to_char(l_object_id)) || '_suite)');

        <<object_methods>>
        for r_methods in c_methods (l_object_id)
        loop
            prt;
            l_subpgmnr := l_subpgmnr + 1;
            prt('    --%test(' || case when r_methods.f_return_type is not null then r_methods.f_return_type|| '=' end
                || lower(r_methods.method_name) || '#' || trim(to_char(l_subpgmnr,'000'))
                || case when r_methods.a_argument_list is not null then '[' || r_methods.a_argument_list || ']' end || ')');
            prt('    procedure ' || lower(r_methods.method_name)  || '#' || trim(to_char(l_subpgmnr,'000')) || ';'
                );
        end loop object_methods;
        prt;
        prt('    --%endcontext');
        prt('    -- Number of tests generated: ' || l_subpgmnr);
        prt('    -- End of suite(Test package ' || lower(sys_context('USERENV','CURRENT_SCHEMA')) || '.' || lower(pi_package_name) || ')');
        prt;
        prt('end ut_' || lower(pi_package_name) || '_02;');
        prt('/');
        prt;
    end gen_test_package_spec;

end hmx_utplsql_utl;
/
