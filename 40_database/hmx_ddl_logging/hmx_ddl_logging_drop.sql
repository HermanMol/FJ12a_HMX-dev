prompt *I: ScriptBOF hmx_ddl_logging_drop.sql
set serverout on size unlimited
set linesize 32767
set pagesize 50000
set trimout on
set trimspool on

prompt *I: Report objects like HMX_DDL*
select owner
	,object_name
	,object_type
	,to_char(created,'dd-mm-yyyy hh24:mi:ss') as createdx
	,to_char(last_ddl_time,'dd-mm-yyyy hh24:mi:ss') as last_ddl_timex
	,status
from all_objects
where object_name like 'HMX_DDL%'
order by owner
	,object_name
	,object_type;

prompt *I: Drop HMX_DDL objects
drop trigger if exists hmx_ddl_logging;
drop table   if exists hmx_ddl_log_data cascade constraints purge;

prompt *I: Report objects like HMX_DDL*
select owner
	,object_name
	,object_type
	,to_char(created,'dd-mm-yyyy hh24:mi:ss') as createdx
	,to_char(last_ddl_time,'dd-mm-yyyy hh24:mi:ss') as last_ddl_timex
	,status
from all_objects
where object_name like 'HMX_DDL%'
order by owner
	,object_name
	,object_type;

prompt *I: ScriptEOF hmx_ddl_logging_drop.sql
