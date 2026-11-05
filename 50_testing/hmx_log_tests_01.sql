Prompt *I: Start test with a fresh session: RESET_PACKAGE
exec dbms_session.reset_package;
-- Open spoolfile
@hmx_spoolstart hmx_log_tests_01.sql
prompt *I: ScriptBOF hmx_log_tests_01.sql
prompt *I: Spooling to &v_spoolfile.

set heading off
@hmx_session_info
set heading on

/* <hmx-annotations>

.HMX_OBJECT_USAGE: Script to test HMX_LOG public methods package.

.HMX_OBJECT_NOTES:
    This script tests the HMX_LOG package which is expected to be the one-and-only
    process logging tool (next to the HMX_DDL_LOG functions).

    This script is expected to be run from SQLcl

.HMX_DEVELOPER_NOTES: See HMX General Developer Notes
.HMX_OBJECT_VERSION: 2026-11-05 08:58:18 +01:00
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */



-- ======================================= PROCESSING START ========================================
declare

    l_hmo_log_data_rec      hmx_log_data%rowtype;
    l_log_pkid              hmx_log_data.log_pkid%type;
    l_log_msg               hmx_log_data.log_msg%type;
    l_log_time              hmx_log_data.log_time%type;
    l_log_type              hmx_log_data.log_type%type;
    l_log_level             hmx_log_data.log_level%type;
    l_log_scope             hmx_log_data.log_scope%type;
    l_log_tags              hmx_log_data.log_tags%type;
    l_log_org_owner         hmx_log_data.log_org_owner%type;
    l_log_org_object        hmx_log_data.log_org_object%type;
    l_log_org_type          hmx_log_data.log_org_type%type;
    l_log_org_method        hmx_log_data.log_org_method%type;
    l_log_org_line          hmx_log_data.log_org_line%type;
    l_log_call_depth        hmx_log_data.log_call_depth%type;
    l_log_process           hmx_log_data.log_process%type;
    l_log_sqlerrm           hmx_log_data.log_sqlerrm%type;
    l_log_sqlcode           hmx_log_data.log_sqlcode%type;
    l_log_call_stack        hmx_log_data.log_call_stack%type;
    l_log_error_backtrace   hmx_log_data.log_error_backtrace%type;
    l_log_sesid             hmx_log_data.log_sesid%type;
    l_log_server            hmx_log_data.log_server%type;
    l_log_dbname            hmx_log_data.log_dbname%type;
    l_log_dbschema          hmx_log_data.log_dbschema%type;
    l_log_dbuser            hmx_log_data.log_dbuser%type;
    l_log_osuser            hmx_log_data.log_osuser%type;
    l_log_app_user          hmx_log_data.log_app_user%type;

