create or replace package body ut_hmx_annotations
as

-- Generated using hmx_utplsql_utl.generate_test_package_body on 2026-11-12 15:19:23 +01:00
-- Modified: yyyy-mm-dd by who

    --#suite(Suite_2026-11-12 12:28:10)
    --#suitepath(HMXTESTS.hmx_annotations)
    --#context(Project_FJ12a)

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(C=fk_hmx_object_version_format#001)
    procedure fk_hmx_object_version_format#001
    as
        l_expect       varchar2(32767);
        l_actual       varchar2(32767);
    begin
        -- l_expect := ?UT?
        -- l_actual := hmx_annotations.fk_hmx_object_version_format
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end fk_hmx_object_version_format#001;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(C=hmx_version_to_utc#002[pi_hmx_version,C; pi_alt_format,C])
    procedure hmx_version_to_utc#002
    as
        l_expect       varchar2(32767);
        l_actual       varchar2(32767);
    begin
        -- l_expect := ?UT?
        -- l_actual := hmx_annotations.hmx_version_to_utc
        --     (pi_hmx_version    => C
        --     ,pi_alt_format    => C
        --     );
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end hmx_version_to_utc#002;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(N=check_annotation_exists#003[pi_object_name,C; pi_object_type,C; pi_column_name,C; pi_domain_name,C; pi_domain_owner,C; pi_annotation_owner,C; pi_annotation_name,C])
    procedure check_annotation_exists#003
    as
        l_expect       number;
        l_actual       number;
    begin
        -- l_expect := ?UT?
        -- l_actual := hmx_annotations.check_annotation_exists
        --     (pi_object_name    => C
        --     ,pi_object_type    => C
        --     ,pi_column_name    => C
        --     ,pi_domain_name    => C
        --     ,pi_domain_owner    => C
        --     ,pi_annotation_owner    => C
        --     ,pi_annotation_name    => C
        --     );
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end check_annotation_exists#003;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(C=get_oracle_annotation#004[pi_object_name,C; pi_object_type,C; pi_column_name,C; pi_annotation_name,C])
    procedure get_oracle_annotation#004
    as
        l_expect       varchar2(32767);
        l_actual       varchar2(32767);
    begin
        -- l_expect := ?UT?
        -- l_actual := hmx_annotations.get_oracle_annotation
        --     (pi_object_name    => C
        --     ,pi_object_type    => C
        --     ,pi_column_name    => C
        --     ,pi_annotation_name    => C
        --     );
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end get_oracle_annotation#004;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(set_oracle_annotation#005[pi_object_name,C; pi_object_type,C; pi_column_name,C; pi_annotation_name,C; pi_annotation_value,C])
    procedure set_oracle_annotation#005
    as
        l_expect       varchar2(?ut?);
        l_actual       varchar2(?ut?);
    begin
        -- l_expect := ?UT?
        -- hmx_annotations.set_oracle_annotation
        --     (pi_object_name    => C
        --     ,pi_object_type    => C
        --     ,pi_column_name    => C
        --     ,pi_annotation_name    => C
        --     ,pi_annotation_value    => C
        --     );
        -- l_actual := '?UT?'; -- unknown at time of unit test generation
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end set_oracle_annotation#005;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(drop_oracle_annotation#006[pi_object_name,C; pi_object_type,C; pi_column_name,C; pi_annotation_name,C])
    procedure drop_oracle_annotation#006
    as
        l_expect       varchar2(?ut?);
        l_actual       varchar2(?ut?);
    begin
        -- l_expect := ?UT?
        -- hmx_annotations.drop_oracle_annotation
        --     (pi_object_name    => C
        --     ,pi_object_type    => C
        --     ,pi_column_name    => C
        --     ,pi_annotation_name    => C
        --     );
        -- l_actual := '?UT?'; -- unknown at time of unit test generation
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end drop_oracle_annotation#006;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(?UT?=get_object_version#007[pi_owner,C; pi_object_name,C; pi_object_type,C])
    procedure get_object_version#007
    as
        l_expect       table(?ut?);
        l_actual       table(?ut?);
    begin
        -- l_expect := ?UT?
        -- l_actual := hmx_annotations.get_object_version
        --     (pi_owner    => C
        --     ,pi_object_name    => C
        --     ,pi_object_type    => C
        --     );
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end get_object_version#007;

    -- ---------------------------------------------------------------------------------------------
    --#tags(utPLSQL_v3.2.4.)
    --#test(C=get_object_version_value#008[pi_owner,C; pi_object_name,C; pi_object_type,C])
    procedure get_object_version_value#008
    as
        l_expect       varchar2(32767);
        l_actual       varchar2(32767);
    begin
        -- l_expect := ?UT?
        -- l_actual := hmx_annotations.get_object_version_value
        --     (pi_owner    => C
        --     ,pi_object_name    => C
        --     ,pi_object_type    => C
        --     );
        -- Assert
        ut.expect(l_actual).to_equal(l_expect, a_nulls_are_equal => true );
    end get_object_version_value#008;

    --#endcontext
    -- Number of tests generated: 8
    -- End of suite(Test package hmol.hmx_annotations)

end ut_hmx_annotations;
/


