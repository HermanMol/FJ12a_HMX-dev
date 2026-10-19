prompt *I: ScriptBOF hmx_types_pkb.sql
create or replace package body hmx_types
as

    k_body_version varchar2(20) := '2026-10-17 09:57:47';

    -- Types and subtypes not related to a specific domain/package
    -- More complect types:
    -- - string_stack_type

    -- ---------------------------------------------------------------------------------------------
    -- Public function returning all version information regarding this package
    function get_version_info
    return varchar2
    deterministic
    as
    begin
        return 'Package ' || $$plsql_unit || ' version' || ': Spec='  || k_spec_version || ', Body='  || k_body_version;
    end get_version_info;

end hmx_types;
/
prompt *I: ScriptEOF hmx_types_pkb.sql