--#### GEWIJZIGD T.O.V. hmx_utl_pkg_tests.sql ##################################################################################################
    k_line_offset   constant number := 24 - $$plsql_line;   -- the literal must be the actual line number of THIS script line.
    k_format_num    constant varchar2(40) := '99999999999999999999999999990d0000000000';
    k_format_date   constant varchar2(23) := 'yyyy-mm-dd"T"hh24:mi:ss';
    k_pass          constant varchar2(4) := 'PASS';
    k_fail          constant varchar2(4) := 'FAIL';
    k_error         constant varchar2(5) := 'ERROR';

    "\t"  constant varchar2(1) := chr(09);

    type t_test_desc is record
        (id    varchar2(5)      -- assumed format 99.99
        ,title varchar2(100)
        );
    l_test          t_test_desc;
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
        lprt('*I: Tested version of HMX_LOG:');
        lprt('Owner, Type, Name, Version');
        for r_version_data in
        (   select object_owner
                ,object_name
                ,object_type
                ,object_version
            from hmx_annotations.get_object_version
                (pi_owner       => sys_context('USERENV','CURRENT_SCHEMA')
                ,pi_object_name => 'HMX_LOG'
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
    --   - "=" ........: pi_result =  pi_expected
    --   - "<>" .......: pi_result <> pi_expected
    --   - ">" ........: pi_result  > pi_expected
    --   - ">=" .......: pi_result >= pi_expected
    --   - "<" ........: pi_result <  pi_expected
    --   - "<=" .......: pi_result <= pi_expected
    --   - "rx_match"..: regexp_count(pi_result, pi_expected, 1, 'c')
    --   - "like"......: pi_result like pi_expected escape '^'
    procedure check_pass_fail
        (pi_plsql_line in number
        ,pi_test       in t_test_desc
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
                l_check := case when pi_result = pi_expected then k_pass else k_fail end;
            end if;

        elsif pi_compare_op = '<>'
        then
            lprt('*D: ' || pi_compare_op || '(''' || pi_result || ''',''' || pi_expected || ''';');
            l_check := case when pi_result <> pi_expected then k_pass else k_fail end;

        elsif pi_compare_op = '>'
        then
            lprt('*D: ' || pi_compare_op || '(''' || pi_result || ''',''' || pi_expected || ''';');
            l_check := case when pi_result > pi_expected then k_pass else k_fail end;

        elsif pi_compare_op = '>='
        then
            lprt('*D: ' || pi_compare_op || '(''' || pi_result || ''',''' || pi_expected || ''';');
            l_check := case when pi_result >= pi_expected then k_pass else k_fail end;

        elsif pi_compare_op = '<'
        then
            lprt('*D: ' || pi_compare_op || '(''' || pi_result || ''',''' || pi_expected || ''';');
            l_check := case when pi_result < pi_expected then k_pass else k_fail end;

        elsif pi_compare_op = '<='
        then
            lprt('*D: ' || pi_compare_op || '(''' || pi_result || ''',''' || pi_expected || ''';');
            l_check := case when pi_result <= pi_expected then k_pass else k_fail end;

        elsif lower(pi_compare_op) = 'rx_match'
        then
            lprt('*D: ' || pi_compare_op || '(''' || pi_result || ''',''' || pi_expected || ''',1,''c'')');
            l_check := case when regexp_count(pi_result, pi_expected,1,'c') > 0 then k_pass else k_fail end;

        elsif lower(pi_compare_op) = 'like'
        then
            lprt('*D: ' || pi_compare_op || '(''' || pi_result || ''',''' || pi_expected || ''';');
            l_check := case when pi_result like pi_expected escape '^' then k_pass else k_fail end;

        else
            lprt('*D: ERROR, unanticipated compare operator: "' || pi_compare_op || '"');
            l_check := k_error;
        end if;

        incr(l_counters(l_check));

        lprt('[' || trim(to_char(prtline#(pi_plsql_line), '0000')) || ']'
            || ' ' || l_check || ' : '  || pi_test.id || ' - ' || pi_test.title
            || ' - expected='  || prtval(pi_expected)
            || '; result='     || prtval(pi_result)
            || '; compare_op=' || prtval(pi_compare_op)
            || case when pi_compare_op = 'like' then (' escape=''^''') end
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
        ,pi_test       in t_test_desc
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
        ,pi_test       in t_test_desc
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

--#### GEWIJZIGD T.O.V. hmx_utl_pkg_tests.sql ##################################################################################################


    -- ---------------------------------------------------------------------------------------------
    --                           TEST UNITS
    -- ---------------------------------------------------------------------------------------------

    -- ---------------------------------------------------------------------------------------------
    procedure test_set_process_id
    as
        l_hmx_log_row   hmx_log_data%rowtype;
    begin
        l_test := t_test_desc('01.01','Set+Get the process id');
        l_expected_char := 'Test_' || l_test.id;
        hmx_log.set_process_id(pi_process_id => l_expected_char);
        l_result_char := hmx_log.get_process_id;
        check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);
        -- -----------------------------------------------------------------------------------------
        l_test := t_test_desc('01.02','Set+Logged the process id');
        l_expected_char := 'Test_' || l_test.id;
        hmx_log.set_process_id(pi_process_id => l_expected_char);
        l_hmx_log_row.log_pkid := hmx_log.f_log_msg
                                    (pi_log_msg     => l_test.id || ' - ' || l_test.title
                                    ,pi_log_level   => hmx_log.k_normal
                                    ,pi_log_type    => hmx_log.k_testing
                                    ,pi_log_scope   => hmx_log.k_tester
                                    ,pi_log_tags    => 'HMX-dev;test' || l_test.id
                                    ,pi_log_opt     => 0
                                    ,pi_object_type => null
                                    ,i_skip_units   => null
                                    );
        hmx_log.get_log_row(pio_hmx_log_row => l_hmx_log_row);
        l_result_char := l_hmx_log_row.log_process;
        check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

        -- set default for next tests
        lprt('*A: New pocess-id for next tests applied in the logging: ' || hmx_log.new_process_id);

    end test_set_process_id;

    -- ---------------------------------------------------------------------------------------------
    procedure test_set_app_user
    as
        l_hmx_log_row   hmx_log_data%rowtype;
    begin
        l_test := t_test_desc('02.01','Set+Get the App User: =USER?');
        l_expected_char := user;
        dbms_application_info.set_client_info (client_info => null);
        hmx_log.set_app_user;
        l_result_char := hmx_log.get_app_user;
        check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);
        -- -----------------------------------------------------------------------------------------
        l_expected_char := user;
        dbms_application_info.set_client_info (client_info => null);
        hmx_log.set_app_user;
        l_test := t_test_desc('02.02','Set+logged the App User: =USER?');
        l_hmx_log_row.log_pkid := hmx_log.f_log_msg
                                    (pi_log_msg     => l_test.id || ' - ' || l_test.title
                                    ,pi_log_level   => hmx_log.k_normal
                                    ,pi_log_type    => hmx_log.k_testing
                                    ,pi_log_scope   => hmx_log.k_tester
                                    ,pi_log_tags    => 'HMX-dev;test' || l_test.id
                                    ,pi_log_opt     => 0
                                    ,pi_object_type => null
                                    ,i_skip_units   => null
                                    );
        hmx_log.get_log_row(pio_hmx_log_row => l_hmx_log_row);
        l_result_char := l_hmx_log_row.log_app_user;
        check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

        -- -----------------------------------------------------------------------------------------
        l_test := t_test_desc('02.03','Set+Get the App User: from Client Info?');
        l_expected_char := 'USER ' || l_test.id;
        dbms_application_info.set_client_info (client_info => 'Logged in as: ' || l_expected_char);
        hmx_log.set_app_user;
        l_result_char := hmx_log.get_app_user;
        check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

        l_test := t_test_desc('02.04','Set+logged the App User: from Client Info?');
        l_expected_char := 'USER ' || l_test.id;
        dbms_application_info.set_client_info (client_info => 'Logged in as: ' || l_expected_char);
        hmx_log.set_app_user;
        l_hmx_log_row.log_pkid := hmx_log.f_log_msg
                                    (pi_log_msg     => l_test.id || ' - ' || l_test.title
                                    ,pi_log_level   => hmx_log.k_normal
                                    ,pi_log_type    => hmx_log.k_testing
                                    ,pi_log_scope   => hmx_log.k_tester
                                    ,pi_log_tags    => 'HMX-dev;test' || l_test.id
                                    ,pi_log_opt     => 0
                                    ,pi_object_type => null
                                    ,i_skip_units   => null
                                    );
        hmx_log.get_log_row(pio_hmx_log_row => l_hmx_log_row);
        l_result_char := l_hmx_log_row.log_app_user;
        check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);

        -- set default for next tests
        dbms_application_info.set_client_info (client_info => null);
        hmx_log.set_app_user;

    end test_set_app_user;

    -- ---------------------------------------------------------------------------------------------
    procedure test_set_minimum_log_level
    as
        l_hmx_log_row   hmx_log_data%rowtype;
    begin
        l_test := t_test_desc('03.01','Set+Get Minimum log level');
        l_expected_num  := hmx_log.k_attention;
        l_expected_char := l_expected_num || ' = ' || hmx_log.log_level_name(pi_log_level_num => l_expected_num);
        hmx_log.set_minimum_log_level(pi_log_level => l_expected_num);
        l_result_num  := hmx_log.get_minimum_log_level;
        l_result_char := l_result_num || ' = ' || hmx_log.log_level_name(pi_log_level_num => l_result_num);
        check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);
        -- -----------------------------------------------------------------------------------------
        -- verify that logging only occurs when the message level is not less than the minimum
        -- logging level: hmx_log.k_attention.
        hmx_log.set_minimum_log_level(pi_log_level => hmx_log.k_attention);
        l_test := t_test_desc('03.02','Logging (normal) not below Minimum log Level ' || hmx_log.log_level_name || '.');
        l_expected_num  := hmx_log.k_skipped_too_low_log_level;
        l_expected_char := '#ERROR# LOG_PKID ' || to_char(null) || ' NOT FOUND' || '%';
        l_result_num := hmx_log.f_log_msg
                                    (pi_log_msg     => l_test.id || ' - ' || l_test.title
                                    ,pi_log_level   => hmx_log.k_normal
                                    ,pi_log_type    => hmx_log.k_testing
                                    ,pi_log_scope   => hmx_log.k_tester
                                    ,pi_log_tags    => 'HMX-dev;test' || l_test.id
                                    ,pi_log_opt     => 0
                                    ,pi_object_type => null
                                    ,i_skip_units   => null
                                    );
        check_pass_fail ($$plsql_line, l_test, l_expected_num, l_result_num);

        l_test := t_test_desc('03.03','Logging (normal) not below Minimum log Level ' || hmx_log.log_level_name || '.');
        hmx_log.get_log_row(pio_hmx_log_row => l_hmx_log_row);
        l_result_char := '#ERROR# LOG_PKID ' || to_char(l_hmx_log_row.log_pkid) || ' NOT FOUND';
        check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char, 'like');
        -- -----------------------------------------------------------------------------------------
        -- verify that logging occurs when the message level is greater-or-equal to the minimum
        -- logging level: hmx_log.k_attention.
        hmx_log.set_minimum_log_level(pi_log_level => hmx_log.k_attention);
        l_test := t_test_desc('03.04','Logging (attention) above-equal Minimum log Level ' || hmx_log.log_level_name || '.');
        l_expected_num  := 1;
        l_hmx_log_row.log_pkid := hmx_log.f_log_msg
                                    (pi_log_msg     => l_expected_char
                                    ,pi_log_level   => hmx_log.k_attention
                                    ,pi_log_type    => hmx_log.k_testing
                                    ,pi_log_scope   => hmx_log.k_tester
                                    ,pi_log_tags    => 'HMX-dev;test' || l_test.id
                                    ,pi_log_opt     => 0
                                    ,pi_object_type => null
                                    ,i_skip_units   => null
                                    );
        hmx_log.get_log_row(pio_hmx_log_row => l_hmx_log_row);
        l_result_num  := l_hmx_log_row.log_pkid;
        check_pass_fail ($$plsql_line, l_test, l_expected_num , l_result_num , '>=');

        l_test := t_test_desc('03.05','Logging (warning) above-equal Minimum log Level ' || hmx_log.log_level_name || '.');
        l_expected_char := l_test.id || ' - ' || l_test.title;
        l_hmx_log_row.log_pkid := hmx_log.f_log_msg
                                    (pi_log_msg     => l_expected_char
                                    ,pi_log_level   => hmx_log.k_warning
                                    ,pi_log_type    => hmx_log.k_testing
                                    ,pi_log_scope   => hmx_log.k_tester
                                    ,pi_log_tags    => 'HMX-dev;test' || l_test.id
                                    ,pi_log_opt     => 0
                                    ,pi_object_type => null
                                    ,i_skip_units   => null
                                    );
        hmx_log.get_log_row(pio_hmx_log_row => l_hmx_log_row);
        l_result_char   := l_hmx_log_row.log_msg;
        check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char, '=' );

        -- set default for next tests
        hmx_log.set_minimum_log_level(pi_log_level => hmx_log.k_no_level);
        lprt('*A: New minimum logging level for next tests applied in the logging: ' || hmx_log.k_no_level || ' = ' || hmx_log.log_level_name(pi_log_level_num => hmx_log.k_no_level));

    end test_set_minimum_log_level;

    -- ---------------------------------------------------------------------------------------------
    procedure test_set_tags
    as
        l_hmx_log_row   hmx_log_data%rowtype;
    begin
        l_test := t_test_desc('04.01','Set+Get the tags');
        l_expected_char := 'TAGS_' || l_test.id;
        hmx_log.set_tags(pi_tags => l_expected_char);
        l_result_char := hmx_log.get_tags;
        check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char);
        -- -----------------------------------------------------------------------------------------
        l_test := t_test_desc('04.02','Set+Logged the tags');
        l_expected_char := 'TAGS_' || l_test.id;
        hmx_log.set_tags(pi_tags => l_expected_char);
        l_hmx_log_row.log_pkid := hmx_log.f_log_msg
                                    (pi_log_msg     => l_test.id || ' - ' || l_test.title
                                    ,pi_log_level   => hmx_log.k_normal
                                    ,pi_log_type    => hmx_log.k_testing
                                    ,pi_log_scope   => hmx_log.k_tester
                                    ,pi_log_tags    => 'HMX-dev;test' || l_test.id
                                    ,pi_log_opt     => 0
                                    ,pi_object_type => null
                                    ,i_skip_units   => null
                                    );
        hmx_log.get_log_row(pio_hmx_log_row => l_hmx_log_row);
        l_result_char := l_hmx_log_row.log_tags;
        check_pass_fail ($$plsql_line, l_test, l_expected_char||'%', l_result_char, 'like');

        -- set default for next tests
        hmx_log.set_tags(pi_tags => null);
        lprt('*A: New tags for next tests applied in the logging: ' || hmx_utl.nvlc(hmx_log.get_tags));
        -- -----------------------------------------------------------------------------------------
        l_test := t_test_desc('04.03','Set+Get the tags');
        l_expected_char := 'TAGS_' || l_test.id;
        hmx_log.set_tags(pi_tags => 'FirstTag');
        hmx_log.add_tags(pi_tags => l_expected_char);
        l_result_char := hmx_log.get_tags;
        check_pass_fail ($$plsql_line, l_test, 'FirstTag;' || l_expected_char, l_result_char);
        -- -----------------------------------------------------------------------------------------
        l_test := t_test_desc('04.05','Add+Get the tags');
        l_expected_char := 'TAGS_' || l_test.id;
        hmx_log.set_tags(pi_tags => 'SecondTag');
        hmx_log.add_tags(pi_tags => l_expected_char);
        l_hmx_log_row.log_pkid := hmx_log.f_log_msg
                                    (pi_log_msg     => l_test.id || ' - ' || l_test.title
                                    ,pi_log_level   => hmx_log.k_normal
                                    ,pi_log_type    => hmx_log.k_testing
                                    ,pi_log_scope   => hmx_log.k_tester
                                    ,pi_log_tags    => 'HMX-dev;test' || l_test.id
                                    ,pi_log_opt     => 0
                                    ,pi_object_type => null
                                    ,i_skip_units   => null
                                    );
        hmx_log.get_log_row(pio_hmx_log_row => l_hmx_log_row);
        l_result_char := l_hmx_log_row.log_tags;
        check_pass_fail ($$plsql_line, l_test, 'SecondTag;' || l_expected_char||'%', l_result_char, 'like');

        -- set default for next tests
        hmx_log.set_tags(pi_tags => null);
        lprt('*A: New tags for next tests applied in the logging: ' || hmx_utl.nvlc(hmx_log.get_tags));

    end test_set_tags;

    -- ---------------------------------------------------------------------------------------------
    procedure test_log_connection
    as
        l_hmx_log_row   hmx_log_data%rowtype;
    begin
        l_test := t_test_desc('05.01','Log connection');
        l_expected_char := 'USERENV:%NLS^_SESSION^_PARAMETERS:%CGI_ENV:%APEX-variables:%';
        hmx_log.log_connection;
        -- get the expected record that cas created no longer than 2 seconds ago
        select max(log_pkid)
        into l_hmx_log_row.log_pkid
        from hmx_log_data
        where log_msg like l_expected_char escape '^'
        and log_time + TO_DSINTERVAL('00 00:00:02') > current_timestamp;
        hmx_log.get_log_row(pio_hmx_log_row => l_hmx_log_row);
        l_result_char := l_hmx_log_row.log_msg;
        check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char, 'like');

    end test_log_connection;

    -- ---------------------------------------------------------------------------------------------
    procedure test_cache_message
    as
        l_hmx_log_row   hmx_log_data%rowtype;
    begin
        l_test := t_test_desc('06.01','Cache 3 messages');
        l_expected_char := 'First message.'
            || hmx_utl.k_lf || 'Second message.'
            || hmx_utl.k_lf || 'Third message.';
        hmx_log.cache_msg('First message.');
        hmx_log.cache_msg('Second message.');
        hmx_log.cache_msg('Third message.');
        l_result_char := hmx_log.get_cached_msg (pi_flush => hmx_utl.k_no, pi_max_length => 500);
        check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char, '=');
        -- -----------------------------------------------------------------------------------------
        l_test := t_test_desc('06.02','Clear cached messages');
        l_expected_char := 'No~mEssagEs~cachEd.' || l_test.id;
        hmx_log.clear_cached_msg;
        l_result_char := hmx_log.get_cached_msg (pi_flush => hmx_utl.k_no, pi_max_length => 500);
        check_pass_fail ($$plsql_line, l_test, l_expected_char, nvl(l_result_char,l_expected_char), '=');
        -- -----------------------------------------------------------------------------------------
        l_test := t_test_desc('06.03','Cache messages and flush after get_cached_msg');
        l_expected_char := 'No~mEssagEs~cachEd.' || l_test.id;
        hmx_log.cache_msg('Message one.');
        hmx_log.cache_msg('Message two.');
        hmx_log.cache_msg('Message three.');
        l_result_char := hmx_log.get_cached_msg (pi_flush => hmx_utl.k_yes, pi_max_length => 500);
        l_result_char := hmx_log.get_cached_msg;
        check_pass_fail ($$plsql_line, l_test, l_expected_char, nvl(l_result_char,l_expected_char), '=');
        -- -----------------------------------------------------------------------------------------
        l_test := t_test_desc('06.04','no title yet: see further...');
        l_expected_char := 'This message is logged and cached. Test ' || l_test.id;
        hmx_log.clear_cached_msg;
        l_hmx_log_row.log_pkid := hmx_log.f_log_msg
                                    (pi_log_msg     => l_expected_char
                                    ,pi_log_level   => hmx_log.k_normal
                                    ,pi_log_type    => hmx_log.k_testing
                                    ,pi_log_scope   => hmx_log.k_tester
                                    ,pi_log_tags    => 'HMX-dev;test' || l_test.id
                                    ,pi_log_opt     => hmx_log.k_add_cached_msg
                                    ,pi_object_type => null
                                    ,i_skip_units   => null
                                    );
        hmx_log.get_log_row(pio_hmx_log_row => l_hmx_log_row);
        l_test.title := 'Cache a logged message using the log option #4' || ' (from table)';
        l_result_char := l_hmx_log_row.log_msg;
        check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char, '=');
        -- check if logged was also cached
        l_test.title := 'Cache a logged message using the log option #4' || ' (from cache)';
        l_result_char := hmx_log.get_cached_msg (pi_flush => hmx_utl.k_yes, pi_max_length => 500);
        check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char, '=');
        -- -----------------------------------------------------------------------------------------
        l_test := t_test_desc('06.05','Message is cached despite too low log level.');
        hmx_log.clear_cached_msg;
        hmx_log.set_minimum_log_level(pi_log_level => hmx_log.k_attention);
        l_result_num := hmx_log.f_log_msg
                                    (pi_log_msg     => l_test.id || ' - ' || l_test.title
                                    ,pi_log_level   => hmx_log.k_normal
                                    ,pi_log_type    => hmx_log.k_testing
                                    ,pi_log_scope   => hmx_log.k_tester
                                    ,pi_log_tags    => 'HMX-dev;test' || l_test.id
                                    ,pi_log_opt     => hmx_log.k_add_cached_msg
                                    ,pi_object_type => null
                                    ,i_skip_units   => null
                                    );

        l_expected_char := 'Test ' || l_test.id || ': Returned from calling f_log_msg = ' || l_result_num || '.';
        l_result_char   := 'Test ' || l_test.id || ': Returned from calling f_log_msg = ' || hmx_log.k_skipped_too_low_log_level || '.';
        check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char, '=');

        l_expected_char := l_test.id || ' - ' || l_test.title;
        l_result_char   := hmx_log.get_cached_msg (pi_flush => hmx_utl.k_yes, pi_max_length => 500);
        check_pass_fail ($$plsql_line, l_test, l_expected_char, l_result_char, '=');

        -- set default for next tests
        hmx_log.set_minimum_log_level(pi_log_level => hmx_log.k_no_level);
        lprt('*A: New minimum logging level for next tests applied in the logging: '
            || hmx_log.k_no_level || ' = ' || hmx_log.log_level_name(pi_log_level_num => hmx_log.k_no_level));

    end test_cache_message;

    -- ---------------------------------------------------------------------------------------------

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

    dbms_application_info.set_client_info (client_info => 'Started hmx_log_tests_01.sql');

    test_set_process_id;        -- #01
    test_set_app_user;          -- #02
    test_set_minimum_log_level; -- #03
    test_set_tags;              -- #04
    test_log_connection;        -- #05
    test_cache_message;         -- #06

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
    lprt ('*I: Finished hmx_log_tests_01.sql at script line ' || to_char(prtline#($$plsql_line) ) );
exception
    when others
    then
        lprt ('*E: ' || sqlerrm);
        lprt ('    while executing test '  || l_test.id || ' - ' || l_test.title ||  '.');
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
        lprt ('*W: Aborted hmx_log_tests_01.sql at script line ' || to_char(prtline#($$plsql_line) ) );

end;
/
-- ============================================== END ==============================================

prompt *I: ScriptEOF hmx_log_tests_01.sql
@hmx_spoolfinish
prompt Done.