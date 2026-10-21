prompt *I: ScriptBOF hmx_pkg_name_pks.sql
create or replace package hmx_pkg_name
AUTHID CURRENT_USER
as
/* <hmx-annotations>

  *TIP: Generate this block with tool HMX_GENERATE_ANNOTATION_BLOCK.SQL
  *TIP: Generate HMX_DB_VERSION line with tool HMX_GENERATE_ANNOTATION_VERSION_LINE.SQL

.HMX_OBJECT_USAGE: This package/script...

.HMX_OBJECT_NOTES:
    ?Package must be invoker rights (AUTHID CURRENT_USER)
    ...

.HMX_DEVELOPER_NOTES: See HMX General Developer Notes
.HMX_OBJECT_VERSION: 2026-10-21 12:17:12 CEST
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */

    -- ---------------------------------------------------------------------------------------------
    -- Public ...
    function ...
    return ...
    ...deterministic;

end hmx_pkg_name;
/

prompt *I: ScriptEOF hmx_pkg_name_pks.sql
