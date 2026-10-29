prompt *I: ScriptBOF hmx_ddl_logging_trg.sql
create or replace trigger hmx_ddl_logging
after create or alter or drop
on schema
/* <hmx-annotations>

.HMX_OBJECT_USAGE: Special DDL SCHEMA TRIGGER to log changes in schema DDL

.HMX_OBJECT_NOTES: This trigger must be disabled before changing this trigger or the HMX_DDL_LOG_DATA table.

.HMX_DEVELOPER_NOTES: See HMX General Developer Notes
.HMX_OBJECT_VERSION: 2026-10-29 11:58:51 +01:00
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */
begin
    -- Log DDL activities abd the old source
    insert into hmx_ddl_log_data
        (object_owner
        ,object_name
        ,object_type
        ,operation
        ,old_text
        )
    values
        (nvl(ora_dict_obj_owner,'Unknown')
        ,nvl(ora_dict_obj_name,'Unknown')
        ,nvl(ora_dict_obj_type,'Unknown')
        ,nvl(ora_sysevent,'Unknown')
        ,dbms_metadata.get_ddl 
            (decode(ora_dict_obj_type
                   ,'JOB'          ,'PROCOBJ'
                   ,'DATABASE LINK','DB_LINK'
                   ,'PACKAGE'      ,'PACKAGE_SPEC'
                   ,'PACKAGE BODY' ,'PACKAGE_BODY'
                   ,'TYPE'         ,'TYPE_SPEC'
                   ,'TYPE BODY'    ,'TYPE_BODY'
                   ,ora_dict_obj_type
                   )
            , ora_dict_obj_name
            , ora_dict_obj_owner
            )
        );
end hmx_ddl_logging;
/
show errors

alter trigger hmx_ddl_logging disable;

prompt *A: Please note that the trigger is created DISABLED

prompt *I: ScriptEOF hmx_ddl_logging_trg.sql
