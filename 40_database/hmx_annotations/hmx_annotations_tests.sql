prompt *I: ScriptBOF hmx_annotations_tests.sql

declare

    l_atn_name varchar2(1024);

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
        prt('*I: Annotation exists?'
                || ' ' || pi_annotation_owner
                || '.' || pi_object_name
                || '.' || pi_object_type
                || nullif('.' || pi_column_name ,'.')
                || '.' || pi_annotation_name
                || ' = ' || l_val || ' - ' || hmx_utl.f_yes_no(l_val)
           );
    end test;

-- ================================== MAIN LINE ====================================================
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
    hmx_annotations.set_oracle_annotation
        (pi_object_name      => 'top4000'                  -- max length 128
        ,pi_object_type      => 'table'                    -- max length 9
        ,pi_column_name      => 'song_title'               -- max length 128
        ,pi_annotation_name  => l_atn_name                 -- max length 1024
        ,pi_annotation_value => 'Second 4k test value ' || to_char(current_date,'yyyy-mm-dd hh24:mi:ss')   -- max length 4000
        );

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
prompt *I: ScriptEOF hmx_annotations_tests.sql
