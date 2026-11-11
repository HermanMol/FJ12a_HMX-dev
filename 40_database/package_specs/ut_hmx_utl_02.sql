create or replace package ut_hmx_utl_02
as

-- Generated using hmx_utplsql_utl.generate_test_package_spec on 2026-11-11 18:10:02 +01:00

    --%suite(Suite_2026-11-11 17:11:05)
    --%suitepath(HMXTESTS.HMX_UTL_pkg)
    --%context(Context_FJ12a)

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_no#001)
    procedure fk_no#001;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_yes#002)
    procedure fk_yes#002;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_fail#003)
    procedure fk_fail#003;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_pass#004)
    procedure fk_pass#004;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_nok#005)
    procedure fk_nok#005;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_ok#006)
    procedure fk_ok#006;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_failed#007)
    procedure fk_failed#007;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_success#008)
    procedure fk_success#008;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_ellipsis#009)
    procedure fk_ellipsis#009;

    --%tags(utPLSQL_v3.2.4.)
    --%test(N=fk_bno#010)
    procedure fk_bno#010;

    --%tags(utPLSQL_v3.2.4.)
    --%test(N=fk_byes#011)
    procedure fk_byes#011;

    --%tags(utPLSQL_v3.2.4.)
    --%test(N=fk_bfalse#012)
    procedure fk_bfalse#012;

    --%tags(utPLSQL_v3.2.4.)
    --%test(N=fk_btrue#013)
    procedure fk_btrue#013;

    --%tags(utPLSQL_v3.2.4.)
    --%test(N=fk_bfail#014)
    procedure fk_bfail#014;

    --%tags(utPLSQL_v3.2.4.)
    --%test(N=fk_bpass#015)
    procedure fk_bpass#015;

    --%tags(utPLSQL_v3.2.4.)
    --%test(N=fk_berror#016)
    procedure fk_berror#016;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_lf#017)
    procedure fk_lf#017;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_cr#018)
    procedure fk_cr#018;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_crlf#019)
    procedure fk_crlf#019;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_sp#020)
    procedure fk_sp#020;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_tab#021)
    procedure fk_tab#021;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_2q#022)
    procedure fk_2q#022;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_1q#023)
    procedure fk_1q#023;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_bq#024)
    procedure fk_bq#024;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_amp#025)
    procedure fk_amp#025;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_at#026)
    procedure fk_at#026;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_pct#027)
    procedure fk_pct#027;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_us#028)
    procedure fk_us#028;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_gs#029)
    procedure fk_gs#029;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_rs#030)
    procedure fk_rs#030;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_fs#031)
    procedure fk_fs#031;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_ack#032)
    procedure fk_ack#032;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_nak#033)
    procedure fk_nak#033;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_none#034)
    procedure fk_none#034;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_case_sensitive#035)
    procedure fk_case_sensitive#035;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_case_insensitive#036)
    procedure fk_case_insensitive#036;

    --%tags(utPLSQL_v3.2.4.)
    --%test(N=fk_ora_min_number#037)
    procedure fk_ora_min_number#037;

    --%tags(utPLSQL_v3.2.4.)
    --%test(N=fk_ora_max_number#038)
    procedure fk_ora_max_number#038;

    --%tags(utPLSQL_v3.2.4.)
    --%test(D=fk_ora_min_date#039)
    procedure fk_ora_min_date#039;

    --%tags(utPLSQL_v3.2.4.)
    --%test(D=fk_ora_max_date#040)
    procedure fk_ora_max_date#040;

    --%tags(utPLSQL_v3.2.4.)
    --%test(D=fk_ratadie#041)
    procedure fk_ratadie#041;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=nvlc#042[pi_cvalue,C; pi_ifnull,C])
    procedure nvlc#042;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=nvlc#043[pi_cvalue,C])
    procedure nvlc#043;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=nvlc#044[pi_dvalue,D; pi_ifnull,C])
    procedure nvlc#044;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=nvlc#045[pi_dvalue,D])
    procedure nvlc#045;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=nvlc#046[pi_nvalue,N; pi_ifnull,C])
    procedure nvlc#046;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=nvlc#047[pi_nvalue,N])
    procedure nvlc#047;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=nvlc#048[pi_bvalue,?; pi_ifnull,C])
    procedure nvlc#048;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=nvlc#049[pi_bvalue,?])
    procedure nvlc#049;

    --%tags(utPLSQL_v3.2.4.)
    --%test(N=is_equal#050[pi_char1,C; pi_char2,C; pi_case,C])
    procedure is_equal#050;

    --%tags(utPLSQL_v3.2.4.)
    --%test(N=is_equal#051[pi_char1,C; pi_char2,C])
    procedure is_equal#051;

    --%tags(utPLSQL_v3.2.4.)
    --%test(N=is_equal#052[pi_num1,N; pi_num2,N])
    procedure is_equal#052;

    --%tags(utPLSQL_v3.2.4.)
    --%test(N=is_equal#053[pi_date1,D; pi_date2,D])
    procedure is_equal#053;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=trimws#054[pi_string,C])
    procedure trimws#054;

    --%tags(utPLSQL_v3.2.4.)
    --%test(N=to_num_val#055[pi_value,C])
    procedure to_num_val#055;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=f_yes_no#056[pi_val,C])
    procedure f_yes_no#056;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=f_yes_no#057[pi_val,N])
    procedure f_yes_no#057;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=f_true_false#058[pi_val,C])
    procedure f_true_false#058;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=f_true_false#059[pi_val,N])
    procedure f_true_false#059;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=f_pass_fail#060[pi_val,C])
    procedure f_pass_fail#060;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=f_pass_fail#061[pi_val,N])
    procedure f_pass_fail#061;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=f_ok_not_ok#062[pi_val,C])
    procedure f_ok_not_ok#062;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=f_success_failed#063[pi_val,C])
    procedure f_success_failed#063;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=f_q1q#064[pi_text,C])
    procedure f_q1q#064;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=f_q2q#065[pi_text,C])
    procedure f_q2q#065;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=f_max_chars#066[pi_base_chars,C; pi_max,N; pi_add_chars,C; pi_ellipsis,C])
    procedure f_max_chars#066;

    --%endcontext
    -- Number of tests generated: 66
    -- End of suite(Suite_2026-11-11 17:11:05)

end ut_hmx_utl_02;
/


