prompt *I: ScriptBOF hmx_operators_opr.sql

/* <hmx-annotations>

.HMX_OBJECT_VERSION 2026-10-20 15:29:53 CET
--> hmx_version_line_generator.sql

.HMX_OBJECT_REPO git@github.com:HermanMol/FJ12a_HMX-dev.git

.HMX_OBJECT_USAGE
    Script to create schema level operators

.HMX_DB_VERSION Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0

.HMX_OBJECT_NOTES -

.HMX_DEVELOPER_NOTES
    - See HMX General Developer Notes

** </hmx-annotations> */

-- Operators can only be used in SQL statements, not in PL/SQL statements

-- trim-s all white space incl LF, CR, CRLF, TAB and space i.s.o. TRIM (does only spaces)
-- ideal e.g. when inserting/updating fields that suffer from copy-paste-with-accidental_spaces
-- Example: update adresses set email = trimws(:p10_email) where address_id = :p10_address_id;
create or replace operator trimws
  binding (varchar2) return varchar2 using hmx_utl.trimws
/
comment on operator trimws 
  is 'Trims all white space (spaces, tabs, new lines, etc.) from the string and returns a clean string.'
/

-- is_equal compares two same datatype values and also returns 1 when both are NULL
-- the character version has a case-sensitive option/variant
-- with overloaded functions
create or replace operator is_equal
  binding
     (varchar2, varchar2 ,varchar2) return number using hmx_utl.is_equal
    ,(varchar2, varchar2)           return number using hmx_utl.is_equal
    ,(number,   number)             return number using hmx_utl.is_equal
    ,(date,     date)               return number using hmx_utl.is_equal
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
     (varchar2) return number using hmx_utl.to_num_val
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

