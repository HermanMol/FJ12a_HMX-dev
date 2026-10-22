prompt *I: ScriptBOF hmx_sys_context_userenv_svw.sql
create or replace force view hmx_sys_context_userenv
    (INFO_ITEM  annotations (add hmx_column_usage 'The USERENV context item to show the value of.')
    ,INFO_VALUE annotations (add hmx_column_usage 'The USERENV context item value.')
    ,SQL_CMD    annotations (add hmx_column_usage 'The ready-to-copy statement to get that USERENV item value.')
    )
    annotations
        (add hmx_object_usage    'This view shows USERENV values, showing <Unknown> when the info_item does not exist.'
        ,add hmx_object_notes    'Values are retrieved using HMX_SESSION.GET_SYS_CONTEXT thus avoiding an exception when an info_item does not exist.'
        ,add hmx_developer_notes 'See HMX General Developer Notes'
        ,add hmx_object_version  '2026-10-22 10:01:54 +02:00'
        ,add hmx_db_version      'Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0'
        ,add hmx_object_repo     'git@github.com:HermanMol/FJ12a_HMX-dev.git'
        )
as
with ctx_items as
    (         select 'ACTION'                             as info_item from dual
    union all select 'IS_APPLICATION_ROOT'                as info_item from dual
    union all select 'IS_APPLICATION_PDB'                 as info_item from dual
    union all select 'AUDITED_CURSORID'                   as info_item from dual
    union all select 'AUTHENTICATED_IDENTITY'             as info_item from dual
    union all select 'AUTHENTICATION_DATA'                as info_item from dual
    union all select 'AUTHENTICATION_METHOD'              as info_item from dual
    union all select 'BG_JOB_ID'                          as info_item from dual
    union all select 'CDB_DOMAIN'                         as info_item from dual
    union all select 'CDB_NAME'                           as info_item from dual
    union all select 'CLIENT_IDENTIFIER'                  as info_item from dual
    union all select 'CLIENT_INFO'                        as info_item from dual
    union all select 'CLIENT_PROGRAM_NAME'                as info_item from dual
    union all select 'CON_ID'                             as info_item from dual
    union all select 'CON_NAME'                           as info_item from dual
    union all select 'CURRENT_BIND'                       as info_item from dual
    union all select 'CURRENT_EDITION_ID'                 as info_item from dual
    union all select 'CURRENT_EDITION_NAME'               as info_item from dual
    union all select 'CURRENT_SCHEMA'                     as info_item from dual
    union all select 'CURRENT_SCHEMAID'                   as info_item from dual
    union all select 'CURRENT_SQL'                        as info_item from dual
    union all select 'CURRENT_SQLn'                       as info_item from dual
    union all select 'CURRENT_SQL_LENGTH'                 as info_item from dual
    union all select 'CURRENT_USER'                       as info_item from dual
    union all select 'CURRENT_USERID'                     as info_item from dual
    union all select 'DATABASE_ROLE'                      as info_item from dual
    union all select 'DB_DOMAIN'                          as info_item from dual
    union all select 'DB_NAME'                            as info_item from dual
    union all select 'DB_SUPPLEMENTAL_LOG_LEVEL'          as info_item from dual
    union all select 'DB_UNIQUE_NAME'                     as info_item from dual
    union all select 'DBLINK_INFO'                        as info_item from dual
    union all select 'DRAIN_STATUS'                       as info_item from dual
    union all select 'ENTRYID'                            as info_item from dual
    union all select 'ENTERPRISE_IDENTITY'                as info_item from dual
    union all select 'FG_JOB_ID'                          as info_item from dual
    union all select 'GLOBAL_CONTEXT_MEMORY'              as info_item from dual
    union all select 'GLOBAL_UID'                         as info_item from dual
    union all select 'HOST'                               as info_item from dual
    union all select 'IDENTIFICATION_TYPE'                as info_item from dual
    union all select 'INSTANCE'                           as info_item from dual
    union all select 'INSTANCE_NAME'                      as info_item from dual
    union all select 'IP_ADDRESS'                         as info_item from dual
    union all select 'IS_APPLY_SERVER'                    as info_item from dual
    union all select 'IS_DG_ROLLING_UPGRADE'              as info_item from dual
    union all select 'ISDBA'                              as info_item from dual
    union all select 'LANG'                               as info_item from dual
    union all select 'LANGUAGE'                           as info_item from dual
    union all select 'LDAP_SERVER_TYPE'                   as info_item from dual
    union all select 'MODULE'                             as info_item from dual
    union all select 'MULTIFACTOR_AUTHENTICATION_METHODS' as info_item from dual
    union all select 'NETWORK_PROTOCOL'                   as info_item from dual
    union all select 'NLS_CALENDAR'                       as info_item from dual
    union all select 'NLS_CURRENCY'                       as info_item from dual
    union all select 'NLS_DATE_FORMAT'                    as info_item from dual
    union all select 'NLS_DATE_LANGUAGE'                  as info_item from dual
    union all select 'NLS_SORT'                           as info_item from dual
    union all select 'NLS_TERRITORY'                      as info_item from dual
    union all select 'ORACLE_HOME'                        as info_item from dual
    union all select 'OS_USER'                            as info_item from dual
    union all select 'PLATFORM_SLASH'                     as info_item from dual
    union all select 'POLICY_INVOKER'                     as info_item from dual
    union all select 'PROXY_ENTERPRISE_IDENTITY'          as info_item from dual
    union all select 'PROXY_USER'                         as info_item from dual
    union all select 'PROXY_USERID'                       as info_item from dual
    union all select 'SCHEDULER_JOB'                      as info_item from dual
    union all select 'SERVER_HOST'                        as info_item from dual
    union all select 'SERVICE_NAME'                       as info_item from dual
    union all select 'SESSION_DEFAULT_COLLATION'          as info_item from dual
    union all select 'SESSION_EDITION_ID'                 as info_item from dual
    union all select 'SESSION_EDITION_NAME'               as info_item from dual
    union all select 'SESSION_USER'                       as info_item from dual
    union all select 'SESSION_USERID'                     as info_item from dual
    union all select 'SESSIONID'                          as info_item from dual
    union all select 'SID'                                as info_item from dual
    union all select 'STATEMENTID'                        as info_item from dual
    union all select 'TERMINAL'                           as info_item from dual
    union all select 'UNIFIED_AUDIT_SESSIONID'            as info_item from dual
    )
,ctx_values as
    (   select info_item                                                      as info_item
              ,hmx_session.get_sys_context('USERENV', info_item,'<Unknown>')  as info_value
        from ctx_items
    )
select info_item
    ,info_value
    ,case when info_value = '<Unknown>'
        then '-- '
        else null
     end || 'sys_context(''USERENV'',''' || info_item || ''')'                as sql_cmd
from ctx_values
;
comment on table  hmx_sys_context_userenv            is 'Showing all SYS_CONTEXT(userenv) values. Causes no exception when an unknown into_item is requested.';
comment on column hmx_sys_context_userenv.info_item  is 'The USERENV context attribute to be reported.';
comment on column hmx_sys_context_userenv.info_value is 'The USERENV context attribute value.';
comment on column hmx_sys_context_userenv.sql_cmd    is 'The SYS_CONTEXT(userenv...) statement.';
prompt *I: ScriptEOF hmx_sys_context_userenv_svw.sql
