prompt *I: ScriptBOF hmx_install_all.sql
prompt ---------------------------------------------------------------------------------------------;

@hmx_utl\prt_prc.sql

@hmx_spoolstart hmx_install_all.sql

@hmx_log\hmx_log_data_seq.sql

@hmx_log\hmx_log_data_tbl.sql

@hmx_types\hmx_types_pkg_install.sql

@string_stack_class\string_stack_type_install.sql

--@hmx_utl\hmx_utl_pkg_install.sql
@hmx_utl\hmx_utl_pks.sql
--@hmx_session\hmx_session_pkg_install.sql
@hmx_session\hmx_session_pks.sql
--@hmx_log\hmx_log_pkg_all_install.sql
@hmx_log\hmx_log_core_pks.sql
@hmx_log\hmx_log_pks.sql
--@hmx_call_stack\hmx_call_stack_pkg_install.sql
@hmx_call_stack\hmx_call_stack_pks.sql
--@hmx_annotations\hmx_annotations_install_all.sql
@hmx_annotations\hmx_annotations_pks.sql

@hmx_operators\hmx_operators_opr.sql

@hmx_annotations\hmx_annotations_install_all.sql

@hmx_utl\hmx_utl_pkb.sql
@hmx_session\hmx_session_pkb.sql
@hmx_log\hmx_log_core_pkb.sql
@hmx_log\hmx_log_pkb.sql
@hmx_call_stack\hmx_call_stack_pkb.sql
@hmx_annotations\hmx_annotations_pkb.sql

@hmx_annotations\hmx_all_annotations_svw.sql
@hmx_annotations\hmx_all_object_versions_svw.sql
@hmx_session\hmx_sys_context_userenv_svw.sql

@hmx_call_stack\hmx_test_log_module_prc.sql
@hmx_call_stack\hmx_call_stack_tests_pks.sql
@hmx_call_stack\hmx_call_stack_tests_pkb.sql

show errors

@hmx_recompile_invalid_all

show errors

@hmx_spoolfinish

prompt *I: ScriptEOF hmx_install_all.sql
