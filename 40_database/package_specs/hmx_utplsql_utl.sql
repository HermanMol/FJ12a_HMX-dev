create or replace package hmx_utplsql_utl
as

/* <hmx-annotations>

.HMX_OBJECT_USAGE: Utilities to support utPLSQL

.HMX_OBJECT_NOTES:
    - For utPLSQL version v.3.2.3

.HMX_DEVELOPER_NOTES: See HMX General Developer Notes
.HMX_OBJECT_VERSION: 2026-11-10 17:33:15 +01:00
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */

    -- ---------------------------------------------------------------------------------------------
    -- Generate the base utPLSQL test package spec in DBMS_OUTPUT for a given package.
    -- The generated code must be reviewed:
    -- - Search for question marks where non-obvious data types are used
    -- - ... more ...?
    procedure gen_test_package_spec
        (pi_package_name in varchar2
        );

end hmx_utplsql_utl;
/
