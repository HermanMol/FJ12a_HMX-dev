prompt *I: ScriptBOF hmx_call_stack_tests_pkb.sql
create or replace package body hmx_call_stack_tests 
as

    k_body_version varchar2(20) := '2026-10-15 15:15:23';

    -- ---------------------------------------------------------------------------------------------
    -- Public function returning all version information regarding this package
    function get_version_info
    return varchar2
    deterministic
    as
    begin
        return 'Package ' || $$plsql_unit || ' version' || ': Spec='  || k_spec_version || ', Body='  || k_body_version;
    end get_version_info;

    -- ---------------------------------------------------------------------------------------------
    -- Local procedure testing 
    -- - hmx_call_stack.get_called_from
    -- - hmx_call_stack.get_backtrace
    -- - hmx_call_stack.get_error_stack
    procedure P_04
    as
    begin
        prt('*I: Begin P_04');
        -- Keep next line as ONE line!
        hmx_test_log_module('*T: Called from = ' || hmx_call_stack.get_called_from(i_skip_units => null) || '<$$$' || $$PLSQL_UNIT_OWNER || '.' || $$PLSQL_UNIT || '[' || $$PLSQL_LINE || '] ' || $$PLSQL_UNIT_TYPE || '$$$>');
        prt('*T: BackTrace   = ' || hmx_call_stack.get_backtrace);
        prt('*T: Error_Stack = ' || hmx_call_stack.get_error_stack);
        PRT('*i: ... blablabla ...');
        raise_application_error(-20000,'My Exception');
        prt('*I: End P_04');
    exception
        when others
        then
            prt('*E: ' || sqlerrm );
            prt('*W: Exception ' || $$plsql_unit);
            -- Keep next line as ONE line!
            hmx_test_log_module('*T: Called from = ' || hmx_call_stack.get_called_from(i_skip_units => null) || '<$$$' || $$PLSQL_UNIT_OWNER || '.' || $$PLSQL_UNIT || '[' || $$PLSQL_LINE || '] ' || $$PLSQL_UNIT_TYPE || '$$$>');
            prt('*T: BackTrace   = ' || hmx_call_stack.get_backtrace);
            prt('*T: Error_Stack = ' || hmx_call_stack.get_error_stack);
            prt('FORMAT_CALL_STACK'      || chr(10) || DBMS_UTILITY.FORMAT_CALL_STACK);
            prt('FORMAT_ERROR_BACKTRACE' || chr(10) || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            prt('FORMAT_ERROR_STACK'     || chr(10) || DBMS_UTILITY.FORMAT_ERROR_STACK);
            prt('*I: End P_04');
            raise;
    end P_04;

    -- ---------------------------------------------------------------------------------------------
    -- Local procedure testing 
    -- - hmx_call_stack.get_called_from
    -- - hmx_call_stack.get_backtrace
    -- - hmx_call_stack.get_error_stack
    procedure P_03
    as
    begin
        prt('*I: Begin P_03');
        -- Keep next line as ONE line!
        hmx_test_log_module('*T: Called from = ' || hmx_call_stack.get_called_from(i_skip_units => null) || '<$$$' || $$PLSQL_UNIT_OWNER || '.' || $$PLSQL_UNIT || '[' || $$PLSQL_LINE || '] ' || $$PLSQL_UNIT_TYPE || '$$$>');
        prt('*T: BackTrace   = ' || hmx_call_stack.get_backtrace);
        prt('*T: Error_Stack = ' || hmx_call_stack.get_error_stack);
        p_04;
        prt('*I: End P_03');
    exception
        when others
        then
            prt('*E: ' || sqlerrm );
            prt('*W: Exception ' || $$plsql_unit);
            -- Keep next line as ONE line!
            hmx_test_log_module('*T: Called from = ' || hmx_call_stack.get_called_from(i_skip_units => null) || '<$$$' || $$PLSQL_UNIT_OWNER || '.' || $$PLSQL_UNIT || '[' || $$PLSQL_LINE || '] ' || $$PLSQL_UNIT_TYPE || '$$$>');
            prt('*T: BackTrace   = ' || hmx_call_stack.get_backtrace);
            prt('*T: Error_Stack = ' || hmx_call_stack.get_error_stack);
            prt('FORMAT_CALL_STACK'      || chr(10) || DBMS_UTILITY.FORMAT_CALL_STACK);
            prt('FORMAT_ERROR_BACKTRACE' || chr(10) || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            prt('FORMAT_ERROR_STACK'     || chr(10) || DBMS_UTILITY.FORMAT_ERROR_STACK);
            prt('*I: End P_03');
            raise;
    end P_03;

    -- ---------------------------------------------------------------------------------------------
    -- Local procedure testing 
    -- - hmx_call_stack.get_called_from
    -- - hmx_call_stack.get_backtrace
    -- - hmx_call_stack.get_error_stack
    procedure p_02
    as
    begin
        prt('*I: Begin p_02');
        -- Keep next line as ONE line!
        hmx_test_log_module('*T: Called from = ' || hmx_call_stack.get_called_from(i_skip_units => null) || '<$$$' || $$PLSQL_UNIT_OWNER || '.' || $$PLSQL_UNIT || '[' || $$PLSQL_LINE || '] ' || $$PLSQL_UNIT_TYPE || '$$$>');
        prt('*T: BackTrace   = ' || hmx_call_stack.get_backtrace);
        prt('*T: Error_Stack = ' || hmx_call_stack.get_error_stack);
        p_03;
        prt('*I: End p_02');
    exception
        when others
        then
            prt('*E: ' || sqlerrm );
            prt('*W: Exception ' || $$plsql_unit);
            -- Keep next line as ONE line!
            hmx_test_log_module('*T: Called from = ' || hmx_call_stack.get_called_from(i_skip_units => null) || '<$$$' || $$PLSQL_UNIT_OWNER || '.' || $$PLSQL_UNIT || '[' || $$PLSQL_LINE || '] ' || $$PLSQL_UNIT_TYPE || '$$$>');
            prt('*T: BackTrace   = ' || hmx_call_stack.get_backtrace);
            prt('*T: Error_Stack = ' || hmx_call_stack.get_error_stack);
            prt('FORMAT_CALL_STACK'      || chr(10) || DBMS_UTILITY.FORMAT_CALL_STACK);
            prt('FORMAT_ERROR_BACKTRACE' || chr(10) || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            prt('FORMAT_ERROR_STACK'     || chr(10) || DBMS_UTILITY.FORMAT_ERROR_STACK);
            prt('*I: End P_02');
            raise;
    end p_02;

    -- ---------------------------------------------------------------------------------------------
    -- Local procedure testing 
    -- - hmx_call_stack.get_called_from
    -- - hmx_call_stack.get_backtrace
    -- - hmx_call_stack.get_error_stack
    procedure P_01
    as
    begin
        prt('*I: Begin P_01');
        -- Keep next line as ONE line!
        hmx_test_log_module('*T: Called from = ' || hmx_call_stack.get_called_from(i_skip_units => null) || '<$$$' || $$PLSQL_UNIT_OWNER || '.' || $$PLSQL_UNIT || '[' || $$PLSQL_LINE || '] ' || $$PLSQL_UNIT_TYPE || '$$$>');
        prt('*T: BackTrace   = ' || hmx_call_stack.get_backtrace);
        prt('*T: Error_Stack = ' || hmx_call_stack.get_error_stack);
        P_02;
        prt('*I: End P_01');
    exception
        when others
        then
            prt('*E: ' || sqlerrm );
            prt('*W: Exception ' || $$plsql_unit);
            -- Keep next line as ONE line!
            hmx_test_log_module('*T: Called from = ' || hmx_call_stack.get_called_from(i_skip_units => null) || '<$$$' || $$PLSQL_UNIT_OWNER || '.' || $$PLSQL_UNIT || '[' || $$PLSQL_LINE || '] ' || $$PLSQL_UNIT_TYPE || '$$$>');
            prt('*T: BackTrace   = ' || hmx_call_stack.get_backtrace);
            prt('*T: Error_Stack = ' || hmx_call_stack.get_error_stack);
            prt('FORMAT_CALL_STACK'      || chr(10) || DBMS_UTILITY.FORMAT_CALL_STACK);
            prt('FORMAT_ERROR_BACKTRACE' || chr(10) || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            prt('FORMAT_ERROR_STACK'     || chr(10) || DBMS_UTILITY.FORMAT_ERROR_STACK);
            prt('*I: End P_01');
            raise;
    end P_01;

    -- ---------------------------------------------------------------------------------------------
    -- Public procedure testing 
    -- - hmx_call_stack.get_called_from
    -- - hmx_call_stack.get_backtrace
    -- - hmx_call_stack.get_error_stack
    procedure p_main
    as
    begin
        prt('*I: Begin ' || $$plsql_unit || '.P_MAIN @ 2026-10-15 14:01:20');

        -- Next statement calls the hmx_call_stack.get_called_from (which itself will be skipped in the call-stack scanning).
        -- The <$$$ ... $$$> part will contain the actual name and linenumber of this statement in the package body source in the database.
        -- Keep next line as ONE line!
        hmx_test_log_module('*T: Called from = ' || hmx_call_stack.get_called_from(i_skip_units => null) || '<$$$' || $$PLSQL_UNIT_OWNER || '.' || $$PLSQL_UNIT || '[' || $$PLSQL_LINE || '] ' || $$PLSQL_UNIT_TYPE || '$$$>');
        prt('*T: BackTrace   = ' || hmx_call_stack.get_backtrace);
        prt('*T: Error_Stack = ' || hmx_call_stack.get_error_stack);
        p_01;

        prt('*I: End ' || $$plsql_unit || '.P_MAIN');

    exception
        when others
        then
            prt('*E: ' || sqlerrm );
            prt('*W: Exception ' || $$plsql_unit);
            -- Keep next line as ONE line!
            hmx_test_log_module('*T: Called from = ' || hmx_call_stack.get_called_from(i_skip_units => null) || '<$$$' || $$PLSQL_UNIT_OWNER || '.' || $$PLSQL_UNIT || '[' || $$PLSQL_LINE || '] ' || $$PLSQL_UNIT_TYPE || '$$$>');
            prt('*T: BackTrace   = ' || hmx_call_stack.get_backtrace);
            prt('*T: Error_Stack = ' || hmx_call_stack.get_error_stack);
            prt('FORMAT_CALL_STACK'      || chr(10) || DBMS_UTILITY.FORMAT_CALL_STACK);
            prt('FORMAT_ERROR_BACKTRACE' || chr(10) || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            prt('FORMAT_ERROR_STACK'     || chr(10) || DBMS_UTILITY.FORMAT_ERROR_STACK);
            prt('*I: End ' || $$plsql_unit || '.P_MAIN');
            raise;
    end p_main;
end hmx_call_stack_tests;
/
prompt *I: ScriptEOF hmx_call_stack_tests_pkb.sql
 