prompt *I: ScriptBOF hmx_utl_pkg_tests.sql

@hmx_spoolstart hmx_utl_pkg_tests.sql

prompt *A: ***** WIP hmx_utl_pkg_tests.sql *****

set echo off
@hmx_session_info

declare
    k_line_offset   constant number := 10 - $$plsql_line;   -- the literal must be the actual line number of THIS line.
    k_format_num    constant varchar2(40) := '99999999999999999999999999990.0000000000';
    k_format_date   constant varchar2(23) := 'yyyy-mm-dd"T"hh24:mi:ss';
    k_pass          constant varchar2(4) := 'PASS';
    k_fail          constant varchar2(4) := 'FAIL';
    k_error         constant varchar2(5) := 'ERROR';

    l_test          varchar2(32767);
    l_result_char   varchar2(32767);
    l_expected_char varchar2(32767);
    l_result_num    number;
    l_expected_num  number;
    l_result_date   date;
    l_expected_date date;

    l_cnt_pass      number := 0;
    l_cnt_fail      number := 0;
    l_cnt_error     number := 0;

    type count_result_type is table of number index by varchar2(5);
    l_counters count_result_type := count_result_type();

    function prtval (pi_val varchar2) return varchar2 as begin return '>' || pi_val || '<'; end prtval;
    function prtline# (pi_plsql_line in number) return number as begin return (k_line_offset + pi_plsql_line); end prtline#;
    procedure incr(pio_num in out number, pi_incr number := 1) as begin pio_num := nvl(pio_num,0) + pi_incr; end incr;

    -- ---------------------------------------------------------------------------------------------
    -- Procedure to check if the result matches the expected value
    -- Any check is ALWAYS case SESITIVE!
    -- - pi_plsql_line = the line on which the call to this check_pass_fail is located
    -- - pi_test = a one-line description of the test
    -- - pi_expected = the expected value
    -- - pi_result = the resulted value
    -- - pi_compare_op = the compare operator, default is "="
    --   Examples for pi_compare_op:
    --   - pi_result = pi_expected
    --   - pi_result <> pi_expected
    --   - regexp_count(pi_result, pi_expected, 1, 'c')
    --   - pi_result like pi_expected escape '^'
    procedure check_pass_fail
        (pi_plsql_line in number
        ,pi_test       in varchar2
        ,pi_expected   in varchar2
        ,pi_result     in varchar2
        ,pi_compare_op in varchar2 := '='    -- Possible are: =, <>, rx_count, like
        )
    as
        l_check varchar2(5);
    begin

        if  pi_compare_op = '='
        then
            --prt('*D: ' || pi_compare_op || '(''' || pi_result || ''',''' || pi_expected || ''';');
            l_check := case when pi_expected = pi_result then k_pass else k_fail end;

        elsif pi_compare_op = '<>'
        then
            --prt('*D: ' || pi_compare_op || '(''' || pi_result || ''',''' || pi_expected || ''';');
            l_check := case when pi_expected <> pi_result then k_pass else k_fail end;

        elsif lower(pi_compare_op) = 'rx_count'
        then
            --prt('*D: ' || pi_compare_op || '(''' || pi_result || ''',''' || pi_expected || ''',1,''c'')');
            l_check := case when regexp_count(pi_result, pi_expected,1,'c') > 0 then k_pass else k_fail end;

        elsif lower(pi_compare_op) = 'like'
        then
            --prt('*D: ' || pi_compare_op || '(''' || pi_result || ''',''' || pi_expected || ''';');
            l_check := case when pi_result like pi_expected then k_pass else k_fail end;

        else
            prt('*D: ERROR, unanticipated compare operator: "' || pi_compare_op || '"');
            l_check := k_error;
        end if;

        incr(l_counters(l_check));

        prt('[' || trim(to_char(prtline#(pi_plsql_line), '0000')) || ']'
            || ' ' || l_check || ' : '  || pi_test
            || ' - expected=' || pi_expected
            || '; result=' || pi_result
            || '; compare_op="' || pi_compare_op ||'"'
            );
    end check_pass_fail;

begin
    prt ('*I: Started hmx_utl_pkg_tests.sql');

    prt('*I: - Line Offset  = ' || prtval( to_char(k_line_offset) || '+' || $$plsql_line ) );
    prt('*I: - Script line  = ' || prtval( to_char(prtline#($$plsql_line) ) ) );
    prt('*I: - 123456 / 423 = ' || prtval( to_char(123456 / 423,k_format_num) ) );
    prt('*I: - Now          = ' || prtval( to_char(current_date,k_format_date) ) );
    prt;
    prt('....+....1....+....2....+....3....+....4....+....5....+....6....+....7....+....8....+....9....+....1');
    prt('*I: Begin of test results.');

    l_counters(k_pass) := 0;
    l_counters(k_fail) := 0;
    l_counters(k_error) := 0;

    -- -------------------
    -- NVLC for characters
    -- -------------------

    prt;
    l_test := '01 - Test hmx_utl.nvlc for characters: PASS';
    l_result_char := hmx_utl.nvlc(pi_cvalue => 'Test 01');
    l_expected_char := 'Test 01';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    prt;
    l_test := '02 - Test hmx_utl.nvlc for characters with a NULL-default not being used: PASS';
    l_result_char := hmx_utl.nvlc(pi_cvalue => 'Test 02', pi_ifnull => 'NiXX');
    l_expected_char := 'Test 02';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    prt;
    l_test := '03 - Test hmx_utl.nvlc for characters with a NULL-default being used: PASS';
    l_result_char := hmx_utl.nvlc(pi_cvalue => null, pi_ifnull => 'nIxx');
    l_expected_char := 'nIxx';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    prt;
    l_test := '04 - Test hmx_utl.nvlc for characters not equal : PASS';
    l_result_char := hmx_utl.nvlc(pi_cvalue => 'abcdef', pi_ifnull => 'nuLL');
    l_expected_char := 'fedcba';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char, '<>');

    prt;
    l_test := '05 - Test hmx_utl.nvlc for characters regexp_count>0 : PASS';
    l_result_char := hmx_utl.nvlc(pi_cvalue => 'adcbef', pi_ifnull => 'nuLL');
    l_expected_char := '^a[b-d]+ef$';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char, 'rx_count');

    prt;
    l_test := '06 - Test Wrong compare operator : ERROR';
    l_result_char := hmx_utl.nvlc(pi_cvalue => 'adcbef');
    l_expected_char := 'ABCDEF';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char, 'regexp_count');

    -- ----------------
    -- NVLC for numbers
    -- ----------------

    prt;
    l_test := '07 - Test hmx_utl.nvlc for numbers: PASS';
    l_result_char := hmx_utl.nvlc(pi_nvalue => 1234567.089);
    l_expected_char := '1234567.089';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    prt;
    l_test := '08 - Test hmx_utl.nvlc for numbers with a NULL-default not being used: PASS';
    l_result_char := hmx_utl.nvlc(pi_nvalue => 7654321.809, pi_ifnull => 'NiXX');
    l_expected_char := '7654321.809';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    prt;
    l_test := '09 - Test hmx_utl.nvlc for numbers with a NULL-default being used: PASS';
    l_result_char := hmx_utl.nvlc(pi_nvalue => to_number(null), pi_ifnull => 'nIxx');
    l_expected_char := 'nIxx';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    prt;
    l_test := '10 - Test hmx_utl.nvlc for numbers not equal : PASS';
    l_result_char := hmx_utl.nvlc(pi_nvalue => 6754321.908, pi_ifnull => 'nuLL');
    l_expected_char := '5764321.809';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char, '<>');

    prt;
    l_test := '11 - Test hmx_utl.nvlc for numbers regexp_count>0 : PASS';
    l_result_char := hmx_utl.nvlc(pi_nvalue => 4765321.435, pi_ifnull => 'nuLL');
    l_expected_char := '^4[1-7]{6}\.[3-5]{3}$';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char, 'rx_count');

    -- --------------
    -- NVLC for dates
    -- --------------

    prt;
    l_test := '12 - Test hmx_utl.nvlc for dates: PASS';
    l_result_char := hmx_utl.nvlc(pi_dvalue => to_date('2026-10-27@16:26:24','yyyy-mm-dd"@"hh24:mi:ss'));
    l_expected_char := '2026-10-27T16:26:24';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    prt;
    l_test := '13 - Test hmx_utl.nvlc for dates with a NULL-default not being used: PASS';
    l_result_char := hmx_utl.nvlc(pi_dvalue => to_date('2026-10-27@16:26:34','yyyy-mm-dd"@"hh24:mi:ss'), pi_ifnull => 'NiXX');
    l_expected_char := '2026-10-27T16:26:34';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    prt;
    l_test := '14 - Test hmx_utl.nvlc for dates with a NULL-default being used: PASS';
    l_result_char := hmx_utl.nvlc(pi_dvalue => to_date(null), pi_ifnull => 'NiXX');
    l_expected_char := 'NiXX';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    prt;
    l_test := '15 - Test hmx_utl.nvlc for dates not equal : PASS';
    l_result_char := hmx_utl.nvlc(pi_dvalue => to_date('2026-10-27@10:26:24','yyyy-mm-dd"@"hh24:mi:ss'), pi_ifnull => 'nuLL');
    l_expected_char := '2026-10-27T00:00:15';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char, '<>');

    prt;
    l_test := '16 - Test hmx_utl.nvlc for dates regexp_count>0 : PASS';
    l_result_char := hmx_utl.nvlc(pi_dvalue => to_date('2026-10-27@00:00:22','yyyy-mm-dd"@"hh24:mi:ss'), pi_ifnull => 'nuLL');
    l_expected_char := '^[0-9-]{10}T00:00:2{2}$';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char, 'rx_count');

    -- -----------------
    -- NVLC for booleans
    -- -----------------

    prt;
    l_test := '17 - Test hmx_utl.nvlc for booleans: PASS';
    l_result_char := hmx_utl.nvlc(pi_bvalue => TRUE);
    l_expected_char := 'TRUE';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    prt;
    l_test := '18 - Test hmx_utl.nvlc for booleans with a NULL-default not being used: PASS';
    l_result_char := hmx_utl.nvlc(pi_bvalue => FALSE, pi_ifnull => 'NiXX');
    l_expected_char := 'FALSE';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    prt;
    l_test := '19 - Test hmx_utl.nvlc for booleans with a NULL-default being used: PASS';
    l_result_char := hmx_utl.nvlc(pi_bvalue => (FALSE=NULL), pi_ifnull => 'NiXX');
    l_expected_char := 'NiXX';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

    prt;
    l_test := '20 - Test hmx_utl.nvlc for booleans not equal : PASS';
    l_result_char := hmx_utl.nvlc(pi_bvalue => FALSE, pi_ifnull => 'nuLL');
    l_expected_char := 'TRUE';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char, '<>');

    prt;
    l_test := '21 - Test hmx_utl.nvlc for booleans regexp_count>0 : PASS';
    l_result_char := hmx_utl.nvlc(pi_bvalue => FALSE, pi_ifnull => 'nuLL');
    l_expected_char := '^F[SLA]{3}E$';
    check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char, 'rx_count');

    prt;
    prt('*I: End of test results.');
    prt('....+....1....+....2....+....3....+....4....+....5....+....6....+....7....+....8....+....9....+....1');

    prt;
    prt('*I: Test result summary:');
    prt('    - Passed: ' || l_counters(k_pass) );
    prt('    - Failed: ' || l_counters(k_fail) );
    prt('    - Error : ' || l_counters(k_error) );

    prt;
    prt ('*I: Finished hmx_utl_pkg_tests.sql at script line ' || to_char(prtline#($$plsql_line) ) );
exception
    when others
    then
        prt ('*E: ' || sqlerrm);
        prt ('*I: Line Offset = ' || k_line_offset );
        prt ('*W: Aborted hmx_utl_pkg_tests.sql at script line ' || to_char(prtline#($$plsql_line) ) );
end;
/

prompt *I: Spoolfile = &&v_spoolfile.

@hmx_spoolfinish

prompt *I: ScriptEOF hmx_utl_pkg_tests.sql
