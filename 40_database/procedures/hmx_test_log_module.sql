create or replace procedure hmx_test_log_module
    (pi_line in varchar2)
as
/* <hmx-annotations>

.HMX_OBJECT_USAGE: This procedure is meant as AN EXAMPLE HOW TO USE THE HMX_CALL_STACK.GET_CALLED_FROM

.HMX_OBJECT_NOTES:
You may replace it by any of your (autonomous transaction?) logging module. But use the 
"pi_skip_units => $$plsql_unit" to avoid the logging module being reported as the called_from unit.

.HMX_DEVELOPER_NOTES: See HMX General Developer Notes
.HMX_OBJECT_VERSION: 2026-11-06 16:11:08 +01:00
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */

begin
    prt(pi_line || ' -- HMX_TEST_LOG_MODULE: ' || hmx_call_stack.get_called_from(pi_skip_units => $$plsql_unit) ); -- ignore this unit
end hmx_test_log_module;
/
