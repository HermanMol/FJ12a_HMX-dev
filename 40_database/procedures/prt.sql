prompt *I: ScriptBOF prt.sql

create or replace procedure prt(i_line in varchar2 := null)
as
begin
    -- Just a simple efficient alias for the lengthy original
    dbms_output.put_line(i_line);
end prt;
/
prompt *I: ScriptEOF prt.sql
