prompt *I: ScriptBOF hmx_annotations_pks.sql
create or replace package hmx_annotations
AUTHID CURRENT_USER
as

/* <hmx-annotations>

.HMX_OBJECT_USAGE: This package is a wrapper to manage database annotations.

.HMX_OBJECT_NOTES:
    - Package was initially developed with invoker rights (AUTHID CURRENT_USER)
    - Annotations supported in this package are tables, views, materialized views, and indexes.

.HMX_DEVELOPER_NOTES: See HMX General Developer Notes
.HMX_OBJECT_VERSION:2026-10-28 12:52:10 +01:00
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */

    type hmx_object_version_rec is record
        (object_owner   varchar2(128 char)
        ,object_name    varchar2(128 char)
        ,object_type    varchar2(128 char)
        ,object_version varchar2(26 char)
        );
    type hmx_object_version_arr is table of hmx_object_version_rec;

    -- Constant for the default HMX object version format
    k_hmx_object_version_format constant varchar2(29) := 'yyyy-mm-dd hh24:mi:ss TZH:TZM';
    -- Function returning the version format
    function fk_hmx_object_version_format return varchar2 deterministic;

    -- ---------------------------------------------------------------------------------------------
    -- Public function that converts an HMX_OBJECT_VERSION value from the expected format 
    -- to a UTC value. The expected format is defined in public package constant k_hmx_object_version_format.
    -- Optionally an alternative format can be specified which will be applied only if the
    -- default did not succeed.
    function hmx_version_to_utc
        (pi_hmx_version in varchar2
        ,pi_alt_format  in varchar2 := null
        )
    return varchar2
    deterministic;

    -- ---------------------------------------------------------------------------------------------
    -- Public function that checks if a certain Oracle Annotation exists. Input parameters are the
    -- attributes that uniquely identify an annotation.
    -- Returned:
    -- - hmx_utl.k_byes   if the annotation exists
    -- - hmx_utl.k_bno    if the annotation does not exist, but the related object/column exists
    -- - hmx_utl.k_berror if the annotation does not exist AND the related object/column does not exist.
    function check_annotation_exists
        (pi_object_name      in varchar2                    -- max length 128 , always required
        ,pi_object_type      in varchar2                    -- max length 9   , always required
        ,pi_column_name      in varchar2 := hmx_utl.k_none  -- max length 128 , optional, only for tables and views
        ,pi_domain_name      in varchar2 := hmx_utl.k_none  -- max length 128 , currently ignored in HMX
        ,pi_domain_owner     in varchar2 := hmx_utl.k_none  -- max length 128 , currently ignored in HMX
        ,pi_annotation_owner in varchar2                    -- max length 128 , always required
        ,pi_annotation_name  in varchar2                    -- max length 1024, always required, CaSe SeNsItIvE!
        )
    return hmx_types.t_y_n_e;

    -- ---------------------------------------------------------------------------------------------
    -- Public function that gets the value of a certain Oracle Annotation. Input parameters
    -- are the attributes that uniquely identify an annotation.
    function get_oracle_annotation
        (pi_object_name      in varchar2                    -- max length 128 , required
        ,pi_object_type      in varchar2                    -- max length 9   , required
        ,pi_column_name      in varchar2 := hmx_utl.k_none  -- max length 128 , optional, only for tables
        ,pi_annotation_name  in varchar2                    -- max length 1024, required, CaSe SeNsItIvE!
        )
    return varchar2;

    -- ---------------------------------------------------------------------------------------------
    -- Public procedure that adds or replaces a certain Oracle Annotation exists. Input parameters
    -- are the attributes that uniquely identify an annotation.
    procedure set_oracle_annotation
        (pi_object_name      in varchar2                    -- max length 128 , required
        ,pi_object_type      in varchar2                    -- max length 9   , required
        ,pi_column_name      in varchar2 := hmx_utl.k_none  -- max length 128 , optional, only for tables
        ,pi_annotation_name  in varchar2                    -- max length 1024, required, CaSe SeNsItIvE!
        ,pi_annotation_value in varchar2                    -- max length 4000, optional, CaSe SeNsItIvE!
        );

    -- ---------------------------------------------------------------------------------------------
    -- Public procedure that drops a certain Oracle Annotation if it exists. Input parameters
    -- are the attributes that uniquely identify an annotation.
    procedure drop_oracle_annotation
        (pi_object_name      in varchar2                    -- max length 128 , required
        ,pi_object_type      in varchar2                    -- max length 9   , required
        ,pi_column_name      in varchar2 := hmx_utl.k_none  -- max length 128 , optional, only for tables
        ,pi_annotation_name  in varchar2                    -- max length 1024, required, CaSe SeNsItIvE!
        );

    -- ---------------------------------------------------------------------------------------------
    -- Public procedure that returns the object version - pipelined (from the annotations)
    function get_object_version
        (pi_owner       in varchar2
        ,pi_object_name in varchar2
        ,pi_object_type in varchar2 := null
        )
    return hmx_object_version_arr 
    pipelined;

end hmx_annotations;
/

prompt *I: ScriptEOF hmx_annotations_pks.sql
