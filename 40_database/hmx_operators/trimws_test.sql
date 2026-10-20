prompt *I: ScriptBOF trimws_test.sql
@hmx_spoolstart trimws_test.sql
with test_data as
(
    select 1 as nr, 'none' as ws, 'a' as col1, 'b' as col2, 'c' as col3 from dual
union all    
    select 2 as nr, 'none' as ws, 'a' as col1, 'b' as col2, 'c' as col3  from dual
union all    
    select 3 as nr, 'sp' as ws, ' a' as col1, ' b' as col2, ' c ' as col3  from dual
union all    
    select 4 as nr, 'tab' as ws, chr(9)||'a' as col1, 'b'||chr(9) as col2, chr(9)||'c'||chr(9) as col3  from dual
union all    
    select 5 as nr, 'lf' as ws, chr(10)||'a' as col1, 'b'||chr(10) as col2, chr(10)||'c'||chr(10) as col3  from dual
union all    
    select 6 as nr, 'cr' as ws, chr(13)||'a' as col1, 'b'||chr(13) as col2, chr(13)||'c'||chr(13) as col3  from dual
union all    
    select 7 as nr, 'multi' as ws, chr(13)||chr(10)||chr(9)||'a' as col1, 'b'||chr(13)||chr(10)||chr(9) as col2, chr(13)||chr(10)||chr(9)||'c'||chr(13)||chr(10)||chr(9) as col3  from dual
)
select nr
    ,ws
    ,'>' || trimws(col1) || '<' as trimws1
    ,'>' || trimws(col2) || '<' as trimws2
    ,'>' || trimws(col3) || '<' as trimws3
    ,'>' || col1 || '<' as col1
    ,'>' || col2 || '<' as col2
    ,'>' || col3 || '<' as col3
    ,'>' || trim(col1) || '<' as trim1
    ,'>' || trim(col2) || '<' as trim2
    ,'>' || trim(col3) || '<' as trim3
    ,'(#'||rownum||')' as rijnr
from test_data
/
@hmx_spoolfinish
prompt *I: ScriptEOF trimws_test.sql
