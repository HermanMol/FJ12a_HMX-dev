@hmx_spoolstart hmx_session_pkg_tests.sql
prompt *I: ScriptBOF hmx_session_pkg_tests.sql

set heading off
@hmx_session_info
set heading on

prompt *A: TODO hmx_session_pkg_tests.sql

prompt *I: ScriptEOF hmx_session_pkg_tests.sql
@hmx_spoolfinish
prompt Done.
