prompt *I: ScriptBOF hmx_utplsql_suite_info.sql
create or replace force view hmx_utplsql_suite_info
    (object_owner      annotations (add hmx_column_usage 'Owner of the database object tested.')
    ,object_name       annotations (add hmx_column_usage 'Name of the database object tested.')
    ,item_type         annotations (add hmx_column_usage 'utPLSQL test item type: UT_TEST, UT_SUITE, UT_LOGICAL_SUITE, UT_SUITE_CONTEXT, ....')
    ,item_name         annotations (add hmx_column_usage 'utPLSQL name of the test item.')
    ,item_description  annotations (add hmx_column_usage 'utPLSQL description of the test item.')
    ,item_line_no      annotations (add hmx_column_usage 'utPLSQL line number of the annotation in the test package spec.')
    ,path              annotations (add hmx_column_usage 'utPLSQL path of the test item.')
    ,disabled_flag     annotations (add hmx_column_usage 'utPLSQL disabled item. 0=disabled, 1=enabled.')
    ,disabled_reason   annotations (add hmx_column_usage 'utPLSQL reason why the test item is disabled.')
    ,tags              annotations (add hmx_column_usage 'utPLSQL comma-separated list of item tags.')
    )
    annotations
        (add hmx_object_usage    'Report of the utPLSQL suites and tests.'
        ,add hmx_object_notes    'This view is based on utPLSQL ut_runner.get_suites_info.'
        ,add hmx_developer_notes 'See HMX General Developer Notes'
        ,add hmx_object_version  '2026-11-11 16:22:53 +01:00'
        ,add hmx_db_version      'Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0'
        ,add hmx_object_repo     'git@github.com:HermanMol/FJ12a_HMX-dev.git'
        ,add hmx_utplsql_version 'v.3.2.3'
        )
as
select object_owner
    , object_name
    , item_type
    , item_name
    , item_description
    , item_line_no
    , path
    , disabled_flag
    , disabled_reason
    , tags
from table(ut_runner.get_suites_info())
/

prompt *I: ScriptEOF hmx_utplsql_suite_info.sql
