prompt *I: ScriptBOF pr_call_stack.sql
create or replace procedure pr_call_stack
    (i_skip_units in varchar2 := null)
as

    l_valc          varchar2(32767);
    l_valn          number;

    l_qualname      utl_call_stack.unit_qualified_name;
    l_depth         pls_integer;
    l_current_unit  Varchar2(32767);

    lk_skip_units   varchar2(32767)          := ',' || upper(i_skip_units) || ',';
    lk_anonymous_block constant varchar2(50) := lower('__anonymous_block'); -- default, see from oracle documentation

    -- Efficient alias for lengthy original
    procedure prt(i_line in varchar2) as begin dbms_output.put_line(i_line); end prt;

-- =========================================== MAIN LINE ===========================================
begin

    prt('*I: Begin ' || $$plsql_unit);

    <<process_call_stack>>
    begin
        prt('*I: Process Call Stack');
        l_depth := nvl(utl_call_stack.dynamic_depth,0);
        if l_depth < 1
        then
            prt('*I: no call_stack');
         else
            prt('*I: Dynamic depth = ' || l_depth);
            <<walk_call_stack>>
            for l_idx in 1 .. l_depth
            loop
                -- l_current_unit := upper(utl_call_stack.concatenate_subprogram(utl_call_stack.subprogram(l_idx)));
                -- prt('*D: current unit = ' || l_current_unit);
                l_qualname := utl_call_stack.subprogram(dynamic_depth => l_idx);
                if l_qualname.exists(1)
                then
                    if instr(lk_skip_units,','||l_qualname(1)||',') = 0
                    then
                        prt(rpad('-',l_depth,'.')
                            ||'*I: call stack unit_qualified_name [' || l_idx || '] '
                            || ' = ' || utl_call_stack.owner(dynamic_depth => l_idx)
                            || '.'   || utl_call_stack.concatenate_subprogram(l_qualname)
                            || ' # ' || utl_call_stack.unit_line(dynamic_depth => l_idx)
                            || ' ~ ' || nvl(utl_call_stack.LEXICAL_DEPTH(dynamic_depth => l_idx),0)
                            );
                    else
                        prt(rpad('-',l_depth,'.')||'*I: (skipped: ' || l_qualname(1) || ')');
                    end if;
                else
                    prt(rpad('-',l_depth,'.')||'*I: call stack unit_qualified_name ' || l_idx || ' does NOT exist.');
                end if;
            End Loop walk_call_stack;
        end if;
    end process_call_stack;

    <<process_backtrace_stack>>
    begin
        l_depth := nvl(utl_call_stack.backtrace_depth,0);
        if l_depth < 1
        then
            prt('*I: no backtrace_stack');
        else
            <<walk_backtrace_stack>>
            for l_idx in 1 .. l_depth
            loop
                l_valc := utl_call_stack.backtrace_unit(backtrace_depth => l_idx);
                prt('*I: BackTrace unit [' || l_idx || '] = ' || nvl(l_valc,'n/a') );
            End Loop walk_backtrace_stack;
        end if;
    end process_backtrace_stack;

    <<process_error_stack>>
    begin
        l_depth := nvl(utl_call_stack.error_depth,0);
        if l_depth < 1
        then
            prt('*I: no error_stack');
        else
            <<walk_error_stack>>
            for l_idx in 1 .. l_depth
            loop
                l_valc := utl_call_stack.error_msg(error_depth => l_idx);
                l_valn := utl_call_stack.error_number(error_depth => l_idx);
                prt('*I: error [' || l_idx || '] = ' || nvl(to_char(l_valn),'NaN    ')  || ' - '  || nvl(l_valc,'n/a') );
            End Loop walk_error_stack;
        end if;
    end process_error_stack;

    prt('*I: End ' || $$plsql_unit);

end pr_call_stack;
/
show errors

prompt *I: ScriptEOF pr_call_stack.sql
