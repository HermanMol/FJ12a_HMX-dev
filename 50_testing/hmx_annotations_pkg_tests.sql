@hmx_spoolstart hmx_annotations_pkg_tests.sql
prompt *I: ScriptBOF hmx_annotations_pkg_tests.sql

set heading off
@hmx_session_info
set heading on

declare
/* <hmx-annotations>

.HMX_OBJECT_USAGE: Script to test HMX_ANNOTATIONS package. Run from SQLcl.

.HMX_OBJECT_NOTES:
    This script tests the HMX_ANNOTATIONS package which is a wrapper around ANNOTATIONS
    functionality for Oracle Annotation (as listed in the view ALL_ANNOTATIONS_USAGE).
    This script does NOT test the HMX Annotations which are kept in the database
    object sources (select * from all_source where text like '.HMX^_%' escape '^')

.HMX_DEVELOPER_NOTES: See HMX General Developer Notes
.HMX_OBJECT_VERSION: 2026-10-20 09:33:58 +02:00
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */

    l_atn_name      varchar2(1024);
    l_atn_value_get varchar2(4000);
    l_atn_value_set varchar2(4000);

    procedure test
        (pi_object_name      in varchar2
        ,pi_object_type      in varchar2
        ,pi_column_name      in varchar2
        ,pi_annotation_owner in varchar2
        ,pi_annotation_name  in varchar2
        )
    as
        l_val   pls_integer;
    begin
        l_val := hmx_annotations.check_annotation_exists
                                (pi_object_name      => pi_object_name
                                ,pi_object_type      => pi_object_type
                                ,pi_column_name      => pi_column_name
                                ,pi_annotation_owner => pi_annotation_owner
                                ,pi_annotation_name  => pi_annotation_name
                                );
        prt('*I: Oracle Annotation exists?'
                || ' ' || pi_annotation_owner
                || '.' || pi_object_name
                || '.' || pi_object_type
                || nullif('.' || pi_column_name ,'.')
                || '.' || pi_annotation_name
                || ' = ' || l_val || ' - ' || hmx_utl.f_yes_no(l_val)
           );
    end test;

