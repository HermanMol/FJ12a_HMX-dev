prompt *I: ScriptBOF hmx_log_data_seq.sql
-- 2026-10-22 12:12:02 HMOL New
drop sequence if exists hmx_log_data_seq
/
create sequence hmx_log_data_seq 
increment by 1 
start with 1000 
minvalue 1000 
nocache 
order
/
prompt *I: ScriptEOF hmx_log_data_seq.sql
