/* <hmx-annotations>


.HMX_OBJECT_USAGE: This package/script...

.HMX_OBJECT_NOTES:
    ?Package must be invoker rights (AUTHID CURRENT_USER)
    ...

.HMX_DEVELOPER_NOTES: See HMX General Developer Notes
.HMX_OBJECT_VERSION: 2026-10-22 10:58:08 +02:00
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */
prompt *I: ScriptBOF pkb_hmx_log_core.sql
create or replace package body hmx_log_core
as
-- package must be AUTHID DEFINER
-- =================================================================================================
-- Project: e-CertNL
-- Purpose: e-CertNL Database Logger - shielded core functionality
-- Origin:
-- 20231027 hmol USEC-2675 e-CertNL DB Logging e.a. (gebaseerd op eerder werk van hmol elders)
-- =================================================================================================

/*                                        DEVELOPER NOTES
* * Naming convention used:
*   - the b[c|v|p|f|t]_ prefix stands for private Body [Constant|Variable|Procedure|Function|Type]
*   - when the name does not start with a b[c|v|p|f|t]_ prefix it can be assumed to be public
*     available (in the spec)
*   - method parameter prefixes: pi_* /po_* /pio_* resp. for IN / OUT / IN OUT parameters
*   - local variable, function or procedure prefixes: l_* / lf_* / lp_*
*/

K_PACKAGENAAM CONSTANT VARCHAR2(50) := 'hmx_log_CORE#1';
  bc_body_version       constant varchar2(9)  := '20231112a';

  -- ---------------------------------------------------------------------------------------------
  -- Public function returning all version information regarding this package
  function get_version_info
  return varchar2
  deterministic
  as
  begin
    return 'Package ' || $$plsql_unit || ' version: '
      || 'Spec='    || c_spec_version
      || '; Body='  || bc_body_version
      ;
  end get_version_info;

  -- ---------------------------------------------------------------------------------------------
  -- public function performing the actual insert AUTONOMOUS_TRANSACTION
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
      ,log_tags            -- varchar2(200 char)
      ,log_org_owner       -- varchar2(128 char)
      ,log_org_object      -- varchar2(128 char)
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
      (p_hmx_log_rec.log_msg
      ,p_hmx_log_rec.log_time
      ,p_hmx_log_rec.log_type
      ,p_hmx_log_rec.log_level
      ,p_hmx_log_rec.log_scope
      ,p_hmx_log_rec.log_tags
      ,p_hmx_log_rec.log_org_owner
      ,p_hmx_log_rec.log_org_object
      ,p_hmx_log_rec.log_org_method
      ,p_hmx_log_rec.log_org_line
      ,p_hmx_log_rec.log_call_depth
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
      ,p_hmx_log_rec.log_app_user
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
prompt *I: ScriptEOF pkb_hmx_log_core.sql
