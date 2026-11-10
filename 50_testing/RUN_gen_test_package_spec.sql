prompt *I: ScriptBOF RUN_gen_test_package_spec.sql
@hmx_spoolstart RUN_gen_test_package_spec.sql
begin

    hmx_utplsql_utl.gen_test_package_spec('HMX_UTL');

end;
/
@hmx_spoolfinish
prompt *I: ScriptEOF RUN_gen_test_package_spec.sql
