create or replace package body ut_hmx_log
as

-- Generated using hmx_utplsql_utl.generate_test_package_body on 2026-11-16 20:25:07 +01:00
-- Modified: Who, when?

    --#suite(Suite_2026-11-12 16:33:29)
    --#suitepath(HMXTESTS.hmx_log)
    --#context(Project_FJ12a)

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(C=fk_info#001)
    procedure fk_info#001
    as
        l_expect       varchar2(32767);
        l_actual       varchar2(32767);
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.fk_info
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end fk_info#001;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(C=fk_tech#002)
    procedure fk_tech#002
    as
        l_expect       varchar2(32767);
        l_actual       varchar2(32767);
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.fk_tech
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end fk_tech#002;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(C=fk_func#003)
    procedure fk_func#003
    as
        l_expect       varchar2(32767);
        l_actual       varchar2(32767);
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.fk_func
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end fk_func#003;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(C=fk_trace#004)
    procedure fk_trace#004
    as
        l_expect       varchar2(32767);
        l_actual       varchar2(32767);
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.fk_trace
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end fk_trace#004;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(C=fk_debug#005)
    procedure fk_debug#005
    as
        l_expect       varchar2(32767);
        l_actual       varchar2(32767);
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.fk_debug
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end fk_debug#005;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(C=fk_develop#006)
    procedure fk_develop#006
    as
        l_expect       varchar2(32767);
        l_actual       varchar2(32767);
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.fk_develop
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end fk_develop#006;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(C=fk_testing#007)
    procedure fk_testing#007
    as
        l_expect       varchar2(32767);
        l_actual       varchar2(32767);
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.fk_testing
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end fk_testing#007;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(C=fk_auditing#008)
    procedure fk_auditing#008
    as
        l_expect       varchar2(32767);
        l_actual       varchar2(32767);
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.fk_auditing
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end fk_auditing#008;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(C=fk_security#009)
    procedure fk_security#009
    as
        l_expect       varchar2(32767);
        l_actual       varchar2(32767);
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.fk_security
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end fk_security#009;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(C=fk_logging#010)
    procedure fk_logging#010
    as
        l_expect       varchar2(32767);
        l_actual       varchar2(32767);
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.fk_logging
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end fk_logging#010;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(N=fk_no_level#011)
    procedure fk_no_level#011
    as
        l_expect       number;
        l_actual       number;
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.fk_no_level
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end fk_no_level#011;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(N=fk_cache#012)
    procedure fk_cache#012
    as
        l_expect       number;
        l_actual       number;
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.fk_cache
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end fk_cache#012;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(N=fk_normal#013)
    procedure fk_normal#013
    as
        l_expect       number;
        l_actual       number;
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.fk_normal
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end fk_normal#013;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(N=fk_attention#014)
    procedure fk_attention#014
    as
        l_expect       number;
        l_actual       number;
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.fk_attention
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end fk_attention#014;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(N=fk_warning#015)
    procedure fk_warning#015
    as
        l_expect       number;
        l_actual       number;
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.fk_warning
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end fk_warning#015;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(N=fk_error#016)
    procedure fk_error#016
    as
        l_expect       number;
        l_actual       number;
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.fk_error
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end fk_error#016;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(N=fk_severe#017)
    procedure fk_severe#017
    as
        l_expect       number;
        l_actual       number;
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.fk_severe
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end fk_severe#017;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(N=fk_critical#018)
    procedure fk_critical#018
    as
        l_expect       number;
        l_actual       number;
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.fk_critical
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end fk_critical#018;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(N=fk_force#019)
    procedure fk_force#019
    as
        l_expect       number;
        l_actual       number;
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.fk_force
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end fk_force#019;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(C=fk_anyone#020)
    procedure fk_anyone#020
    as
        l_expect       varchar2(32767);
        l_actual       varchar2(32767);
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.fk_anyone
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end fk_anyone#020;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(C=fk_developer#021)
    procedure fk_developer#021
    as
        l_expect       varchar2(32767);
        l_actual       varchar2(32767);
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.fk_developer
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end fk_developer#021;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(C=fk_tester#022)
    procedure fk_tester#022
    as
        l_expect       varchar2(32767);
        l_actual       varchar2(32767);
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.fk_tester
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end fk_tester#022;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(C=fk_admin#023)
    procedure fk_admin#023
    as
        l_expect       varchar2(32767);
        l_actual       varchar2(32767);
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.fk_admin
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end fk_admin#023;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(C=fk_operations#024)
    procedure fk_operations#024
    as
        l_expect       varchar2(32767);
        l_actual       varchar2(32767);
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.fk_operations
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end fk_operations#024;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(C=fk_user#025)
    procedure fk_user#025
    as
        l_expect       varchar2(32767);
        l_actual       varchar2(32767);
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.fk_user
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end fk_user#025;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(C=fk_keyuser#026)
    procedure fk_keyuser#026
    as
        l_expect       varchar2(32767);
        l_actual       varchar2(32767);
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.fk_keyuser
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end fk_keyuser#026;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(C=fk_script#027)
    procedure fk_script#027
    as
        l_expect       varchar2(32767);
        l_actual       varchar2(32767);
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.fk_script
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end fk_script#027;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(N=get_minimum_log_level#028)
    procedure get_minimum_log_level#028
    as
        l_expect       number;
        l_actual       number;
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.get_minimum_log_level
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end get_minimum_log_level#028;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(set_minimum_log_level#029[pi_log_level,N])
    procedure set_minimum_log_level#029
    as
        l_expect       varchar2(?ut?);
        l_actual       varchar2(?ut?);
    begin
        -- l_expect := ?UT?;
        -- hmx_log.set_minimum_log_level
        --     (pi_log_level    => N
        --     );
        -- l_actual := '?UT?'; -- unknown at time of unit test generation
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end set_minimum_log_level#029;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(C=log_level_name#030[pi_log_level_num,N])
    procedure log_level_name#030
    as
        l_expect       varchar2(32767);
        l_actual       varchar2(32767);
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.log_level_name
        --     (pi_log_level_num    => N
        --     );
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end log_level_name#030;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(C=get_tags#031)
    procedure get_tags#031
    as
        l_expect       varchar2(32767);
        l_actual       varchar2(32767);
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.get_tags
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end get_tags#031;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(set_tags#032[pi_tags,C])
    procedure set_tags#032
    as
        l_expect       varchar2(?ut?);
        l_actual       varchar2(?ut?);
    begin
        -- l_expect := ?UT?;
        -- hmx_log.set_tags
        --     (pi_tags    => C
        --     );
        -- l_actual := '?UT?'; -- unknown at time of unit test generation
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end set_tags#032;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(add_tags#033[pi_tags,C])
    procedure add_tags#033
    as
        l_expect       varchar2(?ut?);
        l_actual       varchar2(?ut?);
    begin
        -- l_expect := ?UT?;
        -- hmx_log.add_tags
        --     (pi_tags    => C
        --     );
        -- l_actual := '?UT?'; -- unknown at time of unit test generation
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end add_tags#033;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(C=get_app_user#034)
    procedure get_app_user#034
    as
        l_expect       varchar2(32767);
        l_actual       varchar2(32767);
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.get_app_user
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end get_app_user#034;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(set_app_user#035[pi_app_user,C; pi_from_sys,?UT?])
    procedure set_app_user#035
    as
        l_expect       varchar2(?ut?);
        l_actual       varchar2(?ut?);
    begin
        -- l_expect := ?UT?;
        -- hmx_log.set_app_user
        --     (pi_app_user    => C
        --     ,pi_from_sys    => ?UT?
        --     );
        -- l_actual := '?UT?'; -- unknown at time of unit test generation
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end set_app_user#035;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(N=f_log_msg#036[pi_log_msg,C; pi_log_level,N; pi_log_type,C; pi_log_scope,C; pi_log_tags,C; pi_log_opt,N; pi_object_type,C; pi_skip_units,C])
    procedure f_log_msg#036
    as
        l_expect       number;
        l_actual       number;
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.f_log_msg
        --     (pi_log_msg    => C
        --     ,pi_log_level    => N
        --     ,pi_log_type    => C
        --     ,pi_log_scope    => C
        --     ,pi_log_tags    => C
        --     ,pi_log_opt    => N
        --     ,pi_object_type    => C
        --     ,pi_skip_units    => C
        --     );
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end f_log_msg#036;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(log_msg#037[pi_log_msg,C; pi_log_level,N; pi_log_type,C; pi_log_scope,C; pi_log_tags,C; pi_log_opt,N; pi_object_type,C; pi_skip_units,C])
    procedure log_msg#037
    as
        l_expect       varchar2(?ut?);
        l_actual       varchar2(?ut?);
    begin
        -- l_expect := ?UT?;
        -- hmx_log.log_msg
        --     (pi_log_msg    => C
        --     ,pi_log_level    => N
        --     ,pi_log_type    => C
        --     ,pi_log_scope    => C
        --     ,pi_log_tags    => C
        --     ,pi_log_opt    => N
        --     ,pi_object_type    => C
        --     ,pi_skip_units    => C
        --     );
        -- l_actual := '?UT?'; -- unknown at time of unit test generation
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end log_msg#037;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(N=get_max_log_rate#038)
    procedure get_max_log_rate#038
    as
        l_expect       number;
        l_actual       number;
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.get_max_log_rate
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end get_max_log_rate#038;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(N=set_max_log_rate#039[pi_rate,N])
    procedure set_max_log_rate#039
    as
        l_expect       number;
        l_actual       number;
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.set_max_log_rate
        --     (pi_rate    => N
        --     );
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end set_max_log_rate#039;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(C=get_process_id#040)
    procedure get_process_id#040
    as
        l_expect       varchar2(32767);
        l_actual       varchar2(32767);
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.get_process_id
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end get_process_id#040;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(C=new_process_id#041)
    procedure new_process_id#041
    as
        l_expect       varchar2(32767);
        l_actual       varchar2(32767);
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.new_process_id
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end new_process_id#041;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(set_process_id#042[pi_process_id,C])
    procedure set_process_id#042
    as
        l_expect       varchar2(?ut?);
        l_actual       varchar2(?ut?);
    begin
        -- l_expect := ?UT?;
        -- hmx_log.set_process_id
        --     (pi_process_id    => C
        --     );
        -- l_actual := '?UT?'; -- unknown at time of unit test generation
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end set_process_id#042;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(clear_cached_msg#043)
    procedure clear_cached_msg#043
    as
        l_expect       varchar2(?ut?);
        l_actual       varchar2(?ut?);
    begin
        -- l_expect := ?UT?;
        -- hmx_log.clear_cached_msg
        -- l_actual := '?UT?'; -- unknown at time of unit test generation
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end clear_cached_msg#043;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(cache_msg#044[pi_log_msg,C])
    procedure cache_msg#044
    as
        l_expect       varchar2(?ut?);
        l_actual       varchar2(?ut?);
    begin
        -- l_expect := ?UT?;
        -- hmx_log.cache_msg
        --     (pi_log_msg    => C
        --     );
        -- l_actual := '?UT?'; -- unknown at time of unit test generation
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end cache_msg#044;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(C=get_cached_msg#045[pi_flush,C; pi_max_length,N])
    procedure get_cached_msg#045
    as
        l_expect       varchar2(32767);
        l_actual       varchar2(32767);
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.get_cached_msg
        --     (pi_flush    => C
        --     ,pi_max_length    => N
        --     );
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end get_cached_msg#045;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(log_connection#046)
    procedure log_connection#046
    as
        l_expect       varchar2(?ut?);
        l_actual       varchar2(?ut?);
    begin
        -- l_expect := ?UT?;
        -- hmx_log.log_connection
        -- l_actual := '?UT?'; -- unknown at time of unit test generation
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end log_connection#046;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(C=get_called_from_formatted#047[pi_log_pkid,N])
    procedure get_called_from_formatted#047
    as
        l_expect       varchar2(32767);
        l_actual       varchar2(32767);
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.get_called_from_formatted
        --     (pi_log_pkid    => N
        --     );
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end get_called_from_formatted#047;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(log_run_script#048[pi_log_script,C; pi_log_tags,C])
    procedure log_run_script#048
    as
        l_expect       varchar2(?ut?);
        l_actual       varchar2(?ut?);
    begin
        -- l_expect := ?UT?;
        -- hmx_log.log_run_script
        --     (pi_log_script    => C
        --     ,pi_log_tags    => C
        --     );
        -- l_actual := '?UT?'; -- unknown at time of unit test generation
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end log_run_script#048;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(get_log_row#049[pio_hmx_log_row,?UT?])
    procedure get_log_row#049
    as
        l_expect       varchar2(?ut?);
        l_actual       varchar2(?ut?);
    begin
        -- l_expect := ?UT?;
        -- hmx_log.get_log_row
        --     (pio_hmx_log_row    => ?UT?
        --     );
        -- l_actual := '?UT?'; -- unknown at time of unit test generation
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end get_log_row#049;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(T=get_last_logtime#050)
    procedure get_last_logtime#050
    as
        l_expect       timestamp with time zone;
        l_actual       timestamp with time zone;
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.get_last_logtime
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end get_last_logtime#050;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(N=get_last_log_pkid#051)
    procedure get_last_log_pkid#051
    as
        l_expect       number;
        l_actual       number;
    begin
        -- l_expect := ?UT?;
        -- l_actual := hmx_log.get_last_log_pkid
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end get_last_log_pkid#051;

    --#endcontext
    -- Number of tests generated: 51
    -- End of suite(Test package hmol.hmx_log)

end ut_hmx_log;
/


