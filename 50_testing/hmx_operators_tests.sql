@hmx_spoolstart hmx_operators_tests.sql
prompt *I: ScriptBOF hmx_operators_tests.sql

set heading off
@hmx_session_info
set heading on

-- -------------------------------------------------------------------------------------------------

prompt *I: Test operator trimws - Start

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

prompt *I: Test operator trimws - End

-- -------------------------------------------------------------------------------------------------

prompt *I: Test operator isEqual (characters) - Start

with testdata as
(
    select 'a' as c1, 'a' as c2, 'A' as c3, '-' as c4
    from dual
)
select c1
    ,c2
    ,c3
    ,c4
    ,hmx_utl.f_yes_no(is_equal(c1,c2,hmx_utl.fk_case_sensitive)) as "c1?c2"
    ,hmx_utl.f_yes_no(is_equal(c1,c3,hmx_utl.fk_case_sensitive)) as "c1?c3"
    ,hmx_utl.f_yes_no(is_equal(c1,c4,hmx_utl.fk_case_sensitive)) as "c1?c4"
    ,hmx_utl.f_yes_no(is_equal(c1,c2,hmx_utl.fk_case_insensitive)) as "c1?C2"
    ,hmx_utl.f_yes_no(is_equal(c1,c3,hmx_utl.fk_case_insensitive)) as "c1?C3"
    ,hmx_utl.f_yes_no(is_equal(c1,c4,hmx_utl.fk_case_insensitive)) as "c1?C4"
from testdata
/

prompt *I: Test operator isEqual (characters) - End

-- -------------------------------------------------------------------------------------------------

prompt *I: Test operator isEqual (numbers) - Start

with testdata as
(
    select 1 as n1, 1 as n2, 3 as n3, -1 as n4
    from dual
)
select n1
    ,n2
    ,n3
    ,n4
    ,hmx_utl.f_yes_no(is_equal(n1,n2)) as "n1?n2"
    ,hmx_utl.f_yes_no(is_equal(n1,n3)) as "n1?n3"
    ,hmx_utl.f_yes_no(is_equal(n1,n4)) as "n1?n4"
from testdata
/

prompt *I: Test operator isEqual (numbers) - End

-- -------------------------------------------------------------------------------------------------

prompt *I: ScriptEOF hmx_operators_tests.sql
@hmx_spoolfinish
prompt Done.