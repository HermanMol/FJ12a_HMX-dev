create or replace procedure hmx_test_log_module
    (pi_line in varchar2)
as
    -- This procedure is meant as AN EXAMPLE HOW TO USE THE HMX_CALL_STACK.GET_CALLED_FROM
    -- You may replace it by any of your (autonomous transaction?) logging module.
    -- But use the "i_skip_units => $$plsql_unit" to avoid the logging module being
    -- reported as the called_from unit ...
begin
    prt(pi_line || ' -- HMX_TEST_LOG_MODULE: ' || hmx_call_stack.get_called_from(i_skip_units => $$plsql_unit) ); -- ignore this unit
end hmx_test_log_module;
/
