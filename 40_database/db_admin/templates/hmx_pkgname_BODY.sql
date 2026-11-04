prompt *I: ScriptBOF hmx_pkgname.sql
create or replace package body hmx_pkgname
as
/* <hmx-annotations>

  *TIP: Generate this block with tool HMX_GENERATE_ANNOTATION_BLOCK.SQL
  *TIP: Generate HMX_DB_VERSION line with tool HMX_GENERATE_ANNOTATION_VERSION_LINE.SQL

.HMX_OBJECT_USAGE: This package/script...

.HMX_OBJECT_NOTES:
    ?Package must be invoker rights (AUTHID CURRENT_USER)
    ...

.HMX_DEVELOPER_NOTES: See HMX General Developer Notes
.HMX_OBJECT_VERSION: 2026-10-21 12:17:12 CEST
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

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

-- =========================================== MAIN LINE ===========================================


-- -------------------------------------------------------------------------------------------------
-- package constructor
begin
  null;
--  dbms_output.enable(null);
--  dbms_output.put_line('*X: ' || $$PLSQL_UNIT || ' constructor @' || $$PLSQL_LINE
--    || chr(10) || '- USER............. =' || nvl(to_char(USER                                      ),'n/a')
--    || chr(10) || '- CURRENT_SCHEMA... =' || nvl(to_char(sys_context('USERENV','CURRENT_SCHEMA'   )),'n/a')
--    || chr(10) || '- CURRENT_USER..... =' || nvl(to_char(sys_context('USERENV','CURRENT_USER'     )),'n/a')
--    || chr(10) || '- SESSION_USER..... =' || nvl(to_char(sys_context('USERENV','SESSION_USER'     )),'n/a')
--    || chr(10) || '- OS_USER.......... =' || nvl(to_char(sys_context('USERENV','OS_USER'          )),'n/a')
--    || chr(10) || '- CLIENT_IDENTIFIER =' || nvl(to_char(sys_context('USERENV','CLIENT_IDENTIFIER')),'n/a')
--    || chr(10) || '- CLIENT_INFO...... =' || nvl(to_char(sys_context('USERENV','CLIENT_INFO')      ),'n/a')
--    || chr(10) || '- CLIENT_USER(utl). =' || nvl(to_char(hmx_session.get_client_userid             ),'n/a')
--    );

end hmx_pkgname;
/
prompt *I: ScriptEOF hmx_pkgname.sql
