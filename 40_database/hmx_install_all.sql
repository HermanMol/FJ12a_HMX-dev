prompt *I: ScriptBOF hmx_install_all.sql
prompt ---------------------------------------------------------------------------------------------;

@hmx_session\hmx_types_pkg_install.sql

@string_stack_class\string_stack_type_install.sql

@hmx_utl\hmx_utl_pkg_install.sql

@hmx_session\hmx_session_pkg_install.sql

@\hmx_operators\hmx_operators_opr.sql

@hmx_call_stack\hmx_call_stack_pkg_install.sql

@hmx_annotations\hmx_annotations_pkg_install.sql

show errors

prompt *I: ScriptEOF hmx_install_all.sql
