@hmx_spoolstart hmx_call_stack_pkg_tests.sql
prompt *I: ScriptBOF hmx_call_stack_pkg_tests.sql
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

prompt *I: testing LOG_RUN_SCRIPT using different PLATFORM_SLASH \ or / extracting the actual script filename properly
exec hmx_log.log_run_script(pi_log_script => 'H:\20_projects\FJ12a_HMX-dev\10_wrk\40_database\hmx_call_stack\hmx_call_stack_pkg_tests.sql['||$$plsql_line||']',pi_log_tags => 'backslash');
exec hmx_log.log_run_script(pi_log_script => 'H:/20_projects/FJ12a_HMX-dev/10_wrk/40_database/hmx_call_stack/hmx_call_stack_pkg_tests.sql['||$$plsql_line||']',pi_log_tags => 'forward slash');
exec hmx_log.log_run_script(pi_log_script => 'hmx_call_stack_pkg_tests.sql['||$$plsql_line||']',pi_log_tags => 'nopath');

-- will be logged as called from __ANONYMOUS_BLOCK
begin
    hmx_log.log_msg
        (pi_log_msg   => 'Running HMX_LOG.LOG_MSG in a script.'
        ,pi_log_level => hmx_log.k_normal
        ,pi_log_type  => hmx_log.k_testing
        ,pi_log_scope => hmx_log.k_tester
        ,pi_log_tags  => 'FJ12a,HMX-dev'
        ,pi_log_opt   => 0 --hmx_log.k_force
        );
end;
/
-- will be logged as called from __ANONYMOUS_BLOCK
declare
    procedure local_log
    as
    begin
        hmx_log.log_msg
            (pi_log_msg   => 'Running HMX_LOG.LOG_MSG from a local procedure LOC_LOG in a script.'
            ,pi_log_level => hmx_log.k_normal
            ,pi_log_type  => hmx_log.k_testing
            ,pi_log_scope => hmx_log.k_tester
            ,pi_log_tags  => 'FJ12a,HMX-dev'
            ,pi_log_opt   => 0 --hmx_log.k_force
            );
    end local_log;
begin
    local_log;
end;
/

prompt *I: Executing script run_call_stack_tests.sql: Calling HMX_CALL_STACK_TESTS.P_MAIN;
exec hmx_call_stack_tests.p_main;

exec hmx_log.log_msg(pi_log_msg   => 'Finish running script RUN_CALL_STACK_TESTS.SQL');

prompt *I: ScriptEOF hmx_call_stack_pkg_tests.sql
@hmx_spoolfinish
prompt Done.
