prompt *I: ScriptBOF hmx_call_stack_pkb.sql
create or replace package body hmx_call_stack
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

    -- ---------------------------------------------------------------------------------------------
    -- Public function that returns the object name and line number where this was called from.
    -- Parameters:
    -- - i_skip_units = optional comma-separated list of object-names to ignore when retrieving
    --     the object that called this function. this to enable calling this function from a logging
    --     module and ignoring that logging module entry in the call stack.
    function get_called_from
        (i_skip_units in varchar2 := null
        )
    return varchar2
    as

        lk_skip_units   constant varchar2(32767) := ',' || $$plsql_unit  -- this package is always ignored
                                                 || ',' || upper(i_skip_units) || ',';
        l_depth         pls_integer;
        l_retval        varchar2(32767);
        l_qualname      utl_call_stack.unit_qualified_name;

    -- =========================================== MAIN LINE ===========================================
    begin

        l_depth := nvl(utl_call_stack.dynamic_depth,0);
        if l_depth < 1
        then
            l_retval := '(Empty call_stack)';
         else
            <<walk_call_stack>>
            for l_idx in 1 .. l_depth
            loop
                l_qualname := utl_call_stack.subprogram(dynamic_depth => l_idx);
                if l_qualname.exists(1)
                then
                    if instr(lk_skip_units, ',' || l_qualname(1) || ',') = 0
                    then
                        l_retval := utl_call_stack.owner(dynamic_depth => l_idx)
                            || '.'   || utl_call_stack.concatenate_subprogram(l_qualname)
                            || '[' || utl_call_stack.unit_line(dynamic_depth => l_idx) || ']';
                        -- we found the owner.object[line] where this was called from, so we are done.
                        exit walk_call_stack;   
                    end if;
                else
                    -- Hu? Strange, no first entry in the subprogram varray...?
                    -- Ignore for now?
                    -- prt(rpad('-',l_depth,'.')||'*E: call stack unit_qualified_name ' || l_idx || ' does NOT exist.');
                    null;
                end if;
            End Loop walk_call_stack;
        end if;

        return l_retval;
    end get_called_from;

    -- ---------------------------------------------------------------------------------------------
    -- Public function that returns the backtrace as a LF-separated string.
    -- Only usefull during exception handling.
    -- In the absence of an exception the returned value is "(No backtrace)".
    -- Parameters: none.
    function get_backtrace
    return varchar2
    as
        l_depth     number;
        l_retval    varchar2(4000);
    begin
        l_depth := nvl(utl_call_stack.backtrace_depth,0);
        if l_depth < 1
        then
            l_retval := '(No backtrace)';
        else
            <<walk_backtrace_stack>>
            for l_idx in 1 .. l_depth
            loop
                l_retval := nullif(l_retval || chr(10), chr(10) )
                    || utl_call_stack.backtrace_unit(backtrace_depth => l_idx);
            End Loop walk_backtrace_stack;
        end if;
        return l_retval;
    end get_backtrace;

    -- ---------------------------------------------------------------------------------------------
    -- Public function that returns the error-stack as a LF-separated string.
    -- Only usefull during exception handling.
    -- In the absence of an exception the returned value is "(No backtrace)".
    -- Parameters: none.

    function get_error_stack
    return varchar2
    as
        l_depth     number;
        l_retval    varchar2(4000);
    begin
        l_depth := nvl(utl_call_stack.error_depth,0);
        if l_depth < 1
        then
            l_retval := '(No error_stack)';
        else
            <<walk_error_stack>>
            for l_idx in 1 .. l_depth
            loop
                l_retval := nullif(l_retval || chr(10), chr(10) )
                    || utl_call_stack.error_number(error_depth => l_idx)
                    || ' - ' || utl_call_stack.error_msg(error_depth => l_idx);
            End Loop walk_error_stack;
        end if;
        return l_retval;
    end get_error_stack;

-- -------------------------------------------------------------------------------------------------
-- package constructor
Begin
   -- prt('***** PACKAGE INSTANTIATED ***** ' || $$PLSQL_UNIT);
   Null;
End hmx_call_stack;
/
prompt *I: ScriptEOF hmx_call_stack_pkb.sql
