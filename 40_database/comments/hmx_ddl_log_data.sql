prompt *I: ScriptBOF hmx_ddl_log_data.sql
comment on table hmx_ddl_log_data is 'Logging of DDL events on this database. Source from http://psoug.org/reference/ddl_trigger.html';

comment on column hmx_ddl_log_data.act_sysdate    is 'The SYSTIMESTAMP with DB time zone.';
comment on column hmx_ddl_log_data.object_owner   is 'The owner of the object.';
comment on column hmx_ddl_log_data.object_name    is 'The object name of the object, like in ALL_OBJECTS.';
comment on column hmx_ddl_log_data.object_type    is 'The object type of the object, like in ALL_OBJECTS.';
comment on column hmx_ddl_log_data.operation      is 'The operation: CREATE, DROP, ALTER ...';
comment on column hmx_ddl_log_data.act_user       is 'The USER value.';
comment on column hmx_ddl_log_data.act_server     is 'The value of sys_context("USERENV","SERVER_HOST")';
comment on column hmx_ddl_log_data.act_dbname     is 'The value of sys_context("USERENV","DB_NAME")';
comment on column hmx_ddl_log_data.act_schema     is 'The value of sys_context("USERENV","CURRENT_SCHEMA")';
comment on column hmx_ddl_log_data.act_dbuser     is 'The value of sys_context("USERENV","SESSION_USER")';
comment on column hmx_ddl_log_data.act_osuser     is 'The value of sys_context("USERENV","OS_USER")';
comment on column hmx_ddl_log_data.act_host       is 'The value of sys_context("USERENV","USERENV","HOST")';
comment on column hmx_ddl_log_data.act_ip_address is 'The value of sys_context("USERENV","USERENV","IP_ADDRESS")';
comment on column hmx_ddl_log_data.act_module     is 'The value of sys_context("USERENV","USERENV","MODULE")';
comment on column hmx_ddl_log_data.act_terminal   is 'The value of sys_context("USERENV","USERENV","TERMINAL")';
comment on column hmx_ddl_log_data.old_text       is 'The old source text.';

prompt *I: ScriptEOF hmx_ddl_log_data.sql
