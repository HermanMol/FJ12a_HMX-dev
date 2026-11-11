create or replace package hmx_utplsql_utl
AUTHID CURRENT_USER
as

/* <hmx-annotations>

.HMX_OBJECT_USAGE: Utilities to support utPLSQL

.HMX_OBJECT_NOTES:
    - This package requires invoker rights (AUTHID CURRENT_USER)
    - For utPLSQL version v.3.2.3
    - Execute this package in the CURRENT_SCHEMA of the package to test

.HMX_DEVELOPER_NOTES: See HMX General Developer Notes
.HMX_OBJECT_VERSION: 2026-11-11 17:48:33 +01:00
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */


    -- ---------------------------------------------------------------------------------------------
    -- Public procedure to set the package to test
    procedure set_package_to_test
        (pi_package_name    in varchar2
        );

    -- ---------------------------------------------------------------------------------------------
    -- Public function to set the package to test
    function get_package_to_test
    return varchar2;

    -- ---------------------------------------------------------------------------------------------
    -- Public function returning a utPLSQL valid suite annotation description
    function get_suite
        (pi_suite   in varchar2 := null)
    return varchar2
    deterministic;

    -- ---------------------------------------------------------------------------------------------
    -- Public function returning a full utPLSQL valid suitepath annotation.
    -- If argument pi_suitpath is empty, no suitepath annotation is returned.
    function get_suitepath_annotation
        (pi_suitepath   in varchar2 := null)
    return varchar2
    deterministic;

    -- ---------------------------------------------------------------------------------------------
    -- Public function returning a full utPLSQL valid context annotation.
    -- If argument pi_context is empty, no context annotation is returned.
    function get_context_annotation
        (pi_context   in varchar2 := null)
    return varchar2
    deterministic;

    -- ---------------------------------------------------------------------------------------------
    -- Public procedure to set the tags
    procedure set_tags
        (pi_tags    in varchar2
        );

    -- ---------------------------------------------------------------------------------------------
    -- Public function returning the current utPLSQL tags.
    function get_tags
    return varchar2;

    -- ---------------------------------------------------------------------------------------------
    -- Generate the base utPLSQL test package spec in DBMS_OUTPUT for a given package.
    -- The generated code must be reviewed:
    -- - Search for question marks where non-obvious data types are used
    -- - ... more ...?
    procedure generate_test_package_spec
        (pi_package_name in varchar2
        ,pi_suite           in varchar2 := 'Suite?'
        ,pi_suitepath       in varchar2 := 'SuitePath?'
        ,pi_context         in varchar2 := 'Context?'
        );

    -- ---------------------------------------------------------------------------------------------
    -- Generate the base utPLSQL test package body in DBMS_OUTPUT for a given package.
    -- ATTENTION! The generated code must be reviewed:
    -- - Search for question marks where non-obvious data types are used
    -- - ... more ...?
    procedure generate_test_package_body
        (pi_package_name in varchar2
        ,pi_suite           in varchar2 := 'Suite?'
        ,pi_suitepath       in varchar2 := 'SuitePath?'
        ,pi_context         in varchar2 := 'Context?'
        );

    -- ---------------------------------------------------------------------------------------------
    -- Generate the base utPLSQL test package spec and body in DBMS_OUTPUT for a given package.
    -- ATTENTION! The generated code must be reviewed:
    -- - Search for question marks where non-obvious data types are used
    -- - ... more ...?
    procedure generate_test_package
        (pi_package_name in varchar2
        ,pi_suite           in varchar2 := 'Suite?'
        ,pi_suitepath       in varchar2 := 'SuitePath?'
        ,pi_context         in varchar2 := 'Context?'
        );

end hmx_utplsql_utl;
/
