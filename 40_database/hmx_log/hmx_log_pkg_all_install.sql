prompt *I: ScriptBOF hmx_log_pkg_all_install.sql

@@hmx_log_data_seq.sql
@@hmx_log_data_tbl.sql

@@hmx_log_core_pks.sql

@@hmx_log_pks.sql

@@hmx_log_core_pkb.sql

@@hmx_log_pkb.sql

--Prompt: *I: Errors for package hmx_log_core
--show errors package hmx_log_core
--
--Prompt: *I: Errors for package hmx_log
--show errors package hmx_log
--
--Prompt: *I: Errors for package body hmx_log_core
--show errors package body hmx_log_core
--
--Prompt: *I: Errors for package body hmx_log_core
--show errors package body hmx_log

@hmx_recompile_invalid_all

prompt *I: ScriptEOF hmx_log_pkg_all_install.sql
