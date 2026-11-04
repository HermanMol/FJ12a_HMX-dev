@hmx_spoolstart hmx_ddl_log_pkg_tests.sql
prompt *I: ScriptBOF hmx_ddl_log_pkg_tests.sql

set heading off
@hmx_session_info
set heading on

prompt: TODO hmx_ddl_log_pkg_tests.sql

prompt *I: ScriptEOF hmx_ddl_log_pkg_tests.sql
@hmx_spoolfinish
prompt Done.
