prompt *I: ScriptBOF hmx_types.sql
create or replace package hmx_types
as
/* <hmx-annotations>

.HMX_OBJECT_USAGE: Types and subtypes not related to a specific domain/package

.HMX_OBJECT_NOTES: More complex types (Advanced Data Types - ADT's)

.HMX_DEVELOPER_NOTES:
    See HMX General Developer Notes
    No package body

.HMX_OBJECT_VERSION: 2026-11-04 10:24:22 +01:00
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */

    subtype t_vchar30   is varchar2(30);    -- e.g. DBMS_SESSION LIST_CONTEXT namespace and attribute
    subtype t_vchar128  is varchar2(128);   -- e.g. DBMS_SESSION SET_CONTEXT namespace
    subtype t_vchar4000 is varchar2(4000);
    subtype t_vcharmax  is varchar2(32767);

    subtype t_string_type   is t_vcharmax;
    type    t_strings_type  is table of t_string_type;

    subtype t_bool          is pls_integer range 0..1;  -- 0=false, 1=true
    subtype t_y_n_e         is pls_integer range -1..1; -- -1=error, 0=no, 1=yes

end hmx_types;
/
prompt *I: ScriptEOF hmx_types.sql
