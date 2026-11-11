create or replace package body hmx_utplsql_utl
as
/* <hmx-annotations>

.HMX_OBJECT_USAGE: Utilities to support utPLSQL

.HMX_OBJECT_NOTES:
    - This package requires invoker rights (AUTHID CURRENT_USER)
    - For utPLSQL version v.3.2.3
    - Execute this package in the CURRENT_SCHEMA of the package to test

.HMX_DEVELOPER_NOTES: See HMX General Developer Notes
.HMX_OBJECT_VERSION: 2026-11-11 17:48:27 +01:00
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */

    g_package_to_test   varchar2(128) := null;
    g_object_id         number := null;
    g_tags              varchar2(32767) := null;

    -- ---------------------------------------------------------------------------------------------
    -- Cursor to retrieve the required data for the test package, spec and body using this same cursor
    cursor c_methods (i_object_id in varchar2)
    is
        -- only all functions, collect the return argument data type
        with funcs as
        (
            select package_name
                ,object_name    as method_name
                ,object_id      as object_id
                ,subprogram_id  as subprogram_id
                ,overload       as overload
                ,data_type      as data_type
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
            ,funcs.data_type                as f_return_data_type
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
    -- Local procedure to output the generates source with appropriate indenting
    procedure lprt(pi_indent in number := 0, pi_line in varchar2 := null)
    as
    begin
        if coalesce(pi_indent,0) < 1
        then
            prt(pi_line);
        else
            prt(rpad(' ',pi_indent,' ') || pi_line);
        end if;
    end lprt;

    -- ---------------------------------------------------------------------------------------------
    -- Public procedure to set the package to test
    procedure set_package_to_test
        (pi_package_name    in varchar2
        )
    as
    begin
        g_package_to_test := pi_package_name;
    end set_package_to_test;

    -- ---------------------------------------------------------------------------------------------
    -- Public function to set the package to test
    function get_package_to_test
    return varchar2
    as
    begin
        return g_package_to_test;
    end get_package_to_test;

    -- ---------------------------------------------------------------------------------------------
    -- Public function returning a utPLSQL valid suite annotation description
    -- Suite is a required utPLSQL annotation.
    function get_suite
        (pi_suite   in varchar2 := null)
    return varchar2
    deterministic
    as
    begin
        return coalesce(pi_suite, 'Test package ' || lower(sys_context('USERENV','CURRENT_SCHEMA')) || '.' || lower(g_package_to_test) );
    end get_suite;

    -- ---------------------------------------------------------------------------------------------
    -- Public function returning a utPLSQL valid suitepath annotation
    -- SuitePath is an optional utPLSQL annotation.
    function get_suitepath_annotation
        (pi_suitepath   in varchar2 := null)
    return varchar2
    deterministic
    as
    begin
        if pi_suitepath is not null
        then
            return '--%suitepath(' || regexp_replace(pi_suitepath,'[^a-z0-9\._]','_',1,0,'i') || ')';
        end if;
        return null;
    end get_suitepath_annotation;

    -- ---------------------------------------------------------------------------------------------
    -- Public function returning a full utPLSQL valid context annotation.
    -- If argument pi_context is empty, no context annotation is returned.
    -- Context is an optional utPLSQL annotation.
    function get_context_annotation
        (pi_context   in varchar2 := null)
    return varchar2
    deterministic
    as
    begin
        if pi_context is not null
        then
            return '--%context(' || trim(pi_context) || ')';
        end if;
    end get_context_annotation;

    -- ---------------------------------------------------------------------------------------------
    -- Public procedure to set the tags
    procedure set_tags
        (pi_tags    in varchar2
        )
    as
    begin
        g_tags := pi_tags;
    end set_tags;

    -- ---------------------------------------------------------------------------------------------
    -- Public function returning the current utPLSQL tags.
    function get_tags
    return varchar2
    as
    begin
        return g_tags;
    end get_tags;

    -- ---------------------------------------------------------------------------------------------
    -- Generate the base utPLSQL test package spec in DBMS_OUTPUT for a given package.
    -- The generated code must be reviewed:
    -- - Search for question marks where non-obvious data types are used
    -- - ... more ...?
    procedure generate_test_package_spec
        (pi_package_name    in varchar2
        ,pi_suite           in varchar2 := 'Suite?'
        ,pi_suitepath       in varchar2 := 'SuitePath?'
        ,pi_context         in varchar2 := 'Context?'
        )
    as
        -- To avoid duplicate test procedures give them a simple sequence number.
        -- Not the Oracle subprogram_id since that may change when a new method was added to the package.
        l_subpgmnr  number := 0;
    begin

        set_package_to_test(pi_package_name => pi_package_name);

        <<get_package>>
        begin
            select object_id
            into g_object_id
            from user_objects
            where object_name = g_package_to_test
            and object_type   = 'PACKAGE';
        exception
            when no_data_found
            then
                prt('*E: The package ' || g_package_to_test || ' was not found.');
                raise;
        end get_package;

        lprt(0,'create or replace package ut_' || lower(g_package_to_test) || '_02');
        lprt(0,'as');
        lprt;
        lprt(0,'-- Generated using hmx_utplsql_utl.generate_test_package_spec on ' || to_char(current_timestamp,'yyyy-mm-dd hh24:mi:ss TZH:TZM') );
        lprt;
        lprt(4,'--%suite(' || get_suite(pi_suite => pi_suite) || ')');
        if pi_suitepath is not null
        then
            lprt(4,get_suitepath_annotation(pi_suitepath => pi_suitepath) );
        end if;
        if pi_context is not null
        then
            lprt(4,get_context_annotation(pi_context => pi_context) );
        end if;

        <<object_methods>>
        for r_methods in c_methods (g_object_id)
        loop
            lprt;
            l_subpgmnr := l_subpgmnr + 1;
            if g_tags is not null
            then
                lprt(4,'--%tags(' || get_tags || ')');
            end if;
            lprt(4,'--%test(' || case when r_methods.f_return_type is not null then r_methods.f_return_type|| '=' end
                || lower(r_methods.method_name) || '#' || trim(to_char(l_subpgmnr,'000'))
                || case when r_methods.a_argument_list is not null then '[' || r_methods.a_argument_list || ']' end || ')');
            lprt(4,'procedure ' || lower(r_methods.method_name)  || '#' || trim(to_char(l_subpgmnr,'000')) || ';'
                );
        end loop object_methods;
        lprt;
        if pi_context is not null
        then
            lprt(4,'--%endcontext');
        end if;
        lprt(4,'-- Number of tests generated: ' || l_subpgmnr);
        lprt(4,'-- End of suite(' || get_suite(pi_suite => pi_suite) || ')');
        lprt;
        lprt(0,'end ut_' || lower(g_package_to_test) || '_02;');
        lprt(0,'/');
        lprt;
    end generate_test_package_spec;

    -- ---------------------------------------------------------------------------------------------
    -- Generate the base utPLSQL test package body in DBMS_OUTPUT for a given package.
    -- Notes:
    -- - In the generated package body using "--#" i.s.o. "--%" for the utPLSQL annotations
    --
    -- ATTENTION! The generated code must be reviewed:
    -- - Search for question marks where non-obvious data types are used
    -- - ... more ...?
    procedure generate_test_package_body
        (pi_package_name    in varchar2
        ,pi_suite           in varchar2 := 'Suite?'
        ,pi_suitepath       in varchar2 := 'SuitePath?'
        ,pi_context         in varchar2 := 'Context?'
        )
    as
        l_owner     varchar2(128) := lower(sys_context('USERENV','CURRENT_SCHEMA'));
        g_object_id number := 0;
        -- To avoid duplicate test procedures give them a simple sequence number.
        -- Not the Oracle subprogram_id since that may change when a new method was added to the package.
        l_subpgmnr  number := 0;
        l_data_type varchar2(100);

    begin

        set_package_to_test(pi_package_name => pi_package_name);

        <<get_package>>
        begin
            select object_id
            into g_object_id
            from user_objects
            where object_name = g_package_to_test
            and object_type   = 'PACKAGE';
        exception
            when no_data_found
            then
                prt('*E: The package ' || g_package_to_test || ' was not found.');
                raise;
        end get_package;

        lprt(0,'create or replace package body ut_' || lower(g_package_to_test) || '_02');
        lprt(0,'as');
        lprt;
        lprt(0,'-- Generated using hmx_utplsql_utl.generate_test_package_body on ' || to_char(current_timestamp,'yyyy-mm-dd hh24:mi:ss TZH:TZM') );
        lprt;
        lprt(4,'--#suite(' || get_suite(pi_suite => pi_suite) || ')');
        if pi_suitepath is not null
        then
            lprt(4,replace(get_suitepath_annotation(pi_suitepath => pi_suitepath),'--%','--#') );
        end if;
        if pi_context is not null
        then
            lprt(4,replace(get_context_annotation(pi_context => pi_context),'--%','--#') );
        end if;

        <<object_methods>>
        for r_methods in c_methods (g_object_id)
        loop
            lprt;
            l_subpgmnr := l_subpgmnr + 1;
            -- Assumed data type of the expectation and actual.
            l_data_type := lower(case
                                when r_methods.f_return_type = 'C' then 'varchar2(32767)'
                                when r_methods.f_return_type = 'N' then 'number'
                                when r_methods.f_return_type = 'D' then 'date'
                                when r_methods.f_return_type = 'T' then lower(r_methods.f_return_data_type)
                                else
                                    case when r_methods.f_return_data_type is not null then r_methods.f_return_data_type
                                    else 'varchar2'
                                    end
                                    || '(?)'
                                end
                            )
                    || ';';

            -- Generate test source code for one method
            lprt(4,rpad('-- ',96,'-'));
            if g_tags is not null
            then
                lprt(4,'--#tags(' || get_tags || ')');
            end if;
            lprt(4,'--#test(' || case when r_methods.f_return_type is not null then r_methods.f_return_type|| '=' end
                || lower(r_methods.method_name) || '#' || trim(to_char(l_subpgmnr,'000'))
                || case when r_methods.a_argument_list is not null then '[' || r_methods.a_argument_list || ']' end || ')'
                );

            lprt(4,'procedure ' || lower(r_methods.method_name)  || '#' || trim(to_char(l_subpgmnr,'000')) );
            lprt(4,'as');
            lprt(8,'l_expect       ' || l_data_type);
            lprt(8,'l_actual       ' || l_data_type);
            lprt(4,'begin');
            lprt(8,'-- Verify action for ' || l_owner || '.' || lower(r_methods.method_name) || ';');
            lprt(8,'-- Assert');
            lprt(8,'ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );');
            lprt(4,'end ' || lower(r_methods.method_name)  || '#' || trim(to_char(l_subpgmnr,'000')) || ';');

        end loop object_methods;
        lprt;
        if pi_context is not null
        then
            lprt(4,'--#endcontext');
        end if;
        lprt(4,'-- Number of tests generated: ' || l_subpgmnr);
        lprt(4,'-- End of suite(Test package ' || lower(sys_context('USERENV','CURRENT_SCHEMA')) || '.' || lower(g_package_to_test) || ')');
        lprt;
        lprt(0,'end ut_' || lower(g_package_to_test) || '_02;');
        lprt(0,'/');
        lprt;
    end generate_test_package_body;

    -- ---------------------------------------------------------------------------------------------
    -- Generate the base utPLSQL test package spec and body in DBMS_OUTPUT for a given package.
    -- ATTENTION! The generated code must be reviewed:
    -- - Search for question marks where non-obvious data types are used
    -- - ... more ...?
    procedure generate_test_package
        (pi_package_name    in varchar2
        ,pi_suite           in varchar2 := 'Suite?'
        ,pi_suitepath       in varchar2 := 'SuitePath?'
        ,pi_context         in varchar2 := 'Context?'
        )
    as
    begin

        set_package_to_test(pi_package_name => pi_package_name);

        generate_test_package_spec
            (pi_package_name => g_package_to_test
            ,pi_suite        => pi_suite
            ,pi_suitepath    => pi_suitepath
            ,pi_context      => pi_context
            );
        prt;
        prt(rpad('-- ',100,'='));
        prt;
        generate_test_package_body
            (pi_package_name => g_package_to_test
            ,pi_suite        => pi_suite
            ,pi_suitepath    => pi_suitepath
            ,pi_context      => pi_context
            );
        
    end generate_test_package;

end hmx_utplsql_utl;
/
