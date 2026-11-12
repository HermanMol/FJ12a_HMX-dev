create or replace package ut_hmx_annotations
as

-- Generated using hmx_utplsql_utl.generate_test_package_spec on 2026-11-12 15:19:22 +01:00
-- Modified: yyyy-mm-dd by who

    --%suite(Suite_2026-11-12 12:28:10)
    --%suitepath(HMXTESTS.hmx_annotations)
    --%context(Project_FJ12a)

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=fk_hmx_object_version_format#001)
    procedure fk_hmx_object_version_format#001;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=hmx_version_to_utc#002[pi_hmx_version,C; pi_alt_format,C])
    procedure hmx_version_to_utc#002;

    --%tags(utPLSQL_v3.2.4.)
    --%test(N=check_annotation_exists#003[pi_object_name,C; pi_object_type,C; pi_column_name,C; pi_domain_name,C; pi_domain_owner,C; pi_annotation_owner,C; pi_annotation_name,C])
    procedure check_annotation_exists#003;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=get_oracle_annotation#004[pi_object_name,C; pi_object_type,C; pi_column_name,C; pi_annotation_name,C])
    procedure get_oracle_annotation#004;

    --%tags(utPLSQL_v3.2.4.)
    --%test(set_oracle_annotation#005[pi_object_name,C; pi_object_type,C; pi_column_name,C; pi_annotation_name,C; pi_annotation_value,C])
    procedure set_oracle_annotation#005;

    --%tags(utPLSQL_v3.2.4.)
    --%test(drop_oracle_annotation#006[pi_object_name,C; pi_object_type,C; pi_column_name,C; pi_annotation_name,C])
    procedure drop_oracle_annotation#006;

    --%tags(utPLSQL_v3.2.4.)
    --%test(?UT?=get_object_version#007[pi_owner,C; pi_object_name,C; pi_object_type,C])
    procedure get_object_version#007;

    --%tags(utPLSQL_v3.2.4.)
    --%test(C=get_object_version_value#008[pi_owner,C; pi_object_name,C; pi_object_type,C])
    procedure get_object_version_value#008;

    --%endcontext
    -- Number of tests generated: 8
    -- End of suite(Suite_2026-11-12 12:28:10)

end ut_hmx_annotations;
/


