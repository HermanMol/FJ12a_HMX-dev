prompt *I: ScriptBOF hmx_install_all.sql
prompt ---------------------------------------------------------------------------------------------;
@hmx_spoolstart hmx_install_all.sql

@@..\..\procedures\prt.sql

@@..\..\type_specs\t_string_varray50.sql
@@..\..\type_specs\string_stack_type.sql
@@..\..\type_bodies\string_stack_type.sql

@@..\..\sequences\hmx_log_data_seq.sql

@@..\..\tables\hmx_ddl_log_data.sql
@@..\..\tables\hmx_log_data.sql

@@..\..\package_specs\hmx_types.sql
@@..\..\package_specs\hmx_utl.sql
@@..\..\package_specs\hmx_session.sql
@@..\..\package_specs\hmx_call_stack.sql
@@..\..\package_specs\hmx_log_core.sql
@@..\..\package_specs\hmx_log.sql
@@..\..\package_specs\hmx_annotations.sql
@@..\..\package_specs\hmx_utplsql_utl.sql

@@..\..\operators\hmx_operators_ALL_install.sql

@@..\..\package_bodies\hmx_utl.sql
@@..\..\package_bodies\hmx_session.sql
@@..\..\package_bodies\hmx_call_stack.sql
@@..\..\package_bodies\hmx_log_core.sql
@@..\..\package_bodies\hmx_log.sql
@@..\..\package_bodies\hmx_annotations.sql
@@..\..\package_bodies\hmx_utplsql_utl.sql

@@..\..\triggers\hmx_ddl_logging.sql
-- make shure the DDL-logging is not operational - yet.
@@..\..\triggers\hmx_ddl_trigger_disable.sql

@@..\..\views\hmx_ddl_log_data_version.sql
@@..\..\views\hmx_sys_context_userenv.sql
@@..\..\views\hmx_all_annotations.sql
@@..\..\views\hmx_all_object_versions.sql
@@..\..\views\hmx_log_with_object_version.sql
@@..\..\views\hmx_log_all_nice.sql
@@..\..\views\hmx_utplsql_suite_info.sql

@@..\..\procedures\hmx_test_log_module.sql
@@..\..\package_specs\hmx_call_stack_tests.sql
@@..\..\package_bodies\hmx_call_stack_tests.sql

@@..\..\object_grants\hmx_ddl_log_data.sql

@hmx_report_invalid_all

@hmx_recompile_invalid_all

@hmx_report_invalid_all

-- ENABLE the DDL-trigger AFTER ALL DDL-logging related objects have been created!
@@..\..\triggers\hmx_ddl_trigger_enable.sql

-- Install the Unit Test modules
@@hmx_install_ut_modules.sql

begin
    hmx_log.log_msg(pi_log_msg=>'All HMX-objects installed script using hmx_install_all.sql.',pi_log_tags=>'INSTALL');
end;
/

prompt *I: ScriptEOF hmx_install_all.sql
@hmx_spoolfinish
prompt Done.
