prompt *I: ScriptBOF hmx_call_stack_tests_pks.sql
create or replace package hmx_call_stack_tests 
as

/* <hmx-annotations>

.HMX_OBJECT_USAGE: This package is meant for testing the HMX_CALL_STACK - ONLY!

.HMX_OBJECT_NOTES:
    Package expected to be definer rights
    Testing:
    - hmx_call_stack.get_called_from
    - hmx_call_stack.get_backtrace
    - hmx_call_stack.get_error_stack

.HMX_DEVELOPER_NOTES: See HMX General Developer Notes
.HMX_OBJECT_VERSION: 2026-10-28 14:47:19 +01:00
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */
-- -------------------------------------------------------------------------------------------------

    procedure p_main;

end hmx_call_stack_tests;
/

prompt *I: ScriptEOF hmx_call_stack_tests_pks.sql
 