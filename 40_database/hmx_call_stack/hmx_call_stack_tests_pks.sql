prompt *I: ScriptBOF hmx_call_stack_tests_pks.sql
create or replace package hmx_call_stack_tests 
as

-- -------------------------------------------------------------------------------------------------
-- Package to test the package hmx_call_stack:
-- - hmx_call_stack.get_called_from
-- - hmx_call_stack.get_backtrace
-- - hmx_call_stack.get_error_stack

    k_spec_version    constant varchar2(20) := '2026-10-15 15:15:31';

    -- ---------------------------------------------------------------------------------------------
    -- Public function returning all version information regarding this package
    function get_version_info
    return varchar2
    deterministic;

    procedure p_main;

end hmx_call_stack_tests;
/

prompt *I: ScriptEOF hmx_call_stack_tests_pks.sql
 