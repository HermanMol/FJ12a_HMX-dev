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
prompt *I: ScriptBOF pks_hmx_log_core.sql
create or replace package hmx_log_core
AUTHID DEFINER
ACCESSIBLE BY (hmx_log)
as
-- package must be AUTHID DEFINER
-- package can only be accessed thru package hmx_log
-- =================================================================================================
-- Project: e-CertNL
-- Purpose: e-CertNL Database Logger - shielded core functionality
-- =================================================================================================

/* Wijzigingshistorie
|  versie   datum           auteur             reden
|  1        27-10-2023      HMO                USEC-5926 eDBLog sources Herman installeren
*/

/*                                        DEVELOPER NOTES
* * Naming convention used:
*   - the b[c|v|p|f|t]_ prefix stands for private Body [Constant|Variable|Procedure|Function|Type]
*   - when the name does not start with a b[c|v|p|f|t]_ prefix it can be assumed to be public
*     available (in the spec)
*   - method parameter prefixes: pi_* /po_* /pio_* resp. for IN / OUT / IN OUT parameters
*   - local variable, function or procedure prefixes: l_* / lf_* / lp_*
*/

  c_spec_version        constant varchar2(9)  := '20231112a';

  -- =============================================================================================
  -- Function that returns all version information regarding this package spec and body
  function get_version_info
  return varchar2
  deterministic;

  -- ---------------------------------------------------------------------------------------------
  -- public function performing the actual insert AUTONOMOUS_TRANSACTION
  function insert_hmx_log_data
    (p_hmx_log_rec in hmx_log_data%rowtype)
  return number;

end hmx_log_core;
/
prompt *I: ScriptEOF pks_hmx_log_core.sql
