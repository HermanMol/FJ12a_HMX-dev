create or replace force view hmx_log_with_object_version
    (log_pkid            annotations (add hmx_column_usage 'Unique primary key, ordered and consecutive, based on sequence HMX_LOG_DATA_SEQ.')
    ,"Log Time*"         annotations (add hmx_column_usage 'The abbreviated date and time the message was inserted in this database. Irrelevant items of the timestamp are not shown. Date and time in local timezone.')
    ,log_msg             annotations (add hmx_column_usage 'The actual log message.')
    ,log_type            annotations (add hmx_column_usage 'The type of message. Unrestricted but these are the predefined values: (default) INFO, TECH, FUNC, TRACE, DEVELOP, DEBUG, TESTING, AUDIT, SECURITY.')
    ,"Level*"            annotations (add hmx_column_usage 'The severity level name of the message: (default) 0=not_specified, 10=normal,15=attention,20=warning,25=error,30=severe,35=critical For trace/debug a negative value indicates the execution level at which the message was issued. Unrestricted.')
    ,"Called From*"      annotations (add hmx_column_usage 'Combination of the owner, name, type and line where this log message originates from if it was a database object.')
    ,"Object version*"   annotations (add hmx_column_usage 'Attempt to list the HMX-annotation HMX_OBJECT_VERSION currently in the database (NOT the version at time of the logging!).')
    ,log_timestamp       annotations (add hmx_column_usage 'The full date and time the message was inserted in this database. A Timestamp with local time zone.')
    ,log_scope           annotations (add hmx_column_usage 'The scope of the message, Unrestricted but these are the predefined values: DEVELOPER, TESTER, ADMIN, OPERATIONS, USER, KEYUSER and (default) ANYONE.')
    ,log_tags            annotations (add hmx_column_usage 'Optional tags to easy identifying specific log messages, e.g. a ticket/issue/user story code. Advice: separate multiple tags with a semicolon.')
    ,log_call_depth      annotations (add hmx_column_usage 'The Oracle CALL_STACK depth at which the call to log message was requested.')
    ,log_process         annotations (add hmx_column_usage 'The process that this message was issued in. Messages in one process most likely have the same process_id.')
    ,log_sqlerrm         annotations (add hmx_column_usage 'The SQLERRM if the message was issued during the execution of an EXCEPTION.')
    ,log_sqlcode         annotations (add hmx_column_usage 'The SQLCODE if the message was issued during the execution of an EXCEPTION.')
    ,log_call_stack      annotations (add hmx_column_usage 'The call stack from DBMS_UTILITY.FORMAT_CALL_STACK() if the message was issued during the execution of an EXCEPTION.')
    ,log_error_backtrace annotations (add hmx_column_usage 'The error stack from DBMS_UTILITY.FORMAT_ERROR_BACKTRACE() if the message was issued during the execution of an EXCEPTION.')
    ,log_sesid           annotations (add hmx_column_usage 'The value of SYS_CONTEXT(USERENV,SESSIONID).')
    ,log_server          annotations (add hmx_column_usage 'The value of SYS_CONTEXT(USERENV,SERVER_HOST).')
    ,log_dbname          annotations (add hmx_column_usage 'The value of SYS_CONTEXT(USERENV,DB_NAME).')
    ,log_dbschema        annotations (add hmx_column_usage 'The value of SYS_CONTEXT(USERENV,CURRENT_SCHEMA). Depends on Invoker/Definer rights of the package.')
    ,log_dbuser          annotations (add hmx_column_usage 'The value of SYS_CONTEXT(USERENV,SESSION_USER).')
    ,log_osuser          annotations (add hmx_column_usage 'The value of SYS_CONTEXT(USERENV,OS_USER).')
    ,log_app_user        annotations (add hmx_column_usage 'The Application user, like in APEX the v(app_user).')
    ,log_org_owner       annotations (add hmx_column_usage 'The owner of the object that the message orginates from.')
    ,log_org_object      annotations (add hmx_column_usage 'The name of the log_org_object that the message orginates from.')
    ,log_org_type        annotations (add hmx_column_usage 'The type name of the package procedure or function that the message orginates from.')
    ,log_org_method      annotations (add hmx_column_usage 'The name of the package procedure or function that the message orginates from.')
    ,log_org_line        annotations (add hmx_column_usage 'The line number in the object that the message orginates from.')
    )
    annotations
        (add hmx_object_usage    'Herman Mol Extras - Logged data using HMX_LOG package with the current object version (Oracle 19+).'
        ,add hmx_object_notes    'Some columns are not directly from HMX_LOG_DATA, but a bit more fancy.'
        ,add hmx_developer_notes 'See HMX General Developer Notes'
        ,add hmx_object_version  '2026-10-29 18:20:06 +01:00'
        ,add hmx_db_version      'Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0'
        ,add hmx_object_repo     'git@github.com:HermanMol/FJ12a_HMX-dev.git'
        )
