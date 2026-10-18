-- Version 2026-10-18 15:25:37
-- Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
-- Date 2026-10-18 16:29:02 CET
--
-- One annotation for a simple view
alter view hmx_sys_context_userenv 
    annotations 
        (add if not exists hmx_object_usage 'This view is used to show values of the USERENV context and avoid an exception to occur when an unknown context attribute is requested.'
        )
/
-- multi annotations in one statement (if the none of the annotations already exist)
alter view hmx_sys_context_userenv 
    annotations 
        (add hmx_object_repo    'added: git@github.com:HermanMol/FJ12a_HMX-dev.git'
        ,add hmx_object_version 'added: 2026-10-18 15:11:54.'
        )
/
-- change an object annotation; the annotations must exist!
alter view hmx_sys_context_userenv 
    annotations 
        (replace hmx_object_repo    'replaced: git@github.com:HermanMol/FJ12a_HMX-dev.git'
        ,replace hmx_object_version 'replaced: 2026-10-18 15:12:06.'
        ,replace hmx_object_usage   'replaced: This view is used to show values of the USERENV context and avoid an exception to occur when an unknown context attribute is requested.'
        )
/
alter view hmx_sys_context_userenv 
    annotations 
        (drop if exists hmx_object_repo
        ,drop if exists hmx_object_usage
        ,drop if exists hmx_object_version
        )
/
alter view hmx_sys_context_userenv 
    annotations 
        (add if not exists hmx_object_repo    'new: git@github.com:HermanMol/FJ12a_HMX-dev.git'
        ,add if not exists hmx_object_version 'new: 2026-10-18 15:24:37.'
        ,add if not exists hmx_object_usage   'new: This view is used to show values of the USERENV context and avoid an exception to occur when an unknown context attribute is requested.'
        )
/
-- column annotations for a table
-- column annotations can ONLY be added at view-creation time, NOT afterwards.
alter table top4000 
modify (list_year    ANNOTATIONS (add hmx_column_usage 'The year that the list was published.')
       ,list_rank    ANNOTATIONS (add hmx_column_usage 'The rank of the song in the list in the LIST_YEAR.')
       ,song_artist  ANNOTATIONS (add hmx_column_usage 'The artist or band performing the listed song version in the LIST_YEAR.')
       )
/
-- list the available annotations
select * 
from all_annotations_usage
where annotation_name like 'HMX^_%' escape '^'
order by annotation_owner
    ,object_name
    ,annotation_name
/
