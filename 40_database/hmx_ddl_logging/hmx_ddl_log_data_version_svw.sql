prompt *I: ScriptBOF hmx_ddl_log_data_version_svw.sql

--@H:\20_projects\FJ12a_HMX-dev\10_wrk\40_database\hmx_ddl_logging\hmx_ddl_trigger_disable.sql

create or replace force view hmx_ddl_log_data_version
    (act_sysdate    annotations (add if not exists hmx_column_usage 'The SYSTIMESTAMP with DB time zone.')
    ,object_owner   annotations (add if not exists hmx_column_usage 'The owner of the object.')
    ,object_name    annotations (add if not exists hmx_column_usage 'The object name of the object, like in ALL_OBJECTS.')
    ,object_type    annotations (add if not exists hmx_column_usage 'The object type of the object, like in ALL_OBJECTS.')
    ,object_version annotations (add if not exists hmx_column_usage 'The HMX-annotation version of this object.')
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
    )
    annotations
        (add if not exists hmx_object_usage    'This view shows DDL logged data including the HMX-annotation HMX_OBJECT_VERSION.'
        ,add if not exists hmx_object_notes    'DDL create/alter/drop of objects.'
        ,add if not exists hmx_developer_notes 'See HMX General Developer Notes'
        ,add if not exists hmx_object_version  '2026-10-29 12:45:48 +01:00'
        ,add if not exists hmx_db_version      'Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0'
        ,add if not exists hmx_object_repo     'git@github.com:HermanMol/FJ12a_HMX-dev.git'
        )
as
select act_sysdate
    , object_owner
    , object_name
    , object_type
    , regexp_substr(old_text, '^\.HMX_OBJECT_VERSION: ([[:print:]]*)$',1,1,'im',1) as object_version
    , operation
    , act_user
    , act_server
    , act_dbname
    , act_schema
    , act_dbuser
    , act_osuser
    , act_host
    , act_ip_address
    , act_module
    , act_terminal
    , old_text
from hmx_ddl_log_data
order by act_sysdate
;

-- @H:\20_projects\FJ12a_HMX-dev\10_wrk\40_database\hmx_ddl_logging\hmx_ddl_trigger_enable.sql

prompt *I: ScriptEOF hmx_ddl_log_data_version_svw.sql
