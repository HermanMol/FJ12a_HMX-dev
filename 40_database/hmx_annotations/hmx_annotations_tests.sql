prompt *I: ScriptBOF hmx_annotations_tests.sql

declare

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
end;
/


prompt *I: ScriptEOF hmx_annotations_tests.sql
