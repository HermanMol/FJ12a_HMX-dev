prompt *I: ScriptBOF hmx_sys_context_userenv.sql
comment on table  hmx_sys_context_userenv            is 'Showing all SYS_CONTEXT(userenv) values. Causes no exception when an unknown into_item is requested.';
comment on column hmx_sys_context_userenv.info_item  is 'The USERENV context attribute to be reported.';
comment on column hmx_sys_context_userenv.info_value is 'The USERENV context attribute value.';
comment on column hmx_sys_context_userenv.sql_cmd    is 'The SYS_CONTEXT(userenv...) statement.';

prompt *I: ScriptEOF hmx_sys_context_userenv.sql
