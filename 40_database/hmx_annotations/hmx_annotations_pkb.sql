prompt *I: ScriptBOF hmx_annotations_pkb.sql
create or replace package body hmx_annotations
as
/* <hmx-annotations>

.HMX_OBJECT_VERSION 2026-10-20 15:13:58 CEST

.HMX_OBJECT_REPO git@github.com:HermanMol/FJ12a_HMX-dev.git

.HMX_OBJECT_USAGE
    This package is a wrapper to manage database annotations.

.HMX_DB_VERSION Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0

.HMX_OBJECT_NOTES
    - Package was initially developed with invoker rights (AUTHID CURRENT_USER)
    - Annotations supported in this package are tables, views, materialized views, and indexes.

.HMX_DEVELOPER_NOTES
    - See HMX General Developer Notes

** </hmx-annotations> */

    -- ---------------------------------------------------------------------------------------------
    -- Public function that checks if a certain Oracle Annotation exists. Input parameters are the
    -- attributes that uniquely identify an annotation.
    -- Returned:
    -- - hmx_utl.k_byes   if the annotation exists
    -- - hmx_utl.k_bno    if the annotation does not exist, but the related object/column exists
    -- - hmx_utl.k_berror if the annotation does not exist AND the related object/column does not exist.
    function check_annotation_exists
        (pi_object_name      in varchar2                    -- max length 128 , always required
        ,pi_object_type      in varchar2                    -- max length 9   , always required
        ,pi_column_name      in varchar2 := hmx_utl.k_none  -- max length 128 , optional, only for tables and views
        ,pi_domain_name      in varchar2 := hmx_utl.k_none  -- max length 128 , currently ignored in HMX
        ,pi_domain_owner     in varchar2 := hmx_utl.k_none  -- max length 128 , currently ignored in HMX
        ,pi_annotation_owner in varchar2                    -- max length 128 , always required
        ,pi_annotation_name  in varchar2                    -- max length 1024, always required, CaSe SeNsItIvE!
        )
    return hmx_types.t_y_n_e
    as
        -- columns in view all_annotations_usage (Oracle 19)
        l_object_name       varchar2(128)  := upper(pi_object_name);                    
        l_object_type       varchar2(9)    := upper(pi_object_type);                    
        l_annotation_owner  varchar2(128)  := upper(pi_annotation_owner);               
        l_annotation_name   varchar2(1024) := pi_annotation_name;                       
        l_column_name       varchar2(128)  := coalesce(upper(pi_column_name) ,hmx_utl.k_none); 
        l_domain_name       varchar2(128)  := coalesce(pi_domain_name ,hmx_utl.k_none); 
        l_domain_owner      varchar2(128)  := coalesce(pi_domain_owner,hmx_utl.k_none); 
        l_annotation_value  varchar2(4000);

        l_exists    hmx_types.t_y_n_e := null;
        l_found     hmx_types.t_y_n_e := null;
    begin
        <<check_annotation>>
        begin
            select sign(count(*))
            into l_found
            from all_annotations_usage
            where object_name                           = l_object_name
            and   object_type                           = l_object_type
            and   annotation_owner                      = l_annotation_owner
            and   annotation_name                       = l_annotation_name
            and   coalesce(column_name ,hmx_utl.k_none) = l_column_name
            and   coalesce(domain_name ,hmx_utl.k_none) = l_domain_name
            and   coalesce(domain_owner,hmx_utl.k_none) = l_domain_owner;

            if l_found = hmx_utl.k_byes
            then
                -- annotation exists
                l_exists := hmx_utl.k_byes;
            else
                -- annotation does not yet exist.
                -- check if the object/column exists. If not, then an annotation cannot be made.
                if l_column_name <> hmx_utl.k_none
                then
                    select sign(count(*))
                    into l_found
                    from all_tab_columns tcl
                    where tcl.owner       = l_annotation_owner
                    and   tcl.table_name  = l_object_name
                    and   tcl.column_name = l_column_name;
                else
                    select sign(count(*))
                    into l_found
                    from all_objects obj
                    where obj.owner       = l_annotation_owner
                    and   obj.object_name = l_object_name
                    and   obj.object_type = l_object_type;
                end if;
                if l_found = hmx_utl.k_byes
                then
                    -- annotation not found but can be created because the related object/column exists
                    l_exists := hmx_utl.k_bno;
                else
                    -- annotation not found and can NOT be created because the related object/column does not exist
                    -- or is not supporting the Oracle database annotations, but uses the hmx-annotations hardcoded in the source.
                    l_exists := hmx_utl.k_berror;
                end if;
            end if;
        end check_annotation;

        return l_exists;
    end check_annotation_exists;

    -- ---------------------------------------------------------------------------------------------
    -- Public procedure that adds or replaces a certain Oracle Annotation value. Input parameters
    -- are the attributes that uniquely identify an annotation.
    procedure set_oracle_annotation
        (pi_object_name      in varchar2                    -- max length 128 , required
        ,pi_object_type      in varchar2                    -- max length 9   , required
        ,pi_column_name      in varchar2 := hmx_utl.k_none  -- max length 128 , optional, only for tables
        ,pi_annotation_name  in varchar2                    -- max length 1024, required, CaSe SeNsItIvE!
        ,pi_annotation_value in varchar2                    -- max length 4000, optional, CaSe SeNsItIvE!
        )
    is
        -- columns in view all_annotations_usage (Oracle 19)
        l_object_name       varchar2(128)  := upper(pi_object_name);                    
        l_object_type       varchar2(9)    := upper(pi_object_type);                    
        l_column_name       varchar2(128)  := coalesce(pi_column_name ,hmx_utl.k_none); 
        l_annotation_name   varchar2(1024) := pi_annotation_name;                       
        l_annotation_value  varchar2(4000) := pi_annotation_value;                      
        l_annotation_owner  varchar2(128)  := sys_context('USERENV','CURRENT_USER');    -- expecting this package has Invoker Rights

        l_exists    hmx_types.t_y_n_e := null;
        l_sql       hmx_types.t_vcharmax;
        l_action    varchar2(10);               -- add or replace

    begin
        l_exists := check_annotation_exists
                        (pi_object_name      => l_object_name
                        ,pi_object_type      => l_object_type
                        ,pi_column_name      => l_column_name
                        ,pi_annotation_owner => l_annotation_owner
                        ,pi_annotation_name  => l_annotation_name
                        );
        if l_exists = hmx_utl.k_byes
        then
            l_action := 'replace';
        else
            l_action := 'add';
        end if;
        
        l_sql := 'alter' 
            || ' ' || l_object_type 
            || ' ' || l_object_name
            || case 
                    when l_column_name <> hmx_utl.k_none then ' modify ( ' || l_column_name 
                    else null
               end
            || ' annotations ('
            || l_action 
            || ' ' || hmx_utl.f_q2q(l_annotation_name)   -- maintain case sensitivity in annotation name : double quotations for Oracle identifiers
            || ' ' || hmx_utl.f_q1q(pi_annotation_value) -- maintain case sensitivity in annotation value: single quotations for character values
            || case 
                    when l_column_name <> hmx_utl.k_none then ')'
                    else null
               end
            || ')';
            
        execute immediate l_sql;
    exception
        when others
        then
            prt('*E: ' || sqlerrm);
            if l_sql is not null
            then
                prt('    while executing command:' );
                prt('    ' || l_sql );
            end if;
            raise;
    end set_oracle_annotation;

    -- ---------------------------------------------------------------------------------------------
    -- Public procedure that drops a certain Oracle Annotation if it exists. Input parameters 
    -- are the attributes that uniquely identify an annotation.
    procedure drop_oracle_annotation
        (pi_object_name      in varchar2                    -- max length 128 , required
        ,pi_object_type      in varchar2                    -- max length 9   , required
        ,pi_column_name      in varchar2 := hmx_utl.k_none  -- max length 128 , optional, only for tables
        ,pi_annotation_name  in varchar2                    -- max length 1024, required, CaSe SeNsItIvE!
        )
    is
        -- columns in view all_annotations_usage (Oracle 19)
        l_object_name       varchar2(128)  := upper(pi_object_name);                    
        l_object_type       varchar2(9)    := upper(pi_object_type);                    
        l_column_name       varchar2(128)  := coalesce(pi_column_name ,hmx_utl.k_none); 
        l_annotation_name   varchar2(1024) := pi_annotation_name;                       

        l_sql       hmx_types.t_vcharmax;
        k_action    constant varchar2(14) := 'drop if exists';

    begin
        
        l_sql := 'alter' 
            || ' ' || l_object_type 
            || ' ' || l_object_name
            || case 
                    when l_column_name <> hmx_utl.k_none then ' modify ( ' || l_column_name 
                    else null
               end
            || ' annotations ('
            || k_action 
            || ' ' || hmx_utl.f_q2q(l_annotation_name)   -- maintain case sensitivity in annotation name : double quotations for Oracle identifiers
            || case 
                    when l_column_name <> hmx_utl.k_none then ')'
                    else null
               end
            || ')';
            
        execute immediate l_sql;
    exception
        when others
        then
            prt('*E: ' || sqlerrm);
            if l_sql is not null
            then
                prt('    while executing command:' );
                prt('    ' || l_sql );
            end if;
            raise;
    end drop_oracle_annotation;


