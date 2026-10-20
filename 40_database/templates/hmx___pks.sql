prompt *I: ScriptBOF hmx_pkg_name_pks.sql
create or replace package hmx_pkg_name
AUTHID CURRENT_USER
as
/* <hmx-annotations>

.HMX_OBJECT_VERSION 2026-10-20 09:33:58 CEST
--> hmx_version_line_generator.sql

.HMX_OBJECT_REPO git@github.com:HermanMol/FJ12a_HMX-dev.git

.HMX_OBJECT_USAGE
    This package is a wrapper to manage database annotations.

.HMX_DB_VERSION Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0

.HMX_OBJECT_NOTES
    - Package must be invoker rights (AUTHID CURRENT_USER)
    - ...

.HMX_DEVELOPER_NOTES
    - See HMX General Developer Notes

** </hmx-annotations> */

    -- ---------------------------------------------------------------------------------------------
    -- Public ...
    function ...
    return ...
    ...deterministic;

end hmx_pkg_name;
/

prompt *I: ScriptEOF hmx_pkg_name_pks.sql
