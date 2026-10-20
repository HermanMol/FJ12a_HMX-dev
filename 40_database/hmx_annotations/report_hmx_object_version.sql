select owner
        ,name
        ,type
        ,regexp_substr(text,'^\.HMX_OBJECT_VERSION (.*)',1,1,'i',1) as hmx_object_version
    from all_source
    where owner = 'HMOL'
    and name = 'HMX_ANNOTATIONS'
    and type like 'PACKAGE%'
    and text like '.HMX^_OBJECT^_VERSION%' escape '^'

/
with hmx_object_annotations as
    (select owner    as owner
        ,name       as object_name
        ,type       as object_type
        ,regexp_substr(text,'^\.HMX_OBJECT_VERSION (.*)',1,1,'i',1) as hmx_object_version
        ,text
    from all_source
    where name like 'HMX^_%' escape '^'   -- only HMX objects
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
/
select '.HMX_OBJECT_VERSION' 
    || ' ' || to_char(current_date,'yyyy-mm-dd hh24:mi:ss') 
    || ' ' || extract(timezone_abbr from current_timestamp) 
    as for_objects
    ,'add hmx_object_version'     
        || ' ''' || to_char(current_date,'yyyy-mm-dd hh24:mi:ss') 
        || ' ' || extract(timezone_abbr from current_timestamp) 
        || ''''
        as for_annotation
from dual
/
select sign(count(*))
--            into l_found
            from all_annotations_usage
            where object_name                           = 'HMX_ALL_OBJECT_VERSIONS'
            and   object_type                           = 'VIEW'
            and   annotation_owner                      = sys_context('USERENV','CURRENT_SCHEMA')
--            and   annotation_name                       = 'Test_Annotation' --l_annotation_name
--            and   coalesce(column_name ,hmx_utl.k_none) = l_column_name
--            and   coalesce(domain_name ,hmx_utl.k_none) = l_domain_name
--            and   coalesce(domain_owner,hmx_utl.k_none) = l_domain_owner
/
select *
from all_annotations_usage
order by 2,1,7
/
