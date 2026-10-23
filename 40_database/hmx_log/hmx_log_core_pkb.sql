prompt *I: ScriptBOF hmx_log_core_pkb.sql
create or replace package body hmx_log_core
as
/* <hmx-annotations>

.HMX_OBJECT_USAGE: This package should be the only place where the actual insert of HMX_LOG_DATA occurs.

.HMX_OBJECT_NOTES:
    Package must be DEFINER rights (AUTHID DEFINER)

.HMX_DEVELOPER_NOTES: 
    See HMX General Developer Notes
    Package is only accessible by package HMO_LOG.
    Function is AUTONOMOUS TRANSACTION.

.HMX_OBJECT_VERSION: 2026-10-23 10:34:47 +02:00
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */

  -- ---------------------------------------------------------------------------------------------
  -- Public function performing the actual insert AUTONOMOUS_TRANSACTION
  function insert_hmx_log_data
    (p_hmx_log_rec in hmx_log_data%rowtype)
  return number
  is
    pragma autonomous_transaction;
    l_log_pkid number;
  begin
    insert into hmx_log_data
      (log_msg             -- varchar2(4000 char)
      ,log_time            -- timestamp(9) with time zone  default systimestamp at time zone 'UTC' not null
      ,log_type            -- varchar2(8 char)
      ,log_level           -- number(3,0)
      ,log_scope           -- varchar2(10 char)
--      ,log_tags            -- varchar2(200 char)  -- TODO
      ,log_org_owner       -- varchar2(128 char)
      ,log_org_object      -- varchar2(128 char)
      ,log_org_method      -- varchar2(128 char)
      ,log_org_line        -- number(7,0)
--      ,log_call_depth      -- number(5,0)         -- TODO
      ,log_process         -- varchar2(100 char)
      ,log_sqlerrm         -- varchar2(512 char)
      ,log_sqlcode         -- number
      ,log_call_stack      -- varchar2(4000 char)
      ,log_error_backtrace -- varchar2(4000 char)
      ,log_sesid           -- varchar2(32 char)
      ,log_server          -- varchar2(30 char)
      ,log_dbname          -- varchar2(30 char)
      ,log_dbschema        -- varchar2(30 char)
      ,log_dbuser          -- varchar2(30 char)
      ,log_osuser          -- varchar2(30 char)
--      ,log_app_user        -- varchar2(128 char)  -- TODO
      )
    values
      (p_hmx_log_rec.log_msg
      ,p_hmx_log_rec.log_time
      ,p_hmx_log_rec.log_type
      ,p_hmx_log_rec.log_level
      ,p_hmx_log_rec.log_scope
--      ,p_hmx_log_rec.log_tags     -- TODO
      ,p_hmx_log_rec.log_org_owner
      ,p_hmx_log_rec.log_org_object
      ,p_hmx_log_rec.log_org_method
      ,p_hmx_log_rec.log_org_line
--      ,p_hmx_log_rec.log_call_depth   -- TODO
      ,p_hmx_log_rec.log_process
      ,p_hmx_log_rec.log_sqlerrm
      ,p_hmx_log_rec.log_sqlcode
      ,p_hmx_log_rec.log_call_stack
      ,p_hmx_log_rec.log_error_backtrace
      ,p_hmx_log_rec.log_sesid
      ,p_hmx_log_rec.log_server
      ,p_hmx_log_rec.log_dbname
      ,p_hmx_log_rec.log_dbschema
      ,p_hmx_log_rec.log_dbuser
      ,p_hmx_log_rec.log_osuser
--      ,p_hmx_log_rec.log_app_user     -- TODO
      )
    return log_pkid into l_log_pkid;

    commit write wait batch;

    return l_log_pkid;
  end insert_hmx_log_data;

-- -------------------------------------------------------------------------------------------------
-- package constructor
begin
  null;

end hmx_log_core;
/
prompt *I: ScriptEOF hmx_log_core_pkb.sql
