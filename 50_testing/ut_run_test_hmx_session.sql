@hmx_spoolstart ut_run_test_hmx_session.sql
prompt *I: ScriptBOF ut_run_test_hmx_session.sql
begin
    ut.run('ut_hmx_session');
end;
/
prompt *I: ScriptEOF ut_run_test_hmx_session.sql
@hmx_spoolfinish
prompt Done.