as
select log_pkid
    ,case when to_char(log_time,'yyyymm') = to_char(current_date,'yyyymm') then to_char(log_time,'dd hh24:mi:ss') 
        when to_char(log_time,'yyyy') = to_char(current_date,'yyyy') then to_char(log_time,'mm-dd hh24:mi:ss') 
        else to_char(log_time,'yyyy-mm-dd hh24:mi:ss')
        end                             as "Log Time*"
    ,log_msg
    ,log_type
    ,hmx_log.log_level_name(log_level)  as "Level*"
    ,case 
        when log_org_type = hmx_log.fk_script then log_org_object
        else hmx_log.get_called_from_formatted(log_pkid) 
        end                             as "Called From*"
    ,case when log_org_owner is not null then hmx_annotations.get_object_version_value(pi_owner => LOG_ORG_OWNER, pi_object_name => LOG_ORG_OBJECT, pi_object_type => LOG_ORG_TYPE) 
        else '-'
        end as "Object version*"
    ,log_time                           as log_timestamp
    ,log_scope
    ,log_tags
    ,log_call_depth
    ,log_process
    ,log_sqlerrm
    ,log_sqlcode
    ,log_call_stack
    ,log_error_backtrace
    ,log_sesid
    ,log_server
    ,log_dbname
    ,log_dbschema
    ,log_dbuser
    ,log_osuser
    ,log_app_user
    ,log_org_owner
    ,log_org_object
    ,nvl(log_org_type,'(package body?)') as log_org_type
    ,log_org_method
    ,log_org_line
from hmx_log_data
/




/*
select log_pkid
    ,case when to_char(log_time,'yyyymm') = to_char(current_date,'yyyymm') then to_char(log_time,'dd hh24:mi:ss') 
        when to_char(log_time,'yyyy') = to_char(current_date,'yyyy') then to_char(log_time,'mm-dd hh24:mi:ss') 
        else to_char(log_time,'yyyy-mm-dd hh24:mi:ss')
        end                             as "Log Time*"
    ,log_msg
    ,log_type
    ,hmx_log.log_level_name(log_level) as "Level*"
    ,hmx_log.log_level_name(log_level)  as "Level*"
    ,case 
        when log_org_type = hmx_log.fk_script then log_org_object
        else hmx_log.get_called_from_formatted(log_pkid) 
        end                             as "Called from*"
    ,case when log_org_owner is not null then hmx_annotations.get_object_version_value(pi_owner => LOG_ORG_OWNER, pi_object_name => LOG_ORG_OBJECT, pi_object_type => LOG_ORG_TYPE) 
        else '-'
        end as "Object version*"
--    ,log_org_owner
--    ,log_org_object
--    ,nvl(log_org_type,'(package body?)') as log_org_type
--    ,log_org_method
--    ,log_org_line
    ,log_time                           as log_timestamp
    ,log_scope
    ,log_tags
    ,log_call_depth
    ,log_process
    ,log_sqlerrm
    ,log_sqlcode
    ,log_call_stack
    ,log_error_backtrace
    ,log_sesid
    ,log_server
    ,log_dbname
    ,log_dbschema
    ,log_dbuser
    ,log_osuser
    ,log_app_user
from hmx_log_data
/
*/
