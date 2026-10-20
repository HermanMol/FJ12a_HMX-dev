prompt *I: ScriptBOF hmx_call_stack_pks.sql
create or replace package hmx_call_stack
is
/* <hmx-annotations>

.HMX_OBJECT_VERSION 2026-10-20 09:33:58 CEST

.HMX_OBJECT_REPO git@github.com:HermanMol/FJ12a_HMX-dev.git

.HMX_OBJECT_USAGE
    Package using Oracle UTL_CALL_STACK to get information about the call-stack, backtrace and error-stack.

.HMX_DB_VERSION Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0

.HMX_OBJECT_NOTES
    - hmx_call_stack.get_called_from
    - hmx_call_stack.get_backtrace
    - hmx_call_stack.get_error_stack

.HMX_DEVELOPER_NOTES
    - See HMX General Developer Notes

** </hmx-annotations> */
-- -------------------------------------------------------------------------------------------------

    k_anonymous_block constant varchar2(50) := lower('__anonymous_block'); -- default, see from oracle documentation

    -- ---------------------------------------------------------------------------------------------
    -- Public function that returns the object name and line number where this was called from.
    -- Parameters:
    -- - i_skip_units = optional comma-separated list of object-names to ignore when retrieving
    --     the object that called this function. this to enable calling this function from a logging
    --     module and ignoring that logging module entry in the call stack.
    function get_called_from
        (i_skip_units in varchar2 := null
        )
    return varchar2;

    -- ---------------------------------------------------------------------------------------------
    -- Public function that returns the backtrace as a LF-separated string.
    -- Only usefull during exception handling.
    -- In the absence of an exception the returned value is "(No backtrace)".
    function get_backtrace
    return varchar2;

    -- ---------------------------------------------------------------------------------------------
    -- Public function that returns the error_stack as a LF-separated string.
    -- Only usefull during exception handling.
    -- In the absence of an exception the returned value is "(No error_stack)".
    function get_error_stack
    return varchar2;

end hmx_call_stack;
/
prompt *I: ScriptEOF hmx_call_stack_pks.sql
