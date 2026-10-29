exec hmx_log.log_run_script(pi_log_script => 'H:\20_projects\FJ12a_HMX-dev\10_wrk\40_database\hmx_call_stack\run_call_stack_tests.sql',pi_log_tags => 'FJ12a_HMX-dev');
exec hmx_log.log_run_script(pi_log_script => 'H:/20_projects/FJ12a_HMX-dev/10_wrk/40_database/hmx_call_stack/run_call_stack_tests.sql['||$$plsql_line||']',pi_log_tags => 'FJ12a_HMX-dev');
@hmx_spoolstart run_call_stack_tests.sql
prompt *I: ScriptBOF run_call_stack_tests.sql
/* <hmx-annotations>

.HMX_OBJECT_USAGE: Script for testing all public accessible methods in package HMX_CALL_STACK

.HMX_OBJECT_NOTES:
    Be aware of possible NLS settings messing up the test result.

.HMX_DEVELOPER_NOTES:
    - See HMX General Developer Notes

.HMX_OBJECT_VERSION: 2026-10-29 15:33:11 +01:00
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */

set heading off
@hmx_session_info
set heading on

-- ======================================= PROCESSING START ========================================
-- will be logged as called from __ANONYMOUS_BLOCK
begin
    hmx_log.log_msg
        (pi_log_msg   => 'Start running script RUN_CALL_STACK_TESTS.SQL'
        ,pi_log_level => hmx_log.k_normal
        ,pi_log_type  => hmx_log.k_testing
        ,pi_log_scope => hmx_log.k_tester
        ,pi_log_tags  => 'FJ12a,HMX-dev'
        ,pi_log_opt   => 0 --hmx_log.k_force
        );
end;
/

prompt *I: Executing script run_call_stack_tests.sql: Calling HMX_CALL_STACK_TESTS.P_MAIN;
exec hmx_call_stack_tests.p_main;

exec hmx_log.log_msg(pi_log_msg   => 'Finish running script RUN_CALL_STACK_TESTS.SQL');
prompt *I: ScriptEOF run_call_stack_tests.sql

@hmx_spoolfinish
 
