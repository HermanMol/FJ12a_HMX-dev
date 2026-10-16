prompt *I: ScriptBOF hmx___pkb.sql
create or replace package body hmx_utl
as
    -- Package must be AUTHID CURRENT_USER

    k_body_version varchar2(20) := '2026-10-16 09:04:52';

    -- ---------------------------------------------------------------------------------------------
    -- Public function returning all version information regarding this package
    function get_version_info
    return varchar2
    deterministic
    as
    begin
        return 'Package ' || $$plsql_unit || ' version' || ': Spec='  || k_spec_version || ', Body='  || k_body_version;
    end get_version_info;


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

end hmx_session;
/
prompt *I: ScriptEOF hmx___pkb.sql
