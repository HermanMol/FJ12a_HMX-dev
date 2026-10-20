prompt *I: ScriptBOF hmx_annotations_pks.sql
create or replace package hmx_annotations
AUTHID CURRENT_USER
as

/* <hmx-annotations>

.HMX_OBJECT_VERSION 2026-10-20 15:13:48 CEST

.HMX_OBJECT_REPO git@github.com:HermanMol/FJ12a_HMX-dev.git

.HMX_OBJECT_USAGE
    This package is a wrapper to manage database annotations.

.HMX_DB_VERSION Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0

.HMX_OBJECT_NOTES
    - Package was initially developed with invoker rights (AUTHID CURRENT_USER)
    - Annotations supported in this package are tables, views, materialized views, and indexes.

.HMX_DEVELOPER_NOTES
    - See HMX General Developer Notes

** </hmx-annotations> */

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

end hmx_annotations;
/

prompt *I: ScriptEOF hmx_annotations_pks.sql
