prompt *I: ScriptBOF hmx_pkg_name_pkb.sql
create or replace package body hmx_pkg_name
as
/* <hmx-annotations>

.HMX_OBJECT_VERSION 2026-10-19 11:39:04 CET
--> hmx_version_line_generator.sql

.HMX_OBJECT_REPO git@github.com:HermanMol/FJ12a_HMX-dev.git

.HMX_OBJECT_USAGE
    This package is a wrapper to manage database annotations.

.HMX_DB_VERSION Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0

.HMX_OBJECT_NOTES
    - Package must be invoker rights (AUTHID CURRENT_USER)
    - ...

.HMX_DEVELOPER_NOTES
    -- See HMX General Developer Notes

** </hmx-annotations> */

    -- ---------------------------------------------------------------------------------------------
    -- Public ...
    function ...
    return ...
    ...deterministic
    as
    begin
        null;
    end ...;


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

end hmx_pkg_name;
/
prompt *I: ScriptEOF hmx_pkg_name_pkb.sql