-- =========================================== MAIN LINE ===========================================
begin
    prt('*D: (line=' || $$plsql_line ||')');

    test(pi_object_name      => 'hmx_sys_context_userenv'                   -- max length 128
        ,pi_object_type      => 'VIEW'                                      -- max length 9
        ,pi_column_name      => null                                        -- max length 128
        ,pi_annotation_owner => sys_context('USERENV','CURRENT_SCHEMA')     -- max length 128
        ,pi_annotation_name  => 'HMX_OBJECT_VERSION'                        -- max length 1024
        );
    test(pi_object_name      => 'TOP4000'
        ,pi_object_type      => 'table'
        ,pi_column_name      => 'SONG_ARTIST'
        ,pi_annotation_owner => sys_context('USERENV','CURRENT_SCHEMA')
        ,pi_annotation_name  => 'HMX_COLUMN_USAGE'
        );

    l_atn_name := 'Test Annotation';

    prt('*I: DROP test annotation, if it already exists');
    hmx_annotations.drop_oracle_annotation
        (pi_object_name      => 'hmx_all_object_versions'  -- max length 128
        ,pi_object_type      => 'view'                     -- max length 9
        ,pi_column_name      => null                       -- max length 128
        ,pi_annotation_name  => l_atn_name                 -- max length 1024
        );
    hmx_annotations.drop_oracle_annotation
        (pi_object_name      => 'top4000'                  -- max length 128
        ,pi_object_type      => 'table'                    -- max length 9
        ,pi_column_name      => 'song_title'               -- max length 128
        ,pi_annotation_name  => l_atn_name                 -- max length 1024
        );

    dbms_session.sleep(10);

    prt('*I: ADD test annotation, if it already exists');
    hmx_annotations.set_oracle_annotation
        (pi_object_name      => 'hmx_all_object_versions'  -- max length 128
        ,pi_object_type      => 'view'                     -- max length 9
        ,pi_column_name      => null                       -- max length 128
        ,pi_annotation_name  => l_atn_name                 -- max length 1024
        ,pi_annotation_value => 'First annotation test value ' || to_char(current_date,'yyyy-mm-dd hh24:mi:ss')   -- max length 4000
        );
    hmx_annotations.set_oracle_annotation
        (pi_object_name      => 'top4000'                  -- max length 128
        ,pi_object_type      => 'table'                    -- max length 9
        ,pi_column_name      => 'song_title'               -- max length 128
        ,pi_annotation_name  => l_atn_name                 -- max length 1024
        ,pi_annotation_value => 'First 4k test value ' || to_char(current_date,'yyyy-mm-dd hh24:mi:ss')   -- max length 4000
        );

    dbms_session.sleep(10);

    prt('*I: REPLACE test annotation, if it already exists');
    hmx_annotations.set_oracle_annotation
        (pi_object_name      => 'hmx_all_object_versions'  -- max length 128
        ,pi_object_type      => 'view'                     -- max length 9
        ,pi_column_name      => null                       -- max length 128
        ,pi_annotation_name  => l_atn_name                 -- max length 1024
        ,pi_annotation_value => 'Second annotation test value ' || to_char(current_date,'yyyy-mm-dd hh24:mi:ss')   -- max length 4000
        );
    -- set the value to be tested against later
    l_atn_value_set := 'Second 4k column test value ' || to_char(current_date,'yyyy-mm-dd hh24:mi:ss');
    hmx_annotations.set_oracle_annotation
        (pi_object_name      => 'top4000'        -- max length 128
        ,pi_object_type      => 'table'          -- max length 9
        ,pi_column_name      => 'song_title'     -- max length 128
        ,pi_annotation_name  => l_atn_name       -- max length 1024
        ,pi_annotation_value => l_atn_value_set  -- max length 4000
        );

    dbms_session.sleep(1);
    prt('*I: Get annotation that exists');
    l_atn_value_get := hmx_annotations.get_oracle_annotation
                        (pi_object_name      => 'top4000'                  -- max length 128
                        ,pi_object_type      => 'table'                    -- max length 9
                        ,pi_column_name      => 'song_title'               -- max length 128
                        ,pi_annotation_name  => l_atn_name                 -- max length 1024
                        );
    if l_atn_value_get = hmx_utl.k_none
    then
        prt('*T: FAIL get_oracle_annotation(top4000,table,song_title' || l_atn_name || ') not found.');
    else
        if l_atn_value_get = l_atn_value_set
        then
            prt('*T: PASS get_oracle_annotation(top4000,table,song_title' || l_atn_name || ') = ' 
                || hmx_utl.f_q2q(hmx_utl.nvlc(l_atn_value_get))
                || ' is the expected value'
                );
        else
            prt('*T: FAIL get_oracle_annotation(top4000,table,song_title' || l_atn_name || ') not expected value:' 
                || ' Expected value = ' || hmx_utl.f_q2q(hmx_utl.nvlc(l_atn_value_set))
                || ', Retrieved value = ' || hmx_utl.f_q2q(hmx_utl.nvlc(l_atn_value_get))
                );
        end if;
    end if;

    dbms_session.sleep(10);

    prt('*I: DROP test annotation, if it still exists');
    hmx_annotations.drop_oracle_annotation
        (pi_object_name      => 'hmx_all_object_versions'  -- max length 128
        ,pi_object_type      => 'view'                     -- max length 9
        ,pi_column_name      => null                       -- max length 128
        ,pi_annotation_name  => l_atn_name                 -- max length 1024
        );
    hmx_annotations.drop_oracle_annotation
        (pi_object_name      => 'top4000'                  -- max length 128
        ,pi_object_type      => 'table'                    -- max length 9
        ,pi_column_name      => 'song_title'               -- max length 128
        ,pi_annotation_name  => l_atn_name                 -- max length 1024
        );

end;
/
prompt *I: ScriptEOF hmx_annotations_pkg_tests.sql
@hmx_spoolfinish
prompt Done.
