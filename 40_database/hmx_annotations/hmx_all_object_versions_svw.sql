prompt *I: ScriptBOF hmx_all_object_versions_svw.sql
create or replace force view hmx_all_object_versions
as
with hmx_object_annotations as
    (select owner    as owner
        ,name       as object_name
        ,type       as object_type
        ,regexp_substr(text,'^\.HMX_OBJECT_VERSION (.*)',1,1,'i',1) as hmx_object_version
        ,text
    from all_source
    where name like 'HMX^_%' escape '^'   -- only HMX objects
    and type not in ('TABLE', 'VIEW', 'MATERIALIZED VIEW', 'INDEX') -- use te Oracle Annotation
    and text like '.HMX^_OBJECT^_VERSION%' escape '^'
    )
,hmx_annotations as
    (select annotation_owner as owner
        ,object_name        as object_name
        ,OBJECT_TYPE        as object_type
        ,annotation_value   as hmx_object_version
    from all_annotations_usage
    where object_name like 'HMX^_%' escape '^'   -- only HMX objects
    and annotation_name = 'HMX_OBJECT_VERSION'
    )
select owner
    ,object_name
    ,object_type
    ,hmx_object_version
from hmx_object_annotations
union all
select owner
    ,object_name
    ,object_type
    ,hmx_object_version
from hmx_annotations
order by owner
    ,object_name
    ,object_type
;

prompt *I: ScriptEOF hmx_all_object_versions_svw.sql