-- -------------------------------------------------------------------------------------------------
-- package constructor
begin
  null;
--  dbms_output.enable(null);
--  dbms_output.put_line('*X: ' || $$PLSQL_UNIT || '.CONSTRUCTOR#1:'
--    || chr(10) || '- USER............. =' || nvl(to_char(USER                                      ),'n/a')
--    || chr(10) || '- CURRENT_SCHEMA... =' || nvl(to_char(sys_context('USERENV','CURRENT_SCHEMA'   )),'n/a')
--    || chr(10) || '- CURRENT_USER..... =' || nvl(to_char(sys_context('USERENV','CURRENT_USER'     )),'n/a')
--    || chr(10) || '- SESSION_USER..... =' || nvl(to_char(sys_context('USERENV','SESSION_USER'     )),'n/a')
--    || chr(10) || '- OS_USER.......... =' || nvl(to_char(sys_context('USERENV','OS_USER'          )),'n/a')
--    || chr(10) || '- CLIENT_IDENTIFIER =' || nvl(to_char(sys_context('USERENV','CLIENT_IDENTIFIER')),'n/a')
--    || chr(10) || '- CLIENT_INFO...... =' || nvl(to_char(sys_context('USERENV','CLIENT_INFO')      ),'n/a')
--    || chr(10) || '- CLIENT_USER(utl). =' || nvl(to_char(gdb_tools.gdbutl.get_client_userid        ),'n/a')
--    );

end hmx_annotations;
/
prompt *I: ScriptEOF hmx_annotations_pkb.sql
