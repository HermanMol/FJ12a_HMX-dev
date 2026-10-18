prompt *I: ScriptBOF hmx_annotations_pkb.sql
create or replace package body hmx_annotations
as
    -- Package must be AUTHID CURRENT_USER

    k_body_version varchar2(20) := '2026-10-18 16:43:02';

    -- ---------------------------------------------------------------------------------------------
    -- Public function returning all version information regarding this package
    function get_version_info
    return varchar2
    deterministic
    as
    begin
        return 'Package ' || $$plsql_unit || ' version' || ': Spec='  || k_spec_version || ', Body='  || k_body_version;
    end get_version_info;

    -- ---------------------------------------------------------------------------------------------
    -- Public function that checks if a certain annotation exists. Input parameters are the 
    -- attributes that uniquely identify an annotation.
    -- Returned:
    -- - hmx_utl.k_byes   if the annotation exists
    -- - hmx_utl.k_bno    if the annotation does not exist, but the related object/column exists
    -- - hmx_utl.k_berror if the annotation does not exist AND the related object/column does not exist.
    function check_annotation_exists
        (pi_object_name      in varchar2                    -- max length 128
        ,pi_object_type      in varchar2                    -- max length 9
        ,pi_column_name      in varchar2 := hmx_utl.k_none  -- max length 128
        ,pi_domain_name      in varchar2 := hmx_utl.k_none  -- max length 128
        ,pi_domain_owner     in varchar2 := hmx_utl.k_none  -- max length 128
        ,pi_annotation_owner in varchar2                    -- max length 128
        ,pi_annotation_name  in varchar2                    -- max length 1024
        )
    return hmx_types.t_y_n_e
    as
        -- columns in view all_annotations_usage (Oracle 19)
        l_object_name       varchar2(128)  := upper(pi_object_name);                    -- always required
        l_object_type       varchar2(9)    := upper(pi_object_type);                    -- always required
        l_annotation_owner  varchar2(128)  := upper(pi_annotation_owner);               -- always required
        l_annotation_name   varchar2(1024) := pi_annotation_name;                       -- always required, CaSe SeNsItIvE!
        l_column_name       varchar2(128)  := coalesce(pi_column_name ,hmx_utl.k_none); -- optional, only for tables and views
        l_domain_name       varchar2(128)  := coalesce(pi_domain_name ,hmx_utl.k_none); -- currently ignored in HMX
        l_domain_owner      varchar2(128)  := coalesce(pi_domain_owner,hmx_utl.k_none); -- currently ignored in HMX
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
                    l_exists := hmx_utl.k_berror;
                end if;
            end if;
        end check_annotation;

        return l_exists;
    end check_annotation_exists;

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
