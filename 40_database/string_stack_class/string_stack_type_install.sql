prompt *I: ScriptBOF string_stack_type_install.sql
-- Generate a unique spoolfile name
@hmx_spoolstart string_stack_type_install.sql

@string_stack_type_drop.sql

@t_string_varray50_typ.sql
show errors

@string_stack_type_tps.sql
show errors

@string_stack_type_tpb.sql
show errors

@hmx_spoolfinish
prompt *I: ScriptEOF string_stack_type_install.sql
