prompt *I: ScriptBOF hmx_log_core.sql
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

.HMX_OBJECT_VERSION: 2026-10-24 16:40:56 +02:00
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */

  -- ---------------------------------------------------------------------------------------------
  -- Public function performing the actual insert AUTONOMOUS_TRANSACTION
  function insert_hmx_log_data
    (pi_hmx_log_rec in hmx_log_data%rowtype)
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
      ,log_tags            -- varchar2(200 char)
      ,log_org_owner       -- varchar2(128 char)
      ,log_org_object      -- varchar2(128 char)
      ,log_org_type        -- varchar2(128 char)
      ,log_org_method      -- varchar2(128 char)
      ,log_org_line        -- number(7,0)
      ,log_call_depth      -- number(5,0)
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
      ,log_app_user        -- varchar2(128 char)
      )
    values
      (pi_hmx_log_rec.log_msg
      ,pi_hmx_log_rec.log_time
      ,pi_hmx_log_rec.log_type
      ,pi_hmx_log_rec.log_level
      ,pi_hmx_log_rec.log_scope
      ,pi_hmx_log_rec.log_tags
      ,pi_hmx_log_rec.log_org_owner
      ,pi_hmx_log_rec.log_org_object
      ,pi_hmx_log_rec.log_org_type
      ,pi_hmx_log_rec.log_org_method
      ,pi_hmx_log_rec.log_org_line
      ,pi_hmx_log_rec.log_call_depth
      ,pi_hmx_log_rec.log_process
      ,pi_hmx_log_rec.log_sqlerrm
      ,pi_hmx_log_rec.log_sqlcode
      ,pi_hmx_log_rec.log_call_stack
      ,pi_hmx_log_rec.log_error_backtrace
      ,pi_hmx_log_rec.log_sesid
      ,pi_hmx_log_rec.log_server
      ,pi_hmx_log_rec.log_dbname
      ,pi_hmx_log_rec.log_dbschema
      ,pi_hmx_log_rec.log_dbuser
      ,pi_hmx_log_rec.log_osuser
      ,pi_hmx_log_rec.log_app_user
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
prompt *I: ScriptEOF hmx_log_core.sql
