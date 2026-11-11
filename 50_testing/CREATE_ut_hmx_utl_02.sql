prompt *I: ScriptBOF CREATE_ut_hmx_utl_02.sql
exec dbms_session.reset_package;

@hmx_spoolstart CREATE_ut_hmx_utl_02.sql
prompt *I: Generating new package ut_hmx_utl_02 ...
@hmx_spoolfinish

-- Define the variable values
define v_package_name = "HMX_UTL"
define v_suite        = "Suite_2026-11-11 17:11:05"
define v_suitepath    = "HMXTESTS.&v_package_name.-pkg"
define v_context      = "Context_FJ12a"

spool ..\40_database\package_specs\ut_hmx_utl_02.sql
begin

    hmx_utplsql_utl.set_tags('utPLSQL_' || regexp_substr(ut.version,'(v([0-9]+\.){3})',1,1,'i',1));

    hmx_utplsql_utl.generate_test_package_spec
        (pi_package_name => '&v_package_name.'
        ,pi_suite        => '&v_suite.'
        ,pi_suitepath    => '&v_suitepath.'
        ,pi_context      => '&v_context.'
        );

end;
/
spool off

spool ..\40_database\package_bodies\ut_hmx_utl_02.sql
begin

    hmx_utplsql_utl.set_tags('utPLSQL_' || regexp_substr(ut.version,'(v([0-9]+\.){3})',1,1,'i',1));

    hmx_utplsql_utl.generate_test_package_body
        (pi_package_name => '&v_package_name.'
        ,pi_suite        => '&v_suite.'
        ,pi_suitepath    => '&v_suitepath.'
        ,pi_context      => '&v_context.'
        );

end;
/
spool off

@hmx_spoolstart CREATE_ut_hmx_utl_02.sql
prompt *I: Compile new version of utPLSQL test package ut_hmx_utl_02 ...
prompt *I: Specification ...
@@..\40_database\package_specs\ut_hmx_utl_02.sql
prompt *I: Body ...
@@..\40_database\package_bodies\ut_hmx_utl_02.sql
@hmx_recompile_invalid_all
@hmx_report_invalid_all
prompt *I: Done.
@hmx_spoolfinish

prompt *I: ScriptEOF CREATE_ut_hmx_utl_02.sql
