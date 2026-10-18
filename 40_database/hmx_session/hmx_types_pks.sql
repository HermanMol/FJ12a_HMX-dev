prompt *I: ScriptBOF hmx_types_pks.sql
create or replace package hmx_types
as

    k_spec_version    constant varchar2(20) := '2026-10-17 09:57:54';

    -- Types and subtypes not related to a specific domain/package

    -- More complect HMX types, see:
    -- - string_stack_type

    subtype t_vchar30   is varchar2(30);    -- e.g. DBMS_SESSION LIST_CONTEXT namespace and attribute
    subtype t_vchar128  is varchar2(128);   -- e.g. DBMS_SESSION SET_CONTEXT namespace
    subtype t_vchar4000 is varchar2(4000);
    subtype t_vcharmax  is varchar2(32767);

    subtype t_string_type   is t_vcharmax;
    type    t_strings_type  is table of t_string_type;

    subtype t_bool          is pls_integer range 0..1;  -- 0=false, 1=true
    subtype t_y_n_e         is pls_integer range -1..1; -- -1=error, 0=no, 1=yes

    -- ---------------------------------------------------------------------------------------------
    -- Public function returning all version information regarding this package
    function get_version_info
    return varchar2
    deterministic;

end hmx_types;
/
prompt *I: ScriptEOF hmx_types_pks.sql
