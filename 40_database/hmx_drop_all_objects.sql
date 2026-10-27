prompt *I: ScriptBOF hmx_drop_all_objects.sql
/*
-- Generate the statements with this
select 'drop ' || lower(object_type) || ' ' || lower(object_name) 
	|| case object_type 
		when 'TABLE' then ' cascade constraints purge;'
		else ';'
		end as drop_statements
from user_objects
where object_name like 'HMX^_%' escape '^'	-- namespace
and object_type in ('SEQUENCE','PACKAGE','TABLE','PROCEDURE','FUNCTION','VIEW')
order by case object_type
		when 'TABLE' then 5
		when 'PACKAGE' then 2
		when 'PROCEDURE' then 3
		when 'FUNCTION' then 4
		when 'VIEW' then 1
		when 'SEQUENCE'then 9
		else 0
		end
	,object_name
/
*/
@hmx_spoolstart hmx_drop_all_objects.sql
drop view      if exists hmx_all_annotations;
drop view      if exists hmx_all_object_versions;
drop view      if exists hmx_sys_context_userenv;
drop package   if exists hmx_annotations;
drop package   if exists hmx_call_stack;
drop package   if exists hmx_call_stack_tests;
drop package   if exists hmx_log;
drop package   if exists hmx_log_core;
drop package   if exists hmx_session;
drop package   if exists hmx_types;
drop package   if exists hmx_utl;
drop procedure if exists hmx_test_log_module;
drop procedure if exists prt;
drop table     if exists hmx_log_data cascade constraints purge;
drop sequence  if exists hmx_log_data_seq;
drop type      if exists string_stack_type;
drop type      if exists t_string_varray50;
@hmx_spoolfinish

prompt *I: ScriptEOF hmx_drop_all_objects.sql
