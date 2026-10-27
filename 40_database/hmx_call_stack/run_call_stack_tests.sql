prompt *I: ScriptBOF run_call_stack_tests.sql

@hmx_spoolstart run_call_stack_tests.sql

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

prompt *I: Executing script run_test.sql
prompt *I: Calling HMX_CALL_STACK_TESTS.P_MAIN;
exec hmx_call_stack_tests.p_main;
prompt *I: Finished run_test.sql

exec hmx_log.log_msg(pi_log_msg   => 'Finish running script RUN_CALL_STACK_TESTS.SQL');

@hmx_spoolfinish
 
prompt *I: ScriptEOF run_call_stack_tests.sql
