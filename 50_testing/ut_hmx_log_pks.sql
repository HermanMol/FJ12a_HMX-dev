create or replace package ut_hmx_log
as

-- Generated using hmx_utplsql_utl.generate_test_package_spec on 2026-11-16 20:25:06 +01:00
-- Modified: Who, when?

    --%suite(Suite_2026-11-12 16:33:29)
    --%suitepath(HMXTESTS.hmx_log)
    --%context(Project_FJ12a)

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_info#001)
    procedure fk_info#001;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_tech#002)
    procedure fk_tech#002;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_func#003)
    procedure fk_func#003;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_trace#004)
    procedure fk_trace#004;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_debug#005)
    procedure fk_debug#005;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_develop#006)
    procedure fk_develop#006;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_testing#007)
    procedure fk_testing#007;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_auditing#008)
    procedure fk_auditing#008;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_security#009)
    procedure fk_security#009;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_logging#010)
    procedure fk_logging#010;

    --%tags(utPLSQL_v3.2.4.)
    --%test(N=fk_no_level#011)
    procedure fk_no_level#011;

    --%tags(utPLSQL_v3.2.4.)
    --%test(N=fk_cache#012)
    procedure fk_cache#012;

    --%tags(utPLSQL_v3.2.4.)
    --%test(N=fk_normal#013)
    procedure fk_normal#013;

    --%tags(utPLSQL_v3.2.4.)
    --%test(N=fk_attention#014)
    procedure fk_attention#014;

    --%tags(utPLSQL_v3.2.4.)
    --%test(N=fk_warning#015)
    procedure fk_warning#015;

    --%tags(utPLSQL_v3.2.4.)
    --%test(N=fk_error#016)
    procedure fk_error#016;

    --%tags(utPLSQL_v3.2.4.)
    --%test(N=fk_severe#017)
    procedure fk_severe#017;

    --%tags(utPLSQL_v3.2.4.)
    --%test(N=fk_critical#018)
    procedure fk_critical#018;

    --%tags(utPLSQL_v3.2.4.)
    --%test(N=fk_force#019)
    procedure fk_force#019;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_anyone#020)
    procedure fk_anyone#020;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_developer#021)
    procedure fk_developer#021;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_tester#022)
    procedure fk_tester#022;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_admin#023)
    procedure fk_admin#023;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_operations#024)
    procedure fk_operations#024;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_user#025)
    procedure fk_user#025;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_keyuser#026)
    procedure fk_keyuser#026;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_script#027)
    procedure fk_script#027;

    --%tags(utPLSQL_v3.2.4.)
    --%test(N=get_minimum_log_level#028)
    procedure get_minimum_log_level#028;

    --%tags(utPLSQL_v3.2.4.)
    --%test(set_minimum_log_level#029[pi_log_level,N])
    procedure set_minimum_log_level#029;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=log_level_name#030[pi_log_level_num,N])
    procedure log_level_name#030;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=get_tags#031)
    procedure get_tags#031;

    --%tags(utPLSQL_v3.2.4.)
    --%test(set_tags#032[pi_tags,C])
    procedure set_tags#032;

    --%tags(utPLSQL_v3.2.4.)
    --%test(add_tags#033[pi_tags,C])
    procedure add_tags#033;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=get_app_user#034)
    procedure get_app_user#034;

    --%tags(utPLSQL_v3.2.4.)
    --%test(set_app_user#035[pi_app_user,C; pi_from_sys,?UT?])
    procedure set_app_user#035;

    --%tags(utPLSQL_v3.2.4.)
    --%test(N=f_log_msg#036[pi_log_msg,C; pi_log_level,N; pi_log_type,C; pi_log_scope,C; pi_log_tags,C; pi_log_opt,N; pi_object_type,C; pi_skip_units,C])
    procedure f_log_msg#036;

    --%tags(utPLSQL_v3.2.4.)
    --%test(log_msg#037[pi_log_msg,C; pi_log_level,N; pi_log_type,C; pi_log_scope,C; pi_log_tags,C; pi_log_opt,N; pi_object_type,C; pi_skip_units,C])
    procedure log_msg#037;

    --%tags(utPLSQL_v3.2.4.)
    --%test(N=get_max_log_rate#038)
    procedure get_max_log_rate#038;

    --%tags(utPLSQL_v3.2.4.)
    --%test(N=set_max_log_rate#039[pi_rate,N])
    procedure set_max_log_rate#039;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=get_process_id#040)
    procedure get_process_id#040;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=new_process_id#041)
    procedure new_process_id#041;

    --%tags(utPLSQL_v3.2.4.)
    --%test(set_process_id#042[pi_process_id,C])
    procedure set_process_id#042;

    --%tags(utPLSQL_v3.2.4.)
    --%test(clear_cached_msg#043)
    procedure clear_cached_msg#043;

    --%tags(utPLSQL_v3.2.4.)
    --%test(cache_msg#044[pi_log_msg,C])
    procedure cache_msg#044;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=get_cached_msg#045[pi_flush,C; pi_max_length,N])
    procedure get_cached_msg#045;

    --%tags(utPLSQL_v3.2.4.)
    --%test(log_connection#046)
    procedure log_connection#046;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=get_called_from_formatted#047[pi_log_pkid,N])
    procedure get_called_from_formatted#047;

    --%tags(utPLSQL_v3.2.4.)
    --%test(log_run_script#048[pi_log_script,C; pi_log_tags,C])
    procedure log_run_script#048;

    --%tags(utPLSQL_v3.2.4.)
    --%test(get_log_row#049[pio_hmx_log_row,?UT?])
    procedure get_log_row#049;

    --%tags(utPLSQL_v3.2.4.)
    --%test(T=get_last_logtime#050)
    procedure get_last_logtime#050;

    --%tags(utPLSQL_v3.2.4.)
    --%test(N=get_last_log_pkid#051)
    procedure get_last_log_pkid#051;

    --%endcontext
    -- Number of tests generated: 51
    -- End of suite(Suite_2026-11-12 16:33:29)

end ut_hmx_log;
/


