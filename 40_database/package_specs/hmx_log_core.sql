prompt *I: ScriptBOF pks_hmx_log_core.sql
create or replace package hmx_log_core
AUTHID DEFINER
ACCESSIBLE BY (hmx_log)
as
/* <hmx-annotations>

.HMX_OBJECT_USAGE: This package should be the only place where the actual insert of HMX_LOG_DATA occurs.

.HMX_OBJECT_NOTES:
    Package must be DEFINER rights (AUTHID DEFINER)

.HMX_DEVELOPER_NOTES: 
    See HMX General Developer Notes
    Package is only accessible by package HMO_LOG.
    Function is AUTONOMOUS TRANSACTION.

.HMX_OBJECT_VERSION: 2026-11-06 15:23:03 +01:00
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */

    -- ---------------------------------------------------------------------------------------------
    -- public function performing the actual insert AUTONOMOUS_TRANSACTION
    function insert_hmx_log_data
        (pi_hmx_log_rec in hmx_log_data%rowtype
        )
    return number;

end hmx_log_core;
/
prompt *I: ScriptEOF pks_hmx_log_core.sql
