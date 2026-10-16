prompt *I: ScriptBOF hmx_operators_opr.sql

-- Operators can only be used in SQL statements, not in PL/SQL statements

-- trim-s all white space incl LF, CR, CRLF, TAB and space i.s.o. TRIM (does only spaces)
-- ideal e.g. when inserting/updating fields that suffer from copy-paste-with-accidental_spaces
-- Example: update adresses set email = trimws(:p10_email) where address_id = :p10_address_id;
create or replace operator trimws
  binding (varchar2) return varchar2 using gdbutl.trimws
/
comment on operator trimws 
  is 'Trims all white space (spaces, tabs, new lines, etc.) from the string and returns a clean string.'
/

-- is_equal compares two same datatype values and also returns 1 when both are NULL
-- the character version has a case-sensitive option/variant
-- with overloaded functions
create or replace operator is_equal
  binding
     (varchar2, varchar2 ,varchar2) return number using gdbutl.is_equal
    ,(varchar2, varchar2)           return number using gdbutl.is_equal
    ,(number,   number)             return number using gdbutl.is_equal
    ,(date,     date)               return number using gdbutl.is_equal
/
comment on operator is_equal 
  is 'Returns 1 if both operands are equal including when both are NULL.
If the first two operands are type varchar2 an optional third operand indicates whether
the comparison is case sensitive (''c'') or case insensitive (''i'') like the REGEXP-
functions.'
/

-- to_num_val tries to convert a character value to a number.
-- If it fails it returns NULL, but NO exception is raised.
-- If the input is NULL it also returns NULL
create or replace operator to_num_val
  binding
     (varchar2) return number using gdbutl.to_num_val
/
comment on operator to_num_val 
  is 'TO_NUM_VAL attempts to convert a character value to a number. If it fails it 
returns NULL, but NO exception is raised. If the input is NULL it also returns NULL
too.'
/
prompt *I: ScriptEOF hmx_operators_opr.sql

-- -- to_check:
-- select *
-- from all_operator_comments
-- where owner = sys_context('userenv','current_schema')
-- order by operator_name

