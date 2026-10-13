prompt *I: ScriptBOF deploy_string_stack_type.sql
-- Generate a unique spoolfile name
@hmx_spoolstart deploy_string_stack_type.sql

@typ_t_string_varray50.sql
show errors

@tps_string_stack_type.sql
show errors

@tpb_string_stack_type.sql
show errors

@hmx_spoolfinish
prompt *I: ScriptEOF deploy_string_stack_type.sql
