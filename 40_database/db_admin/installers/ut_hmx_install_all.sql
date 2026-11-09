@hmx_spoolstart ut_hmx_install_all.sql
prompt *I: ScriptBOF ut_hmx_install_all.sql
@@..\..\package_specs\ut_hmx_session.sql
@@..\..\package_bodies\ut_hmx_session.sql
@hmx_recompile_invalid_all
@hmx_report_invalid_all
prompt *I: ScriptEOF ut_hmx_install_all.sql
@hmx_spoolfinish
prompt Done.
