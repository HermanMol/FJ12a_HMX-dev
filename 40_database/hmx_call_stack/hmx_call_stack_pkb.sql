prompt *I: ScriptBOF hmx_call_stack_pkb.sql
create or replace package body hmx_call_stack
is
/* <hmx-annotations>

.HMX_OBJECT_USAGE: Package using Oracle UTL_CALL_STACK to get information about the call-stack, backtrace and error-stack.

.HMX_OBJECT_NOTES:
    - hmx_call_stack.get_called_from
    - hmx_call_stack.get_backtrace
    - hmx_call_stack.get_error_stack

.HMX_DEVELOPER_NOTES: See HMX General Developer Notes
.HMX_OBJECT_VERSION: 2026-10-29 15:26:41 +01:00
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */

    -- ---------------------------------------------------------------------------------------------
    -- Public function that returns all details where this was called from.
    -- Parameters:
    -- - i_skip_units = optional comma-separated list of object-names to ignore when retrieving
    --     the object that called this function. this to enable calling this function from a logging
    --     module and ignoring that logging module entry in the call stack.
    function get_called_from_details
        (i_skip_units in varchar2 := null
        )
    return t_called_from_info_rec
    as
        lk_skip_units           constant varchar2(32767) := ',' || $$plsql_unit  -- this package is always ignored
                                                         || ',' || upper(i_skip_units) || ',';

        l_called_from_info_rec  t_called_from_info_rec;
        l_qualname              utl_call_stack.unit_qualified_name;
        l_idx                   pls_integer;
        l_current_unit          varchar2(32767 char);
        l_dynamic_depth         pls_integer;
        l_part_a                varchar2(32767 char);  -- log_org_object
        l_part_b                varchar2(32767 char);  -- log_org_method(s)
        l_part_c                varchar2(32767 char);
        l_dblink                varchar2(128 char);
        l_nextpos               binary_integer;

    begin
        l_called_from_info_rec.object_owner  := null;
        l_called_from_info_rec.object_type   := null;
        l_called_from_info_rec.object_name   := null;
        l_called_from_info_rec.object_method := null;
        l_called_from_info_rec.object_line   := null;
        l_called_from_info_rec.dynamic_depth := null;
        l_called_from_info_rec.call_depth    := null;

        l_dynamic_depth := nvl(utl_call_stack.dynamic_depth,0);
        l_called_from_info_rec.dynamic_depth := l_dynamic_depth;
        if l_dynamic_depth >= 1
        then
            <<walk_call_stack>>
            for l_idx in 1 .. l_dynamic_depth
            loop
                l_qualname := utl_call_stack.subprogram(dynamic_depth => l_idx);
                if l_qualname.exists(1)
                then
                    if instr(lk_skip_units, ',' || l_qualname(1) || ',') = 0    -- not a skipped unit
                    then
                        l_current_unit := upper(utl_call_stack.concatenate_subprogram(l_qualname));
                        -- prt('*D: l_current_unit=' || nvlc(l_current_unit) || '.');
                        -- Example output:
                        --   *D: l_current_unit=GDBLOG.get_called_from_details.
                        --   *D: l_current_unit=GDBLOG.LOG_MSG.
                        --   *D: l_current_unit=GDBLOG.__PKG_INIT.
                        --   *D: l_current_unit=__ANONYMOUS_BLOCK.
                        --   *D: l_current_unit=GDBLOG.get_called_from_details.
                        --   *D: l_current_unit=GDBLOG.LOG_MSG.
                        --   *D: l_current_unit=__ANONYMOUS_BLOCK.
                        if upper(l_qualname(1)) = upper(k_anonymous_block)
                        then
                            l_called_from_info_rec.object_name := substr(l_current_unit,1,128);
                        elsif upper(l_qualname(1)) = upper(k_pkg_init)
                        then
                            l_called_from_info_rec.object_owner := substr(utl_call_stack.owner(l_idx),1,128);
                            l_called_from_info_rec.object_name  := substr(l_current_unit,1,128);
                        else
                            l_called_from_info_rec.object_owner := substr(utl_call_stack.owner(l_idx),1,128);
                            dbms_utility.name_tokenize
                                (name    => l_current_unit
                                ,a       => l_part_a   -- out
                                ,b       => l_part_b   -- out
                                ,c       => l_part_c   -- out
                                ,dblink  => l_dblink   -- out
                                ,nextpos => l_nextpos  -- out
                                );
                            l_called_from_info_rec.object_name   := substr(nvl(l_part_a,'???'),1,128);
                            l_called_from_info_rec.object_method := substr(nvl(l_part_b,'???'),1,128);
                        end if;
                        l_called_from_info_rec.object_line := utl_call_stack.unit_line (l_idx);
                        l_called_from_info_rec.call_depth  := l_idx;
                        -- object_type  varchar2(128) is unfortunately not available on the call stack(? oracle 19?)
                        exit walk_call_stack;       -- because we found the first non-logging module
                    end if;
                end if;
            end loop walk_call_stack;
        end if;

        if  l_dynamic_depth < 1
        and l_called_from_info_rec.object_name is null
        then
            l_called_from_info_rec.object_name := '*W: ' || $$PLSQL_UNIT || '@' || $$PLSQL_LINE || ' dynamic depth < 1';
        end if;

        return l_called_from_info_rec;
    end get_called_from_details;

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
        l_called_from_info_rec  t_called_from_info_rec;
        l_retval                varchar2(32767);
    begin

        l_called_from_info_rec := get_called_from_details
            (i_skip_units => i_skip_units);

        if l_called_from_info_rec.dynamic_depth < 1
        then
            l_retval := '(Empty call_stack)';
         else
            l_retval := nvl(l_called_from_info_rec.object_owner,'*')
                     || nullif('.' || l_called_from_info_rec.object_name  , '.')
                     || nullif('.' || l_called_from_info_rec.object_method, '.')
                     || nullif('[' || l_called_from_info_rec.object_line || ']', '[]')
                     ;
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
