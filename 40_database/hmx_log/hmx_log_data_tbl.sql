prompt *I: ScriptBOF hmx_log_tbl.sql

drop table if exists hmx_log_data  cascade constraints purge
/

create table hmx_log_data
    (log_pkid            number(38,0)        default on null hmx_log_data_seq.nextval not null
    ,log_msg             varchar2(4000 char)
    ,log_tag             varchar2(100 char)
    ,log_time            TIMESTAMP (9) WITH LOCAL TIME ZONE default on null current_timestamp (9) not null
    ,log_type            varchar2(8 char)  default 'INFO'   not null
    ,log_level           number(3,0)       default 0        not null
    ,log_scope           varchar2(10 char) default 'ANYONE' not null
    ,log_org_owner       varchar2(128 char)
    ,log_org_object      varchar2(128 char)
    ,log_org_method      varchar2(128 char)
    ,log_org_line        number(7,0)
    ,log_process         varchar2(100 char)
    ,log_sqlerrm         varchar2(512 char)
    ,log_sqlcode         number(7,0)
    ,log_call_stack      varchar2(4000 char)
    ,log_error_backtrace varchar2(4000 char)
    ,log_sesid           varchar2(32 char)
    ,log_server          varchar2(128 char)
    ,log_dbname          varchar2(128 char)
    ,log_dbschema        varchar2(128 char)
    ,log_dbuser          varchar2(128 char)
    ,log_osuser          varchar2(128 char)
    ,constraint hmx_log_data_pk primary key (log_pkid)
    )
/
alter table hmx_log_data
    annotations
        (add hmx_object_usage    'Herman Mol Extras - Log (Oracle 19+).'
        ,add hmx_object_notes    'Oracle Annotations are found on ALL_ANNOTATIONS_USAGE view and HMX-annotations extracted from text lines in ALL_SOURCE view.'
        ,add hmx_developer_notes 'See HMX General Developer Notes'
        ,add hmx_object_version  '2026-10-22 09:30:36 +02:00'
        ,add hmx_db_version      'Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0'
        ,add hmx_object_repo     'git@github.com:HermanMol/FJ12a_HMX-dev.git'
        )
/

alter table hmx_log_data
modify
    (log_pkid            annotations (add hmx_column_usage 'Unique primary key, ordered and consecutive, based on sequence HMX_LOG_DATA_SEQ.'
                                     ,add hmx_column_sequence 'hmx_log_data_seq'
                                     )
    ,log_msg             annotations (add hmx_column_usage 'The actual log message.')
    ,log_tag             annotations (add hmx_column_usage 'Free format for tags for logical grouping of messages, e.g. a test case reference or a REST message UID.')
    ,log_time            annotations (add hmx_column_usage 'The date and time the message was inserted in this database. A Timestamp with local time zone.')
    ,log_type            annotations (add hmx_column_usage 'The type of message. Unrestricted but these are the predefined values: (default) INFO, TECH, FUNC, TRACE, DEVELOP, DEBUG, TESTING, AUDIT, SECURITY.')
    ,log_level           annotations (add hmx_column_usage 'The severity level of the message: (default) 0=not_specified, 10=normal,15=attention,20=warning,25=error,30=severe,35=critical For trace/debug a negative value indicates the execution level at which the message was issued. Unrestricted.')
    ,log_scope           annotations (add hmx_column_usage 'The scope of the message, Unrestricted but these are the predefined values: DEVELOPER, TESTER, ADMIN, OPERATIONS, USER, KEYUSER and (default) ANYONE.')
    ,log_org_owner       annotations (add hmx_column_usage 'The owner of the object that the message orginates from.')
    ,log_org_object      annotations (add hmx_column_usage 'The name of the package, trigger, schema-level procedure or function or "anonymous" that the message orginates from.')
    ,log_org_method      annotations (add hmx_column_usage 'The name of the package procedure or function that the message orginates from.')
    ,log_org_line        annotations (add hmx_column_usage 'The line number in the object that the message orginates from.')
    ,log_process         annotations (add hmx_column_usage 'The process that this message was issued in. Messages in one process most likely have the same process_id.')
    ,log_sqlerrm         annotations (add hmx_column_usage 'The SQLERRM if the message was issued during the execution of an EXCEPTION.')
    ,log_sqlcode         annotations (add hmx_column_usage 'The SQLCODE if the message was issued during the execution of an EXCEPTION.')
    ,log_call_stack      annotations (add hmx_column_usage 'The call stack from DBMS_UTILITY.FORMAT_CALL_STACK() if the message was issued during the execution of an EXCEPTION.')
    ,log_error_backtrace annotations (add hmx_column_usage 'The error stack from DBMS_UTILITY.FORMAT_ERROR_BACKTRACE() if the message was issued during the execution of an EXCEPTION.')
    ,log_sesid           annotations (add hmx_column_usage 'The value of SYS_CONTEXT(USERENV,SESSIONID).')
    ,log_server          annotations (add hmx_column_usage 'The value of SYS_CONTEXT(USERENV,SERVER_HOST).')
    ,log_dbname          annotations (add hmx_column_usage 'The value of SYS_CONTEXT(USERENV,DB_NAME).')
    ,log_dbschema        annotations (add hmx_column_usage 'The value of SYS_CONTEXT(USERENV,CURRENT_SCHEMA).')
    ,log_dbuser          annotations (add hmx_column_usage 'The value of SYS_CONTEXT(USERENV,SESSION_USER).')
    ,log_osuser          annotations (add hmx_column_usage 'The value of SYS_CONTEXT(USERENV,OS_USER).')
    )
