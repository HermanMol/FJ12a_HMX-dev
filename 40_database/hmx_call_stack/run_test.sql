prompt *I: ScriptBOF run_test.sql

@spoolstart run_test.sql

prompt *I: Executing script run_test.sql
prompt *I: Calling HMX_CALL_STACK_TESTS.P_MAIN;
exec hmx_call_stack_tests.p_main;
prompt *I: Finished run_test.sql

@spoolfinish

prompt *I: ScriptEOF run_test.sql
 