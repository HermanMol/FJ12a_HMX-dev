prompt *I: ScriptBOF hmx_drop_all_objects.sql
/*
-- Generate the statements with this
select 'drop ' || rpad(lower(object_type),10,' ')
    || ' if exists ' || lower(object_name) 
    || case object_type 
        when 'TABLE' then ' cascade constraints purge;'
        else ';'
       end              as drop_statements
from user_objects
where (  object_name like 'HMX^_%' escape '^'        -- namespace regular
      or object_name like 'UT^_HMX^_%' escape '^'    -- namespace unit tests
      or object_name = 'STRING_STACK_TYPE'
      or object_name = 'T_STRING_VARRAY50'
      or object_name = 'PRT'
      or object_type = 'OPERATOR'
      )
and object_type in ('SEQUENCE','PACKAGE','TABLE','PROCEDURE','FUNCTION','VIEW','TRIGGER','TYPE','OPERATOR')
order by case object_type
        when 'OPERATOR'  then 1
        when 'TRIGGER'   then 2
        when 'VIEW'      then 3
        when 'PACKAGE'   then 4
        when 'PROCEDURE' then 5
        when 'FUNCTION'  then 6
        when 'TABLE'     then 7
        when 'TYPE'      then 8
        when 'SEQUENCE'  then 9
        else 0
        end
    ,object_name
/
*/
@hmx_spoolstart hmx_drop_all_objects.sql
set feedback on
prompt *I: Disable the DDL trigger ...
alter trigger if exists hmx_ddl_logging disable;
prompt *I: Generated drop if objects ...
-- generated using above query at 2026-11-12 16:25:53 +01:00
drop operator   if exists is_equal;
drop operator   if exists to_num_val;
drop operator   if exists trimws;
drop trigger    if exists hmx_ddl_logging;
drop view       if exists hmx_all_annotations;
drop view       if exists hmx_all_object_versions;
drop view       if exists hmx_ddl_log_data_version;
drop view       if exists hmx_log_all_nice;
drop view       if exists hmx_log_with_object_version;
drop view       if exists hmx_sys_context_userenv;
drop view       if exists hmx_utplsql_suite_info;
drop package    if exists hmx_annotations;
drop package    if exists hmx_call_stack;
drop package    if exists hmx_call_stack_tests;
drop package    if exists hmx_log;
drop package    if exists hmx_log_core;
drop package    if exists hmx_session;
drop package    if exists hmx_types;
drop package    if exists hmx_utl;
drop package    if exists hmx_utplsql_utl;
drop package    if exists ut_hmx_annotations;
drop package    if exists ut_hmx_session;
drop package    if exists ut_hmx_utl;
drop procedure  if exists hmx_test_log_module;
drop procedure  if exists prt;
drop table      if exists hmx_ddl_log_data cascade constraints purge;
drop table      if exists hmx_log_data cascade constraints purge;
drop type       if exists string_stack_type;
drop type       if exists t_string_varray50;
drop sequence   if exists hmx_log_data_seq;
set feedback off
@hmx_spoolfinish
prompt Done.