/

comment  on table hmx_log_data is 'Herman Mol Extras - Log (Oracle 19+)';

comment on column hmx_log_data.log_pkid            is 'Unique primary key, ordered and consecutive, based on sequence HMX_LOG_DATA_SEQ.';
comment on column hmx_log_data.log_msg             is 'The actual log message.';
comment on column hmx_log_data.log_tag             is 'Free format for tags for logical grouping of messages, e.g. a test case reference or a REST message UID.';
comment on column hmx_log_data.log_time            is 'The date and time the message was inserted in this database. A timestamp with local time zone.';
comment on column hmx_log_data.log_type            is 'The type of message. Unrestricted but these are the predefined values: (default) INFO, TECH, FUNC, TRACE, DEVELOP, DEBUG, TESTING, AUDIT, SECURITY.';
comment on column hmx_log_data.log_level           is 'The severity level of the message: (default) 0=not_specified, 10=normal,15=attention,20=warning,25=error,30=severe,35=critical For trace/debug a negative value indicates the execution level at which the message was issued. Unrestricted.';
comment on column hmx_log_data.log_scope           is 'The scope of the message, Unrestricted but these are the predefined values: DEVELOPER, TESTER, ADMIN, OPERATIONS, USER, KEYUSER and (default) ANYONE.';
comment on column hmx_log_data.log_org_owner       is 'The owner of the object that the message orginates from.';
comment on column hmx_log_data.log_org_object      is 'The name of the package, trigger, schema-level procedure or function or "anonymous" that the message orginates from.';
comment on column hmx_log_data.log_org_method      is 'The name of the package procedure or function that the message orginates from.';
comment on column hmx_log_data.log_org_line        is 'The line number in the object that the message orginates from.';
comment on column hmx_log_data.log_process         is 'The process that this message was issued in. Messages in one process most likely have the same process_id.';
comment on column hmx_log_data.log_sqlerrm         is 'The SQLERRM if the message was issued during the execution of an EXCEPTION.';
comment on column hmx_log_data.log_sqlcode         is 'The SQLCODE if the message was issued during the execution of an EXCEPTION.';
comment on column hmx_log_data.log_call_stack      is 'The call stack from DBMS_UTILITY.FORMAT_CALL_STACK() if the message was issued during the execution of an EXCEPTION.';
comment on column hmx_log_data.log_error_backtrace is 'The error stack from DBMS_UTILITY.FORMAT_ERROR_BACKTRACE() if the message was issued during the execution of an EXCEPTION.';
comment on column hmx_log_data.log_sesid           is 'The value of SYS_CONTEXT(USERENV,SESSIONID).';
comment on column hmx_log_data.log_server          is 'The value of SYS_CONTEXT(USERENV,SERVER_HOST).';
comment on column hmx_log_data.log_dbname          is 'The value of SYS_CONTEXT(USERENV,DB_NAME).';
comment on column hmx_log_data.log_dbschema        is 'The value of SYS_CONTEXT(USERENV,CURRENT_SCHEMA).';
comment on column hmx_log_data.log_dbuser          is 'The value of SYS_CONTEXT(USERENV,SESSION_USER).';
comment on column hmx_log_data.log_osuser          is 'The value of SYS_CONTEXT(USERENV,OS_USER).';

prompt *I: ScriptEOF hmx_log_tbl.sql
