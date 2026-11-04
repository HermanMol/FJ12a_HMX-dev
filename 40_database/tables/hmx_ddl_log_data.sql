prompt *I: ScriptBOF hmx_ddl_log_data.sql

create table hmx_ddl_log_data
    (act_sysdate    timestamp with time zone default on null systimestamp not null
    ,object_owner   varchar2(128 char) not null
    ,object_name    varchar2(128 char) not null
    ,object_type    varchar2(128 char) not null
    ,operation      varchar2(128 char) not null
    ,act_user       varchar2(128 char) default user                                    not null
    ,act_server     varchar2(128 char) default sys_context('USERENV','SERVER_HOST')    not null
    ,act_dbname     varchar2(128 char) default sys_context('USERENV','DB_NAME')        not null
    ,act_schema     varchar2(128 char) default sys_context('USERENV','CURRENT_SCHEMA') not null
    ,act_dbuser     varchar2(128 char) default sys_context('USERENV','SESSION_USER')   not null
    ,act_osuser     varchar2(128 char) default sys_context('USERENV','OS_USER')        not null
    ,act_host       VARCHAR2(128 char) default sys_context('USERENV','HOST')           not null
    ,act_ip_address VARCHAR2(128 char) default sys_context('USERENV','IP_ADDRESS')     not null
    ,act_module     VARCHAR2(128 char) default sys_context('USERENV','MODULE')         not null
    ,act_terminal   VARCHAR2(128 char) default sys_context('USERENV','TERMINAL')       not null
    ,old_text       clob
    );

alter table hmx_ddl_log_data
    annotations
        (add if not exists hmx_object_usage    'Herman Mol Extras - DDL Logging (Oracle 19+).'
        ,add if not exists hmx_object_notes    'Logging changes in the schema DDL.'
        ,add if not exists hmx_developer_notes 'See HMX General Developer Notes. The schema trigger HMX_DDL_LOGGING must be disabled to modify this table.'
        ,add if not exists hmx_object_version  '2026-10-29 12:02:48 +01:00'
        ,add if not exists hmx_db_version      'Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0'
        ,add if not exists hmx_object_repo     'git@github.com:HermanMol/FJ12a_HMX-dev.git'
        )
/
alter table hmx_ddl_log_data
modify
    (act_sysdate    annotations (add if not exists hmx_column_usage 'The SYSTIMESTAMP with DB time zone.')
    ,object_owner   annotations (add if not exists hmx_column_usage 'The owner of the object.')
    ,object_name    annotations (add if not exists hmx_column_usage 'The object name of the object, like in ALL_OBJECTS.')
    ,object_type    annotations (add if not exists hmx_column_usage 'The object type of the object, like in ALL_OBJECTS.')
    ,operation      annotations (add if not exists hmx_column_usage 'The operation: CREATE, DROP, ALTER ...')
    ,act_user       annotations (add if not exists hmx_column_usage 'The USER value.')
    ,act_server     annotations (add if not exists hmx_column_usage 'The value of sys_context("USERENV","SERVER_HOST")')
    ,act_dbname     annotations (add if not exists hmx_column_usage 'The value of sys_context("USERENV","DB_NAME")')
    ,act_schema     annotations (add if not exists hmx_column_usage 'The value of sys_context("USERENV","CURRENT_SCHEMA")')
    ,act_dbuser     annotations (add if not exists hmx_column_usage 'The value of sys_context("USERENV","SESSION_USER")')
    ,act_osuser     annotations (add if not exists hmx_column_usage 'The value of sys_context("USERENV","OS_USER")')
    ,act_host       annotations (add if not exists hmx_column_usage 'The value of sys_context("USERENV","USERENV","HOST")')
    ,act_ip_address annotations (add if not exists hmx_column_usage 'The value of sys_context("USERENV","USERENV","IP_ADDRESS")')
    ,act_module     annotations (add if not exists hmx_column_usage 'The value of sys_context("USERENV","USERENV","MODULE")')
    ,act_terminal   annotations (add if not exists hmx_column_usage 'The value of sys_context("USERENV","USERENV","TERMINAL")')
    ,old_text       annotations (add if not exists hmx_column_usage 'The old source text.')
    );
/
prompt *I: ScriptEOF hmx_ddl_log_data.sql
