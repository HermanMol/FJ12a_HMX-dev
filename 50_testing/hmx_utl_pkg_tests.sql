@hmx_spoolstart hmx_utl_pkg_tests.sql
prompt *I: ScriptBOF hmx_utl_pkg_tests.sql
/* <hmx-annotations>

.HMX_OBJECT_USAGE: Script for testing all public accessible methods in package HMX_UTL

.HMX_OBJECT_NOTES:
    Be aware of possible NLS settings messing up the test result.

.HMX_DEVELOPER_NOTES:
    - See HMX General Developer Notes

.HMX_OBJECT_VERSION: 2026-10-28 12:32:51 +01:00
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */

set heading off
@hmx_session_info
set heading on

-- ======================================= PROCESSING START ========================================
declare
    k_line_offset   constant number := 24 - $$plsql_line;   -- the literal must be the actual line number of THIS script line.
    k_format_num    constant varchar2(40) := '99999999999999999999999999990d0000000000';
    k_format_date   constant varchar2(23) := 'yyyy-mm-dd"T"hh24:mi:ss';
    k_pass          constant varchar2(4) := 'PASS';
    k_fail          constant varchar2(4) := 'FAIL';
    k_error         constant varchar2(5) := 'ERROR';

    "\t"  constant varchar2(1) := chr(09);

    l_test          varchar2(32767);
    l_result_char   varchar2(32767);
    l_expected_char varchar2(32767);
    l_result_num    number;
    l_expected_num  number;
    l_result_date   date;
    l_expected_date date;

    -- counting the results, reported at the end
    type count_result_type is table of number index by varchar2(5);
    l_counters  count_result_type := count_result_type();

    -- ======================================= LOCAL METHODS =======================================

    -- Enable skipping print (using lprt) of debug lines starting with "*D: ".
    procedure lprt( pi_text in varchar2 := null)
    as
    begin
        if substr(pi_text,1,4) = '*D: '
        then
            null;
            return; -- no debugging
        end if;
        prt(pi_text);
    end lprt;

    -- Simple quickies
    function prtval   (pi_val in varchar2)      return varchar2 as begin return '{' || pi_val || '}';            end prtval;
    function prtline# (pi_plsql_line in number) return number   as begin return (k_line_offset + pi_plsql_line); end prtline#;
    procedure incr(pio_num in out number, pi_incr number := 1)  as begin pio_num := nvl(pio_num,0) + pi_incr;    end incr;

    -- procedure to report the object version being tested
    procedure print_object_version
    as
        l_hmx_object_versions hmx_annotations.hmx_object_version_arr;
    begin
        lprt('*I: Tested version of HMX_UTL:');
        lprt('Owner, Type, Name, Version');
        for r_version_data in
        (   select object_owner
                ,object_name
                ,object_type
                ,object_version
            from hmx_annotations.get_object_version
                (pi_owner       => sys_context('USERENV','CURRENT_SCHEMA')
                ,pi_object_name => 'HMX_UTL'
                )
        )
        loop
            lprt(r_version_data.object_owner
                || ', ' || r_version_data.object_name
                || ', ' || r_version_data.object_type
                || ', ' || r_version_data.object_version
                );
        end loop;
    end print_object_version;

    -- ---------------------------------------------------------------------------------------------
    -- Procedure to check if the result matches the expected value
    -- The outcome of the match is either PASS or FAIL and printed on the spool.
    -- Any check is ALWAYS case SENSITIVE!
    -- - pi_plsql_line = the line on which the call to this check_pass_fail is located in this script file.
    -- - pi_test       = a one-line description of the test
    -- - pi_expected   = the expected value
    -- - pi_result     = the resulted value
    -- - pi_compare_op = the compare operator, default is "="
    --   Examples for pi_compare_op:
    --   - "=" ........: pi_result = pi_expected
    --   - "<>" .......: pi_result <> pi_expected
    --   - "rx_match"..: regexp_count(pi_result, pi_expected, 1, 'c')
    --   - "like"......: pi_result like pi_expected escape '^'
    procedure check_pass_fail
        (pi_plsql_line in number
        ,pi_test       in varchar2
        ,pi_expected   in varchar2
        ,pi_result     in varchar2
        ,pi_compare_op in varchar2 := '='    -- Possible are: =, <>, rx_match, like
        )
    as
        l_check varchar2(5);
    begin

        if  pi_compare_op = '='
        then
            lprt('*D: ' || pi_compare_op || '(''' || pi_result || ''',''' || pi_expected || ''';');
            if  pi_expected is null
            and pi_result   is null
            then
                l_check := k_pass;
            else
                l_check := case when pi_expected = pi_result then k_pass else k_fail end;
            end if;

        elsif pi_compare_op = '<>'
        then
            lprt('*D: ' || pi_compare_op || '(''' || pi_result || ''',''' || pi_expected || ''';');
            l_check := case when pi_expected <> pi_result then k_pass else k_fail end;

        elsif lower(pi_compare_op) = 'rx_match'
        then
            lprt('*D: ' || pi_compare_op || '(''' || pi_result || ''',''' || pi_expected || ''',1,''c'')');
            l_check := case when regexp_count(pi_result, pi_expected,1,'c') > 0 then k_pass else k_fail end;

        elsif lower(pi_compare_op) = 'like'
        then
            lprt('*D: ' || pi_compare_op || '(''' || pi_result || ''',''' || pi_expected || ''';');
            l_check := case when pi_result like pi_expected then k_pass else k_fail end;

        else
            lprt('*D: ERROR, unanticipated compare operator: "' || pi_compare_op || '"');
            l_check := k_error;
        end if;

        incr(l_counters(l_check));

        lprt('[' || trim(to_char(prtline#(pi_plsql_line), '0000')) || ']'
            || ' ' || l_check || ' : '  || pi_test
            || ' - expected='  || prtval(pi_expected)
            || '; result='     || prtval(pi_result)
            || '; compare_op=' || prtval(pi_compare_op)
            );
    exception
        when others
        then
            hmx_log.log_msg('This is going wrong: ' || sqlerrm);
            raise;
    end check_pass_fail;
    -- Overload for numeric checks
    procedure check_pass_fail
        (pi_plsql_line in number
        ,pi_test       in varchar2
        ,pi_expected   in number
        ,pi_result     in number
        ,pi_compare_op in varchar2 := '='    -- Possible are: =, <>, rx_match, like
        )
    as
        l_check varchar2(5);
    begin
        lprt('*D: performing the numeric check_pass_fail');
        check_pass_fail
            (pi_plsql_line => pi_plsql_line
            ,pi_test       => pi_test
            ,pi_expected   => to_char(pi_expected)
            ,pi_result     => to_char(pi_result)
            ,pi_compare_op => pi_compare_op
            );
    end check_pass_fail;
    -- Overload for date checks
    procedure check_pass_fail
        (pi_plsql_line in number
        ,pi_test       in varchar2
        ,pi_expected   in date
        ,pi_result     in date
        ,pi_compare_op in varchar2 := '='    -- Possible are: =, <>, rx_match, like
        )
    as
        l_check varchar2(5);
    begin
        lprt('*D: performing the date check_pass_fail');
        check_pass_fail
            (pi_plsql_line => pi_plsql_line
            ,pi_test       => pi_test
            ,pi_expected   => to_char(pi_expected)
            ,pi_result     => to_char(pi_result)
            ,pi_compare_op => pi_compare_op
            );
    end check_pass_fail;

-- =========================================== MAIN LINE ===========================================
begin
    lprt ('*I: Started MAIN LINE');

    lprt('*I: - Line Offset  = ' || prtval( to_char(k_line_offset) || '+' || $$plsql_line ) );
    lprt('*I: - Script line  = ' || prtval( to_char(prtline#($$plsql_line) ) ) );
    lprt('*I: - 123456 / 423 = ' || prtval( to_char(123456 / 423,k_format_num) ) );
    lprt('*I: - Now          = ' || prtval( to_char(current_date,k_format_date) ) );
    lprt;
    print_object_version;
    lprt;
    lprt('....+....1....+....2....+....3....+....4....+....5....+....6....+....7....+....8....+....9....+....1');
    lprt('*I: Begin of test results.');

    l_counters(k_pass) := 0;
    l_counters(k_fail) := 0;
    l_counters(k_error) := 0;

    -- -------------------
    -- NVLC for characters
    -- -------------------

    l_test := '01 - Test hmx_utl.nvlc for characters: PASS';
    l_result_char := hmx_utl.nvlc(pi_cvalue => 'Test 01');
    l_expected_char := 'Test 01';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '02 - Test hmx_utl.nvlc for characters with a NULL-default not being used: PASS';
    l_result_char := hmx_utl.nvlc(pi_cvalue => 'Test 02', pi_ifnull => 'NiXX');
    l_expected_char := 'Test 02';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '03 - Test hmx_utl.nvlc for characters with a NULL-default being used: PASS';
    l_result_char := hmx_utl.nvlc(pi_cvalue => null, pi_ifnull => 'nIxx');
    l_expected_char := 'nIxx';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '04 - Test hmx_utl.nvlc for characters not equal : PASS';
    l_result_char := hmx_utl.nvlc(pi_cvalue => 'abcdef', pi_ifnull => 'nuLL');
    l_expected_char := 'fedcba';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char, '<>');

    l_test := '05 - Test hmx_utl.nvlc for characters regexp_count>0 : PASS';
    l_result_char := hmx_utl.nvlc(pi_cvalue => 'adcbef', pi_ifnull => 'nuLL');
    l_expected_char := '^a[b-d]+ef$';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char, 'rx_match');

    l_test := '06 - Test Wrong compare operator : ERROR';
    l_result_char := hmx_utl.nvlc(pi_cvalue => 'adcbef');
    l_expected_char := 'ABCDEF';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char, 'regexp_count');

    -- ----------------
    -- NVLC for numbers
    -- ----------------

    l_test := '07 - Test hmx_utl.nvlc for numbers: PASS';
    l_result_char := hmx_utl.nvlc(pi_nvalue => 1234567.089);
    l_expected_char := '1234567.089';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '08 - Test hmx_utl.nvlc for numbers with a NULL-default not being used: PASS';
    l_result_char := hmx_utl.nvlc(pi_nvalue => 7654321.809, pi_ifnull => 'NiXX');
    l_expected_char := '7654321.809';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '09 - Test hmx_utl.nvlc for numbers with a NULL-default being used: PASS';
    l_result_char := hmx_utl.nvlc(pi_nvalue => to_number(null), pi_ifnull => 'nIxx');
    l_expected_char := 'nIxx';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '10 - Test hmx_utl.nvlc for numbers not equal : PASS';
    l_result_char := hmx_utl.nvlc(pi_nvalue => 6754321.908, pi_ifnull => 'nuLL');
    l_expected_char := '5764321.809';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char, '<>');

    l_test := '11 - Test hmx_utl.nvlc for numbers regexp_count>0 : PASS';
    l_result_char := hmx_utl.nvlc(pi_nvalue => 4765321.435, pi_ifnull => 'nuLL');
    l_expected_char := '^4[1-7]{6}\.[3-5]{3}$';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char, 'rx_match');

    -- --------------
    -- NVLC for dates
    -- --------------

    l_test := '12 - Test hmx_utl.nvlc for dates: PASS';
    l_result_char := hmx_utl.nvlc(pi_dvalue => to_date('2026-10-27@16:26:24','yyyy-mm-dd"@"hh24:mi:ss'));
    l_expected_char := '2026-10-27T16:26:24';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '13 - Test hmx_utl.nvlc for dates with a NULL-default not being used: PASS';
    l_result_char := hmx_utl.nvlc(pi_dvalue => to_date('2026-10-27@16:26:34','yyyy-mm-dd"@"hh24:mi:ss'), pi_ifnull => 'NiXX');
    l_expected_char := '2026-10-27T16:26:34';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '14 - Test hmx_utl.nvlc for dates with a NULL-default being used: PASS';
    l_result_char := hmx_utl.nvlc(pi_dvalue => to_date(null), pi_ifnull => 'NiXX');
    l_expected_char := 'NiXX';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '15 - Test hmx_utl.nvlc for dates not equal : PASS';
    l_result_char := hmx_utl.nvlc(pi_dvalue => to_date('2026-10-27@10:26:24','yyyy-mm-dd"@"hh24:mi:ss'), pi_ifnull => 'nuLL');
    l_expected_char := '2026-10-27T00:00:15';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char, '<>');

    l_test := '16 - Test hmx_utl.nvlc for dates regexp_count>0 : PASS';
    l_result_char := hmx_utl.nvlc(pi_dvalue => to_date('2026-10-27@00:00:22','yyyy-mm-dd"@"hh24:mi:ss'), pi_ifnull => 'nuLL');
    l_expected_char := '^[0-9-]{10}T00:00:2{2}$';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char, 'rx_match');

    -- -----------------
    -- NVLC for booleans
    -- -----------------

    l_test := '17 - Test hmx_utl.nvlc for booleans: PASS';
    l_result_char := hmx_utl.nvlc(pi_bvalue => TRUE);
    l_expected_char := 'TRUE';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '18 - Test hmx_utl.nvlc for booleans with a NULL-default not being used: PASS';
    l_result_char := hmx_utl.nvlc(pi_bvalue => FALSE, pi_ifnull => 'NiXX');
    l_expected_char := 'FALSE';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '19 - Test hmx_utl.nvlc for booleans with a NULL-default being used: PASS';
    l_result_char := hmx_utl.nvlc(pi_bvalue => (FALSE=NULL), pi_ifnull => 'NiXX');
    l_expected_char := 'NiXX';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '20 - Test hmx_utl.nvlc for booleans not equal : PASS';
    l_result_char := hmx_utl.nvlc(pi_bvalue => FALSE, pi_ifnull => 'nuLL');
    l_expected_char := 'TRUE';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char, '<>');

    l_test := '21 - Test hmx_utl.nvlc for booleans regexp_count>0 : PASS';
    l_result_char := hmx_utl.nvlc(pi_bvalue => FALSE, pi_ifnull => 'nuLL');
    l_expected_char := '^F[SLA]{3}E$';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char, 'rx_match');

    -- -----------------------
    -- IS_EQUAL for characters
    -- -----------------------

    l_test := '22 - Test hmx_utl.is_equal for equal characters case sensitive: PASS';
    l_result_num := hmx_utl.is_equal (pi_char1 => 'Value One', pi_char2 => 'Value One', pi_case => hmx_utl.k_case_sensitive);
    l_expected_num := 1;
    check_pass_fail ($$plsql_line, l_test, l_expected_num, l_result_num);

    l_test := '23 - Test hmx_utl.is_equal for equal characters case INsensitive: PASS';
    l_result_num := hmx_utl.is_equal (pi_char1 => 'Value Two', pi_char2 => 'value two', pi_case => hmx_utl.k_case_insensitive);
    l_expected_num := 1;
    check_pass_fail ($$plsql_line, l_test, l_expected_num, l_result_num);

    l_test := '24 - Test hmx_utl.is_equal for equal characters using default (case INsensitive): PASS';
    l_result_num := hmx_utl.is_equal (pi_char1 => 'Value Three', pi_char2 => 'value three');
    l_expected_num := 1;
    check_pass_fail ($$plsql_line, l_test, l_expected_num, l_result_num);

    l_test := '25 - Test hmx_utl.is_equal for unequal characters using default (case INsensitive): PASS';
    l_result_num := hmx_utl.is_equal (pi_char1 => 'Value Four', pi_char2 => 'value 4');
    l_expected_num := 0;
    check_pass_fail ($$plsql_line, l_test, l_expected_num, l_result_num);

    l_test := '26 - Test hmx_utl.is_equal for unequal characters one being NULL: PASS';
    l_result_num := hmx_utl.is_equal (pi_char1 => 'value Five', pi_char2 => to_char(null));
    l_expected_num := 0;
    check_pass_fail ($$plsql_line, l_test, l_expected_num, l_result_num);

    l_test := '27 - Test hmx_utl.is_equal for equal characters both being NULL: PASS';
    l_result_num := hmx_utl.is_equal (pi_char1 => to_char(null), pi_char2 => to_char(null), pi_case => hmx_utl.k_case_sensitive);
    l_expected_num := 1;
    check_pass_fail ($$plsql_line, l_test, l_expected_num, l_result_num);

    -- --------------------
    -- IS_EQUAL for numbers
    -- --------------------
    -- Checking of the local check_pass_fail parameter pi_compare_op for "rx_match" and "like"
    -- not usefull for numeric and date checks.

    l_test := '28 - Test hmx_utl.is_equal for equal numbers: PASS';
    l_result_num := hmx_utl.is_equal (pi_num1 => 346, pi_num2 => 346);
    l_expected_num := 1;
    check_pass_fail ($$plsql_line, l_test, l_expected_num, l_result_num);

    l_test := '29 - Test hmx_utl.is_equal for unequal numbers: PASS';
    l_result_num := hmx_utl.is_equal (pi_num1 => 346, pi_num2 => 789);
    l_expected_num := 0;
    check_pass_fail ($$plsql_line, l_test, l_expected_num, l_result_num);

    l_test := '30 - Test hmx_utl.is_equal for unequal numbers one being NULL: PASS';
    l_result_num := hmx_utl.is_equal (pi_num1 => 346, pi_num2 => to_number(null));
    l_expected_num := 0;
    check_pass_fail ($$plsql_line, l_test, l_expected_num, l_result_num);

    l_test := '31 - Test hmx_utl.is_equal for equal numbers both being NULL: PASS';
    l_result_num := hmx_utl.is_equal (pi_num1 => to_number(null), pi_num2 => to_number(null));
    l_expected_num := 1;
    check_pass_fail ($$plsql_line, l_test, l_expected_num, l_result_num);

    -- ------------------
    -- IS_EQUAL for dates
    -- ------------------
    -- Checking of the local check_pass_fail parameter pi_compare_op for "rx_match" and "like"
    -- not usefull for numeric and date checks.

    l_test := '32 - Test hmx_utl.is_equal for equal dates: PASS';
    l_result_num := hmx_utl.is_equal (pi_date1 => to_date('2026-10-27@16:26:32','yyyy-mm-dd"@"hh24:mi:ss'), pi_date2 => to_date('2026-10-27T16:26:32','yyyy-mm-dd"T"hh24:mi:ss'));
    l_expected_num := 1;
    check_pass_fail ($$plsql_line, l_test, l_expected_num, l_result_num);

    l_test := '33 - Test hmx_utl.is_equal for unequal dates: PASS';
    l_result_num := hmx_utl.is_equal (pi_date1 => to_date('2026-10-27@16:26:33','yyyy-mm-dd"@"hh24:mi:ss'), pi_date2 => to_date('2026-10-27 04:26:33','yyyy-mm-dd hh24:mi:ss'));
    l_expected_num := 0;
    check_pass_fail ($$plsql_line, l_test, l_expected_num, l_result_num);

    l_test := '34 - Test hmx_utl.is_equal for unequal dates one being NULL: PASS';
    l_result_num := hmx_utl.is_equal (pi_date1 => to_date('2026-10-27@16:26:34','yyyy-mm-dd"@"hh24:mi:ss'), pi_date2 => to_date(null));
    l_expected_num := 0;
    check_pass_fail ($$plsql_line, l_test, l_expected_num, l_result_num);

    l_test := '35 - Test hmx_utl.is_equal for equal dates both being NULL: PASS';
    l_result_num := hmx_utl.is_equal (pi_date1 => to_date(null), pi_date2 => to_date(null));
    l_expected_num := 1;
    check_pass_fail ($$plsql_line, l_test, l_expected_num, l_result_num);

    -- --------------------------
    -- TRIMWS only for characters
    -- --------------------------

    l_test := '36 - Test hmx_utl.trimws (matching): PASS';
    l_result_char := hmx_utl.trimws ( hmx_utl.k_sp||hmx_utl.k_crlf||hmx_utl.k_tab || ' Only this remains. ' || hmx_utl.k_crlf||hmx_utl.k_sp||hmx_utl.k_tab );
    l_expected_char := 'Only this remains.';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '37 - Test hmx_utl.trimws (matching, TAB inside string): PASS';
    l_result_char := hmx_utl.trimws ( hmx_utl.k_sp||hmx_utl.k_crlf||hmx_utl.k_tab || ' TAB character' || hmx_utl.k_tab || ' in the string. ' || hmx_utl.k_crlf||hmx_utl.k_sp||hmx_utl.k_tab );
    l_expected_char := 'TAB character' || hmx_utl.k_tab || ' in the string.';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '38 - Test hmx_utl.trimws (matching, TAB inside string, regular expression check): PASS';
    l_result_char := hmx_utl.trimws ( hmx_utl.k_sp||hmx_utl.k_crlf||hmx_utl.k_tab || ' TAB character' || hmx_utl.k_tab || ' in the string. ' || hmx_utl.k_crlf||hmx_utl.k_sp||hmx_utl.k_tab );
    l_expected_char := hmx_utl.k_tab||'+'; -- expecting a TAB between other characters
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char, 'rx_match');

    l_test := '39 - Test hmx_utl.trimws (not matching): PASS';
    l_result_char := hmx_utl.trimws ( hmx_utl.k_sp||hmx_utl.k_crlf||hmx_utl.k_tab || ' Not a match. ' || hmx_utl.k_crlf||hmx_utl.k_sp||hmx_utl.k_tab );
    l_expected_char := hmx_utl.k_tab||hmx_utl.k_tab||'Not a match.'||hmx_utl.k_tab||hmx_utl.k_tab;
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char, '<>');

    -- --------------------------
    -- TO_NUM_VAL only for characters
    -- --------------------------
    -- Checking of the local check_pass_fail parameter pi_compare_op for "rx_match" and "like"
    -- not usefull for numeric and date checks.

    l_test := '40 - Test hmx_utl.to_num_val positive number OK: PASS';
    l_result_num := hmx_utl.to_num_val ( '1234.56789' );
    l_expected_num := 1234.56789;
    check_pass_fail ($$plsql_line, l_test, l_expected_num, l_result_num);

    l_test := '41 - Test hmx_utl.to_num_val negative number OK: PASS';
    l_result_num := hmx_utl.to_num_val ( '-.56789' );
    l_expected_num := -0.56789;
    check_pass_fail ($$plsql_line, l_test, l_expected_num, l_result_num);

    l_test := '42 - Test hmx_utl.to_num_val failing to convert: PASS';
    l_result_num := hmx_utl.to_num_val ( '1234,56789' );
    l_expected_num := to_number(null);
    check_pass_fail ($$plsql_line, l_test, l_expected_num, l_result_num);

    -- --------------------------------------------------------------
    -- Informational functions returning nice text for internal codes
    -- --------------------------------------------------------------

    l_test := '43 - Test hmx_utl.f_yes_no (character) YES: PASS';
    l_result_char := hmx_utl.f_yes_no         (pi_val  => hmx_utl.k_yes );
    l_expected_char := 'Yes';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '45 - Test hmx_utl.f_yes_no (number) YES: PASS';
    l_result_char := hmx_utl.f_yes_no         (pi_val  => hmx_utl.k_byes );
    l_expected_char := 'Yes';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '46 - Test hmx_utl.f_yes_no (character) NO: PASS';
    l_result_char := hmx_utl.f_yes_no         (pi_val  => hmx_utl.k_no );
    l_expected_char := 'No';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '47 - Test hmx_utl.f_yes_no (number) NO: PASS';
    l_result_char := hmx_utl.f_yes_no         (pi_val  => hmx_utl.k_bno );
    l_expected_char := 'No';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '48 - Test hmx_utl.f_true_false (character) TRUE: PASS';
    l_result_char := hmx_utl.f_true_false         (pi_val  => hmx_utl.k_true );
    l_expected_char := 'True';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '49 - Test hmx_utl.f_true_false (number) TRUE: PASS';
    l_result_char := hmx_utl.f_true_false         (pi_val  => hmx_utl.k_btrue );
    l_expected_char := 'True';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '50 - Test hmx_utl.f_true_false (character) FALSE: PASS';
    l_result_char := hmx_utl.f_true_false         (pi_val  => hmx_utl.k_false );
    l_expected_char := 'False';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '51 - Test hmx_utl.f_true_false (number) FALSE: PASS';
    l_result_char := hmx_utl.f_true_false         (pi_val  => hmx_utl.k_bfalse );
    l_expected_char := 'False';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '52 - Test hmx_utl.f_pass_fail (character) PASS: PASS';
    l_result_char := hmx_utl.f_pass_fail         (pi_val  => hmx_utl.k_pass );
    l_expected_char := 'Pass';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '53 - Test hmx_utl.f_pass_fail (number) PASS: PASS';
    l_result_char := hmx_utl.f_pass_fail         (pi_val  => hmx_utl.k_bpass );
    l_expected_char := 'Pass';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '54 - Test hmx_utl.f_pass_fail (character) FAIL: PASS';
    l_result_char := hmx_utl.f_pass_fail         (pi_val  => hmx_utl.k_fail );
    l_expected_char := 'Fail';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '55 - Test hmx_utl.f_pass_fail (number) FAIL: PASS';
    l_result_char := hmx_utl.f_pass_fail         (pi_val  => hmx_utl.k_bfail );
    l_expected_char := 'Fail';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '56 - Test hmx_utl.f_ok_not_ok OK: PASS';
    l_result_char := hmx_utl.f_ok_not_ok         (pi_val  => hmx_utl.k_ok );
    l_expected_char := 'OK';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '57 - Test hmx_utl.f_ok_not_ok NOT OK: PASS';
    l_result_char := hmx_utl.f_ok_not_ok         (pi_val  => hmx_utl.k_nok );
    l_expected_char := 'Not OK';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '58 - Test hmx_utl.f_success_failed SUCCESS: PASS';
    l_result_char := hmx_utl.f_success_failed         (pi_val  => hmx_utl.k_success );
    l_expected_char := 'Success';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '59 - Test hmx_utl.f_success_failed FAILED: PASS';
    l_result_char := hmx_utl.f_success_failed         (pi_val  => hmx_utl.k_failed );
    l_expected_char := 'Failed';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '60 - Test hmx_utl.f_q1q: PASS';
    l_result_char := hmx_utl.f_q1q            (pi_text => 'Single quoted text' );
    l_expected_char := '''Single quoted text''';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    l_test := '60 - Test hmx_utl.f_q2q: PASS';
    l_result_char := hmx_utl.f_q2q            (pi_text => 'Double quoted text' );
    l_expected_char := '"Double quoted text"';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    -- ---------------------------------------------------------------------------------------------
    lprt;
    lprt('*I: End of test results.');
    lprt('....+....1....+....2....+....3....+....4....+....5....+....6....+....7....+....8....+....9....+....1');

    lprt;
    lprt('*I: Test result summary:');
    lprt('    - Passed: ' || l_counters(k_pass) );
    lprt('    - Failed: ' || l_counters(k_fail) );
    lprt('    - Error : ' || l_counters(k_error) );

    lprt;
    lprt ('*I: Finished hmx_utl_pkg_tests.sql at script line ' || to_char(prtline#($$plsql_line) ) );
exception
    when others
    then
        lprt ('*E: ' || sqlerrm);
        lprt ('    while executing test '  || l_test ||  '.');
        lprt (rpad('-',80,'-')
            || chr(10) || '----- PL/SQL ERROR BACKTRACE -----'
            || chr(10) || dbms_utility.format_error_backtrace()
            || rpad('-',80,'-')
            );
        lprt (rpad('-',80,'-')
            || chr(10) || '----- PL/SQL ERROR STACK -----'
            || chr(10) || dbms_utility.format_error_stack()
            || rpad('-',80,'-')
            );
        lprt (rpad('-',80,'-')
            || chr(10) || dbms_utility.format_call_stack()
            || rpad('-',80,'-')
            );
        lprt ('*I: Line Offset = ' || k_line_offset );
        lprt ('*W: Aborted hmx_utl_pkg_tests.sql at script line ' || to_char(prtline#($$plsql_line) ) );
end;
/
-- ======================================== PROCESSING END =========================================

prompt *I: Spoolfile = &&v_spoolfile.
prompt *I: ScriptEOF hmx_utl_pkg_tests.sql
@hmx_spoolfinish
prompt Done.
