prompt *I: ScriptBOF utrun_hmx_log.sql
@hmx_spoolstart utrun_hmx_log.sql
execute ut.run('HMOL.UT_hmx_log');
@hmx_spoolfinish
prompt *I: ScriptEOF utrun_hmx_log.sql
