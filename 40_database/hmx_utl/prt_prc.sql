prompt *I: ScriptBOF prt_prc.sql

create or replace procedure prt(i_line in varchar2)
as
begin
    -- Just a simple efficient alias for the lengthy original
    dbms_output.put_line(i_line);
end prt;
/
prompt *I: ScriptEOF prt_prc.sql
 