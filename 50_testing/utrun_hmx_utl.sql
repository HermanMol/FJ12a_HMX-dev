prompt *I: ScriptBOF utrun_hmx_utl.sql
@hmx_spoolstart utrun_hmx_utl.sql
execute ut.run('HMOL.UT_HMX_UTL');
@hmx_spoolfinish
prompt *I: ScriptEOF utrun_hmx_utl.sql
