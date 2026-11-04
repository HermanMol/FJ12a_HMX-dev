prompt *I: ScriptBOF hmx_log_data.sql
comment  on table hmx_log_data is 'Herman Mol Extras - Log (Oracle 19+)';

comment on column hmx_log_data.log_pkid            is 'Unique primary key, ordered and consecutive, based on sequence HMX_LOG_DATA_SEQ.';
comment on column hmx_log_data.log_msg             is 'The actual log message.';
comment on column hmx_log_data.log_time            is 'The date and time the message was inserted in this database.';
comment on column hmx_log_data.log_type            is 'The type of message. Unrestricted but these are the predefined values: (default) INFO, TECH, FUNC, TRACE, DEVELOP, DEBUG, TESTING, AUDIT, SECURITY, LOGGING.';
comment on column hmx_log_data.log_level           is 'The severity level of the message: (default) 0=not_specified,5=cache,10=normal,15=attention,20=warning,25=error,30=severe,35=critical. For trace/debug a negative value indicates the execution level at which the message was issued. Unrestricted.';
comment on column hmx_log_data.log_scope           is 'The scope of the message, Unrestricted but these are the predefined values: DEVELOPER, TESTER, ADMIN, OPERATIONS, USER, KEYUSER and (default) ANYONE.';
comment on column hmx_log_data.log_tags            is 'Optional tags to easy identifying specific log messages, e.g. a ticket/issue/user story code. Advice: separate multiple tags with a semicolon.';
comment on column hmx_log_data.log_org_owner       is 'The owner of the object that the message orginates from.';
comment on column hmx_log_data.log_org_object      is 'The name of the package, trigger, schema-level procedure or function or "anonymous" that the message orginates from.';
comment on column hmx_log_data.log_org_type        is 'The type name of the package procedure or function that the message orginates from.';
comment on column hmx_log_data.log_org_method      is 'The name of the package procedure or function that the message orginates from.';
comment on column hmx_log_data.log_org_line        is 'The line number in the object that the message orginates from.';
comment on column hmx_log_data.log_call_depth      is 'The Oracle CALL_STACK depth at which the call to log message was requested.';
comment on column hmx_log_data.log_process         is 'The process that this message was issued in. Messages in one process most likely have the same process_id.';
comment on column hmx_log_data.log_sqlerrm         is 'The SQLERRM if the message was issued during the execution of an EXCEPTION handler.';
comment on column hmx_log_data.log_sqlcode         is 'The SQLCODE if the message was issued during the execution of an EXCEPTION handler.';
comment on column hmx_log_data.log_call_stack      is 'The call stack from DBMS_UTILITY.FORMAT_CALL_STACK() if the message was issued during the execution of an EXCEPTION handler or by request in the logging call.';
comment on column hmx_log_data.log_error_backtrace is 'The error stack from DBMS_UTILITY.FORMAT_ERROR_BACKTRACE() if the message was issued during the execution of an EXCEPTION handler.';
comment on column hmx_log_data.log_sesid           is 'The value of SYS_CONTEXT(USERENV,SESSIONID).';
comment on column hmx_log_data.log_server          is 'The value of SYS_CONTEXT(USERENV,SERVER_HOST).';
comment on column hmx_log_data.log_dbname          is 'The value of SYS_CONTEXT(USERENV,DB_NAME).';
comment on column hmx_log_data.log_dbschema        is 'The value of SYS_CONTEXT(USERENV,CURRENT_SCHEMA). Depends on Invoker/Definer rights of the package.';
comment on column hmx_log_data.log_dbuser          is 'The value of SYS_CONTEXT(USERENV,SESSION_USER).';
comment on column hmx_log_data.log_osuser          is 'The value of SYS_CONTEXT(USERENV,OS_USER).';
comment on column hmx_log_data.log_app_user        is 'The Application user, like in APEX the v(app_user).';


prompt *I: ScriptEOF hmx_log_data.sql
