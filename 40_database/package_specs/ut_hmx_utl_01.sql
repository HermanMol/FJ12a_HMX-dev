create or replace package ut_hmx_utl_01 as
/* <hmx-annotations>

.HMX_OBJECT_USAGE: Unit Test HMX_UTL

.HMX_OBJECT_NOTES:
    Created manualy, first try at utPLSQL, simple, as proof of concept

.HMX_DEVELOPER_NOTES:
    - See HMX General Developer Notes

.HMX_OBJECT_VERSION: 2026-11-12 07:59:30 +01:00
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */

    --%suite(Testing package HMX_UTL)
    -- f_max_chars = Return a maximum string length

    --%test(0001: return 5 characters, last 3 are ellipsis.)
    procedure test_0001;

    --%test(0002: return all 9 characters.)
    procedure test_0002;

    --%test(0003: return last 6 charactersfirst 3 are ellipsis.)
    procedure test_0003;

end ut_hmx_utl_01;
