prompt *I: ScriptBOF hmx_call_stack_tests_pkb.sql
create or replace package body hmx_call_stack_tests 
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
.HMX_OBJECT_VERSION: 2026-10-29 15:32:00 +01:00
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */

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
        raise_application_error(-20000,'My forced exception');
        prt('*I: End P_04');
    exception
        when others
        then
            hmx_log.log_msg
                (pi_log_msg   => 'This is error ' || sqlcode || ' in ' || $$plsql_unit || ' on line ' || $$plsql_line || '.'
                ,pi_log_level => hmx_log.k_error
                ,pi_log_type  => hmx_log.k_testing
                ,pi_log_scope => hmx_log.k_tester
                ,pi_log_tags  => 'FJ12a,HMX-dev'
                ,pi_log_opt   => 0 --hmx_log.k_force
                );
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
            hmx_log.log_msg
                (pi_log_msg   => 'This is error ' || sqlcode || ' in ' || $$plsql_unit || ' on line ' || $$plsql_line || '.'
                ,pi_log_level => hmx_log.k_error
                ,pi_log_type  => hmx_log.k_testing
                ,pi_log_scope => hmx_log.k_tester
                ,pi_log_tags  => 'FJ12a,HMX-dev'
                ,pi_log_opt   => 0 --hmx_log.k_force
                );
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
            hmx_log.log_msg
                (pi_log_msg   => 'This is error ' || sqlcode || ' in ' || $$plsql_unit || ' on line ' || $$plsql_line || '.'
                ,pi_log_level => hmx_log.k_error
                ,pi_log_type  => hmx_log.k_testing
                ,pi_log_scope => hmx_log.k_tester
                ,pi_log_tags  => 'FJ12a,HMX-dev'
                ,pi_log_opt   => 0 --hmx_log.k_force
                );
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
            hmx_log.log_msg
                (pi_log_msg   => 'This is error ' || sqlcode || ' in ' || $$plsql_unit || ' on line ' || $$plsql_line || '.'
                ,pi_log_level => hmx_log.k_error
                ,pi_log_type  => hmx_log.k_testing
                ,pi_log_scope => hmx_log.k_tester
                ,pi_log_tags  => 'FJ12a,HMX-dev'
                ,pi_log_opt   => 0 --hmx_log.k_force
                );
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
        hmx_log.log_msg
            (pi_log_msg   => 'Start running P_MAIN'
            ,pi_log_level => hmx_log.k_normal
            ,pi_log_type  => hmx_log.k_testing
            ,pi_log_scope => hmx_log.k_tester
            ,pi_log_tags  => 'FJ12a,HMX-dev'
            ,pi_log_opt   => 0 --hmx_log.k_force
            );

        prt('*I: Begin ' || $$plsql_unit || '.P_MAIN @ 2026-10-15 14:01:20');

        -- Next statement calls the hmx_call_stack.get_called_from (which itself will be skipped in the call-stack scanning).
        -- The <$$$ ... $$$> part will contain the actual name and linenumber of this statement in the package body source in the database.
        -- Keep next line as ONE line!
        hmx_test_log_module('*T: Called from = ' || hmx_call_stack.get_called_from(i_skip_units => null) || '<$$$' || $$PLSQL_UNIT_OWNER || '.' || $$PLSQL_UNIT || '[' || $$PLSQL_LINE || '] ' || $$PLSQL_UNIT_TYPE || '$$$>');
        prt('*T: BackTrace   = ' || hmx_call_stack.get_backtrace);
        prt('*T: Error_Stack = ' || hmx_call_stack.get_error_stack);
        p_01;

        hmx_log.log_msg
            (pi_log_msg   => 'Finish running P_MAIN'
            ,pi_log_level => hmx_log.k_normal
            ,pi_log_type  => hmx_log.k_testing
            ,pi_log_scope => hmx_log.k_tester
            ,pi_log_tags  => 'FJ12a,HMX-dev'
            ,pi_log_opt   => 0 --hmx_log.k_force
            );
        prt('*I: End ' || $$plsql_unit || '.P_MAIN');

    exception
        when others
        then
            hmx_log.log_msg
                (pi_log_msg   => 'This is error ' || sqlcode || ' in ' || $$plsql_unit || ' on line ' || $$plsql_line || '.'
                ,pi_log_level => hmx_log.k_error
                ,pi_log_type  => hmx_log.k_testing
                ,pi_log_scope => hmx_log.k_tester
                ,pi_log_tags  => 'FJ12a,HMX-dev'
                ,pi_log_opt   => 0 --hmx_log.k_force
                );
            prt('*E: ' || sqlerrm );
            prt('*W: Exception ' || $$plsql_unit);
            -- Keep next line as ONE line!
            hmx_test_log_module('*T: Called from = ' || hmx_call_stack.get_called_from(i_skip_units => null) || '<$$$' || $$PLSQL_UNIT_OWNER || '.' || $$PLSQL_UNIT || '[' || $$PLSQL_LINE || '] ' || $$PLSQL_UNIT_TYPE || '$$$>');
            prt('*T: BackTrace   = ' || hmx_call_stack.get_backtrace);
            prt('*T: Error_Stack = ' || hmx_call_stack.get_error_stack);
            prt(DBMS_UTILITY.FORMAT_CALL_STACK);
            prt('----- FORMAT_ERROR_BACKTRACE -----' || chr(10) || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            prt('----- FORMAT_ERROR_STACK -----'     || chr(10) || DBMS_UTILITY.FORMAT_ERROR_STACK);
            prt('*I: End ' || $$plsql_unit || '.P_MAIN');
            hmx_log.log_msg
                (pi_log_msg   => 'Exception running P_MAIN'
                ,pi_log_level => hmx_log.k_warning
                ,pi_log_type  => hmx_log.k_testing
                ,pi_log_scope => hmx_log.k_tester
                ,pi_log_tags  => 'FJ12a,HMX-dev'
                ,pi_log_opt   => 0 --hmx_log.k_force
                );
            raise;
    end p_main;
end hmx_call_stack_tests;
/
prompt *I: ScriptEOF hmx_call_stack_tests_pkb.sql
 