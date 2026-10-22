prompt *I: ScriptBOF hmx_all_annotations_svw.sql
create or replace force view hmx_all_annotations
    (owner              annotations (add hmx_column_usage 'The owner of the object annotation')
    ,object_name        annotations (add hmx_column_usage 'The object that the annotation relates to.')
    ,object_type        annotations (add hmx_column_usage 'The object type the annotation relates to.')
    ,column_name        annotations (add hmx_column_usage 'The column name that the annotation relates to (only for views and tables).')
    ,object_line        annotations (add hmx_column_usage 'The line number containing the annotation.')
    ,annotation_name    annotations (add hmx_column_usage 'The annotation name.')
    ,annotation_value   annotations (add hmx_column_usage 'The annotation value.')
    ,atn_loc            annotations (add hmx_column_usage 'The location of the annotation: S = in the object source, A = in an Oracle Annotation.')
    )
    annotations
        (add hmx_object_usage    'This view shows all annotations, in Oracle Annotations and in HMX-annotations.'
        ,add hmx_object_notes    'Oracle Annotations are found on ALL_ANNOTATIONS_USAGE view and HMX-annotations extracted from text lines in ALL_SOURCE view.'
        ,add hmx_developer_notes 'See HMX General Developer Notes'
        ,add hmx_object_version  '2026-10-22 09:30:36 +02:00'
        ,add hmx_db_version      'Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0'
        ,add hmx_object_repo     'git@github.com:HermanMol/FJ12a_HMX-dev.git'
        )
as
select owner                                                    as owner
    ,name                                                       as object_name
    ,type                                                       as object_type
    ,to_char(null)                                              as column_name
    ,line                                                       as object_line
    ,regexp_substr(text,'^\.(\w+)',1,1,'i',1)                   as annotation_name
    ,regexp_substr(text,'^\.(\w+): ?([[:print:]]+)',1,1,'i',2)  as annotation_value
    ,'S'                                                        as atn_loc
from all_source 
where text like '.HMX^_%' escape '^'
union
select annotation_owner as owner
    ,object_name        as object_name
    ,OBJECT_TYPE        as object_type
    ,column_name as column_name
    ,to_number(null)    as object_line    
    ,annotation_name    as annotation_name
    ,annotation_value   as annotation_value
    ,'A'                as atn_loc
from all_annotations_usage
where object_name like 'HMX^_%' escape '^'
;

comment on table hmx_all_annotations is 'View showing all annotations, in Oracle Annotations and in HMX-annotations.';

prompt *I: ScriptEOF hmx_all_annotations_svw.sql
