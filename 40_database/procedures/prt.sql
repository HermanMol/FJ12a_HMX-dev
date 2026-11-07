prompt *I: ScriptBOF prt.sql

create or replace procedure prt
    (i_line in varchar2 := null
    )
as
/* <hmx-annotations>

.HMX_OBJECT_USAGE: Just a simple efficient alias for the lengthy original

.HMX_OBJECT_NOTES: -

.HMX_DEVELOPER_NOTES: See HMX General Developer Notes
.HMX_OBJECT_VERSION: 2026-11-06 16:15:31 +01:00
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */
begin
    dbms_output.put_line(i_line);
end prt;
/
prompt *I: ScriptEOF prt.sql
