prompt *I: ScriptBOF hmx_call_stack_pkb.sql
create or replace package body hmx_call_stack
is
    c_body_version varchar2(20) := '2026-10-14 13:54:19';

    -- ---------------------------------------------------------------------------------------------
    -- public function that returns the object name and line number where this was called from
    -- parameters:
    -- - i_skip_objects = optional comma-separated list of object-names to ignore when retrieving
    --     the object that called this function. this to enable calling this function from a logging
    --     module and ignoring that logging module entry in the call stack.
    function get_called_from
        (i_skip_objects        in varchar2 := null
        )
    return varchar2
    as

        l_retval        varchar2(4000);
        l_session_id    varchar2(50);  -- tu_log_prefs.t_log_session_id;
        l_error_stack    varchar2(4000);
        l_call_stack    varchar2(4000);

        -- local workfields used in calls to UTL_CALL_STACK
        l_dynamic_depth    pls_integer;
        l_current_unit  varchar2(32767);
        l_origin        varchar2(32767);
        l_part_a        varchar2(32767);
        l_part_b        varchar2(32767);
        l_part_c        varchar2(32767);
        l_dblink        varchar2(128);
        l_nextpos        binary_integer;

        lk_skip_objects    constant varchar2(32767) := ',' || upper(i_skip_objects) || ',';

    begin


        l_extra_info := nullif(l_extra_info || chr(10),chr(10))
            || 'Connection:'
                || ' server_host='      ||  sys_context('userenv','server_host')
                || ',db_name='          || sys_context('userenv','db_name')
                || ',sid='              || sys_context('userenv','sid')
                || ',session_user='     || sys_context('userenv','session_user')
                || ',current_schema='   || sys_context('userenv','current_schema')
                || ',os_user='          || sys_context('userenv','os_user');

        l_dynamic_depth := nvl(utl_call_stack.dynamic_depth,0);
        if l_dynamic_depth < 1
        then
            l_retval := 'n/a';
        end if;

        -- Walk the call stack to find the first non-debug module. That is then the origin from
        -- where the debug log module was called. Optionally from another (old, deprecated?)
        -- module/object...
        <<walk_call_stack>>
        for l_idx in 1 .. l_dynamic_depth
        loop
            -- ignore the unit if it must be skipped
            if instr(lk_skip_objects,','||utl_call_stack.backtrace_unit(l_idx)||',') > 0
            then
                continue walk_call_stack;
            end if;

            l_current_unit := upper(utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(l_idx)));

            if  l_current_unit Not Like 'TU_LOG%'    -- ignore all calls from the regular logging package
            and l_current_unit Not Like 'DP_LOG%'    -- ignore all calls from this package
            and l_current_unit Not Like '%.QDBG%'    -- ignore these possible package level private method(s)
            Then
                If l_current_unit = k_anonymous
                Then
                    l_origin := 'anonymous_block';
                    If sys_context('userenv','session_user') = 'APEX_PUBLIC_USER'
                    Then
                        Begin
                            Select 'APEX:' || workspace
                            Into l_origin
                            From apex_workspaces
                            Where workspace_id = v('WORKSPACE_ID');
                            l_log_line.log_call_unit := coalesce(v('APP_ALIAS'),v('APP_ID'),'app?');
                            l_log_line.log_module     := coalesce(v('APP_PAGE_ALIAS'),v('APP_PAGE_ID'),'page?');
                        Exception
                            When Others
                            Then
                                l_origin                 := 'APEX:' || v('WORKSPACE_ID');
                                l_log_line.log_call_unit := nvl(v('APP_ALIAS'),'app?');
                                l_log_line.log_module     := nvl(v('APP_PAGE_ALIAS'),'page?');
                        End;
                    End If;
                Else
                    l_origin := utl_call_stack.owner(l_idx);
                    dbms_utility.name_tokenize
                        (Name     => l_current_unit
                        ,a         => l_part_a -- out
                        ,b         => l_part_b -- out
                        ,c         => l_part_c -- out
                        ,dblink     => l_dblink -- out
                        ,nextpos => l_nextpos -- out
                        );
                    l_log_line.log_call_unit := l_part_a; -- object
                    l_log_line.log_module    := l_part_b
                                                    || nullif('.' || l_part_c,'.')
                                                    || nullif('[' || l_dblink || ']','[]'); -- method(s)
                End If;
                l_extra_info := l_extra_info
                    || chr(10) || '#OWNER='     || l_origin || '.'
                    || chr(10) || '#LINE='      || utl_call_stack.unit_line(l_idx)
                    || chr(10) || '#CALLDEPTH=' || l_dynamic_depth
                    || '.';
                Exit walk_call_stack; -- because we found the first non-debug module
            End If;
        End Loop walk_call_stack;

        If l_dynamic_depth < 1
        Then
            l_origin := '*' || $$plsql_Unit || '.LOG[' || $$plsql_Line || ']';
        End If;

        l_log_line.log_text       := i_msg;
        l_log_line.log_level      := 16; -- tu_log_prefs.log_debug;
        l_log_line.log_call_unit  := coalesce(l_log_line.log_call_unit
                                             ,l_origin
                                             ,$$plsql_Unit
                                             );
        l_log_line.log_module     := coalesce(l_log_line.log_module ,'(n/a)');
        l_log_line.log_extra      := nullif( 'CLOB=' || i_clob || chr(10),'CLOB=' || chr(10) )
                                     || l_extra_info;
        l_log_line.log_call_stack := l_call_stack;
        l_log_line.log_session_id := tu_session_context.fn_get_session_id();
        l_log_line.log_timestamp  := current_timestamp;

        l_rowid := fn_savedb_logline#(l_log_line);

    End pr_qdbg;
$end
-- -------------------------------------------------------------------------------------------------
-- package constructor
Begin

$if atlas_env.k_is_dev or atlas_env.k_is_docker
$then
   -- dp_log.pr_qdbg('***** PACKAGE INSTANTIATED ***** ' || $$PLSQL_UNIT); -- too much especially with REST calls
   Null;
$else
   Null;
$end

-- NoFormat End
End dp_log;
/
prompt *I: ScriptEOF hmx_call_stack_pkb.sql
