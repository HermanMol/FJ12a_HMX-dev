prompt *I: ScriptBOF hmx_install_ut_modules.sql
exec hmx_log.log_run_script(pi_log_script => '~\10_wrk\40_database\db_admin\installers\hmx_install_ut_modules.sql['||$$plsql_line||']',pi_log_tags => 'INSTALL');
-- Install test modules

prompt *A: DDL-trigger DISABLED to avoid these unit test module changes being logged
@@..\..\triggers\hmx_ddl_trigger_disable.sql

@@..\..\package_specs\ut_hmx_annotations.sql
@@..\..\package_specs\ut_hmx_session.sql
@@..\..\package_specs\ut_hmx_utl.sql

@@..\..\package_bodies\ut_hmx_annotations.sql
@@..\..\package_bodies\ut_hmx_session.sql
@@..\..\package_bodies\ut_hmx_utl.sql

@hmx_report_invalid_all
@hmx_recompile_invalid_all

-- Enable the DDL-trigger to have changes being logged
@@..\..\triggers\hmx_ddl_trigger_enable.sql
prompt *I: DDL-trigger ENABLED to log DDL changes

prompt *I: ScriptEOF hmx_install_ut_modules.sql
