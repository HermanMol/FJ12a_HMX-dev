prompt *I: ScriptBOF hmx_all_object_versions_svw.sql
create or replace force view hmx_all_object_versions
    (owner              annotations (add hmx_column_usage 'The owner of the object or annotation')
    ,object_name        annotations (add hmx_column_usage 'The object that the annotation relates to.')
    ,object_type        annotations (add hmx_column_usage 'The object type the annotation relates to.')
    ,hmx_object_version annotations (add hmx_column_usage 'The version of the object in the format yyyy-mm-dd hh24:mi:ss TZH:TZM.')
    ,atn_loc            annotations (add hmx_column_usage 'The location of the annotation: S = in the object source, A = in an Oracle Annotation.')
    ,utc_version        annotations (add hmx_column_usage 'The version of the object in UTC timestamp value')
    )
    annotations
        (add hmx_object_usage    'This view shows annotation HMX_OBJECT_VERSION of all Oracle Annotations and HMX-annotations.'
        ,add hmx_object_notes    'Oracle Annotations are found on ALL_ANNOTATIONS_USAGE view and HMX-annotations extracted from text lines in ALL_SOURCE view.'
        ,add hmx_developer_notes 'See HMX General Developer Notes'
        ,add hmx_object_version  '2026-10-22 17:19:02 +02:00'
        ,add hmx_db_version      'Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0'
        ,add hmx_object_repo     'git@github.com:HermanMol/FJ12a_HMX-dev.git'
        )
as
with hmx_source_annotations as
    (select owner                                                               as owner
        ,name                                                                   as object_name
        ,type                                                                   as object_type
        ,regexp_substr(text,'^\.HMX_OBJECT_VERSION: ([[:print:]]*)',1,1,'i',1)  as hmx_object_version
        ,text
    from all_source
    where text like '.HMX^_OBJECT^_VERSION:%' escape '^'
    )
,hmx_oracle_annotations as
    (select annotation_owner as owner
        ,object_name         as object_name
        ,OBJECT_TYPE         as object_type
        ,annotation_value    as hmx_object_version
    from all_annotations_usage
    where object_name like 'HMX^_%' escape '^'   -- only HMX objects
    and   annotation_name = 'HMX_OBJECT_VERSION'
    )
select owner
    ,object_name
    ,object_type
    ,hmx_object_version
    ,'S'                as atn_loc
    ,hmx_annotations.hmx_version_to_utc(HMX_OBJECT_VERSION,'yyyy-mm-dd hh24:mi:ss') as UTC_version
from hmx_source_annotations
union all
select owner
    ,object_name
    ,object_type
    ,hmx_object_version
    ,'A'                as atn_loc
    ,hmx_annotations.hmx_version_to_utc(HMX_OBJECT_VERSION,'yyyy-mm-dd hh24:mi:ss') as UTC_version
from hmx_oracle_annotations
;

comment on table hmx_all_object_versions is 'View showing annotation HMX_OBJECT_VERSION of all Oracle Annotations and HMX-annotations.';

prompt *I: ScriptEOF hmx_all_object_versions_svw.sql
