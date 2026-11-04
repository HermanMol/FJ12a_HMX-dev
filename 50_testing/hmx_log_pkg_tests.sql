@hmx_spoolstart hmx_log_pkg_tests.sql
prompt *I: ScriptBOF hmx_log_pkg_tests.sql

set heading off
@hmx_session_info
set heading on

prompt *I: See the script file HMX_LOG_TESTS_01.SQL

prompt *I: ScriptEOF hmx_log_pkg_tests.sql
@hmx_spoolfinish
prompt Done.
