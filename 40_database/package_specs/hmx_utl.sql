prompt *I: ScriptBOF hmx_utl.sql
create or replace package hmx_utl
as

/* <hmx-annotations>

.HMX_OBJECT_USAGE: Package with constants and smart functions, some used in OPERATORS

.HMX_OBJECT_NOTES: -

.HMX_DEVELOPER_NOTES:
    - See HMX General Developer Notes
    - Some functions are used in schema level operators. See hmx_operators_opr.sql

.HMX_OBJECT_VERSION: 2026-11-12 18:14:01 +01:00
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */

    k_no          constant varchar2(1) := 'N';
    k_yes         constant varchar2(1) := 'Y';
    k_false       constant varchar2(1) := 't';
    k_true        constant varchar2(1) := 'f';
    k_fail        constant varchar2(1) := 'F';
    k_pass        constant varchar2(1) := 'P';
    k_nok         constant varchar2(1) := 'n';
    k_ok          constant varchar2(1) := 'o';
    k_failed      constant varchar2(1) := 'f';
    k_success     constant varchar2(1) := 's';
    k_ellipsis    constant varchar2(3) := '...';

    -- for use with hmx_types.t_bool
    k_bno         constant pls_integer :=  0 ;
    k_byes        constant pls_integer :=  1 ;
    k_bfalse      constant pls_integer :=  0 ;
    k_btrue       constant pls_integer :=  1 ;
    k_bfail       constant pls_integer :=  0 ;
    k_bpass       constant pls_integer :=  1 ;

    k_berror      constant pls_integer :=  -1 ;

    --                                          Special ASCII characters
    k_lf          constant varchar2(1) := chr(10);   -- ASCII Line Feed
    k_cr          constant varchar2(1) := chr(13);   -- ASCII Carriage Return
    k_crlf        constant varchar2(2) := k_cr || k_lf;
    --
    k_sp          constant varchar2(1) := chr(32);   -- ASCII Space
    k_tab         constant varchar2(1) := chr(09);   -- ASCII TAB
    k_2q          constant varchar2(1) := chr(34);   -- ASCII double quote
    k_1q          constant varchar2(1) := chr(39);   -- ASCII single quote
    k_bq          constant varchar2(1) := chr(96);   -- ASCII back quote
    k_amp         constant varchar2(1) := chr(38);   -- ASCII ampersand
    k_at          constant varchar2(1) := chr(64);   -- ASCII @
    k_pct         constant varchar2(1) := chr(37);   -- ASCII percent
    --
    k_us          constant varchar2(1) := chr(31);   -- ASCII Unit Separator
    k_gs          constant varchar2(1) := chr(29);   -- ASCII Group Separator
    k_rs          constant varchar2(1) := chr(30);   -- ASCII Record Separator
    k_fs          constant varchar2(1) := chr(28);   -- ASCII File Separator
    --
    k_ack         constant varchar2(1) := chr(06);   -- ASCII Acknowledgment
    k_nak         constant varchar2(1) := chr(21);   -- ASCII Negative Acknowledgment
    k_none        constant varchar2(1) := chr(127);  -- ASCII Del, also used when a char value searched for was not found.

    -- other constants
    k_case_sensitive    constant varchar2(1) := 'C';
    k_case_insensitive  constant varchar2(1) := 'I';

    -- minimum and maximum values for Oracle numbers and dates and two special dates: ratadie and year zero
    k_ora_min_number constant number := power(10,-130);
    k_ora_max_number constant number := power(10,125);
    k_ora_min_date   constant date   := to_date('47120101BC000000', 'yyyymmddbchh24miss');
    k_ora_max_date   constant date   := to_date('99991231235959'  , 'yyyymmddhh24miss'  );
    k_ratadie        constant date   := to_date('00010101000000'  , 'yyyymmddhh24miss'  );
    -- k_year_zero   constant date   := to_date('00000101000000'  , 'yyyymmddhh24miss'  ); ORA-01841: (full) year must be between -4713 and +9999, and not be 0

    -- Public constants implemented as deterministic functions so they can be used in queries
    function fk_no          return varchar2 deterministic;
    function fk_yes         return varchar2 deterministic;
    function fk_fail        return varchar2 deterministic;
    function fk_pass        return varchar2 deterministic;
    function fk_nok         return varchar2 deterministic;
    function fk_ok          return varchar2 deterministic;
    function fk_failed      return varchar2 deterministic;
    function fk_success     return varchar2 deterministic;
    function fk_ellipsis    return varchar2 deterministic;

    -- for use with hmx_types.t_bool
    function fk_bno         return pls_integer deterministic;
    function fk_byes        return pls_integer deterministic;
    function fk_bfalse      return pls_integer deterministic;
    function fk_btrue       return pls_integer deterministic;
    function fk_bfail       return pls_integer deterministic;
    function fk_bpass       return pls_integer deterministic;
    function fk_berror      return pls_integer deterministic;

    --                                                 Special ASCII characters
    function fk_lf          return varchar2 deterministic;  -- ASCII Line Feed
    function fk_cr          return varchar2 deterministic;  -- ASCII Carriage Return
    function fk_crlf        return varchar2 deterministic;
    --
    function fk_sp          return varchar2 deterministic;  -- ASCII Space
    function fk_tab         return varchar2 deterministic;  -- ASCII TAB
    function fk_2q          return varchar2 deterministic;  -- ASCII double quote
    function fk_1q          return varchar2 deterministic;  -- ASCII single quote
    function fk_bq          return varchar2 deterministic;  -- ASCII back quote
    function fk_amp         return varchar2 deterministic;  -- ASCII ampersand
    function fk_at          return varchar2 deterministic;  -- ASCII @
    function fk_pct         return varchar2 deterministic;  -- ASCII percent
    --
    function fk_us          return varchar2 deterministic;  -- ASCII Unit Separator
    function fk_gs          return varchar2 deterministic;  -- ASCII Group Separator
    function fk_rs          return varchar2 deterministic;  -- ASCII Record Separator
    function fk_fs          return varchar2 deterministic;  -- ASCII File Separator
    --
    function fk_ack         return varchar2 deterministic;  -- ASCII Acknowledgment
    function fk_nak         return varchar2 deterministic;  -- ASCII Negative Acknowledgment
    function fk_none        return varchar2 deterministic;  -- ASCII Del

    function fk_case_sensitive   return varchar2 deterministic;
    function fk_case_insensitive return varchar2 deterministic;

    -- Minimum and maximum values for Oracle numbers and dates and two special dates: ratadie
    function fk_ora_min_number return number deterministic;
    function fk_ora_max_number return number deterministic;
    function fk_ora_min_date   return date   deterministic;
    function fk_ora_max_date   return date   deterministic;
    function fk_ratadie        return date   deterministic;
--  function fk_year_zero      return date   deterministic; ORA-01841: (full) year must be between -4713 and +9999, and not be 0

    -- ---------------------------------------------------------------------------------------------
    -- Function to return the received character value or 'nill'
    -- Overloaded for character, date, number or boolean
    function nvlc
        (pi_cvalue  in varchar2
        ,pi_ifnull  in varchar2
        )
    return varchar2
    deterministic;
    function nvlc
        (pi_cvalue in varchar2
        )
    return varchar2
    deterministic;
    -- ---------------------------------------------------------------------------------------------
    -- Function to return the received date value as a character or 'nill'
    -- Overloaded for character, date, number or boolean
    function nvlc
        (pi_dvalue  in date
        ,pi_ifnull  in varchar2
        )
    return varchar2
    deterministic;
    function nvlc
        (pi_dvalue in date
        )
    return varchar2
    deterministic;
    -- ---------------------------------------------------------------------------------------------
    -- Function to return the received number value as a character or 'nill'
    -- Overloaded for character, date, number or boolean
    function nvlc
        (pi_nvalue  in number
        ,pi_ifnull  in varchar2
        )
    return varchar2
    deterministic;
    function nvlc
        (pi_nvalue in number
        )
    return varchar2
    deterministic;
    -- ---------------------------------------------------------------------------------------------
    -- Function to return the received boolean value as a character or 'nill'
    -- Overloaded for character, date, number or boolean
    function nvlc
        (pi_bvalue  in boolean
        ,pi_ifnull  in varchar2
        )
    return varchar2
    deterministic;
    function nvlc
        (pi_bvalue in boolean
        )
    return varchar2
    deterministic;

    -- ---------------------------------------------------------------------------------------------
    -- Public (overloaded) functions that return 1 if both arguments are equal including when both
    -- arguments are NULL. Return 0 if the arguments differ. Return -1 if an error occurred.
    -- They are also equal if they are both NULL.
    --
    -- Base for character data, with option case sensitive('c') or insensitive('i') (like Oracles
    -- REGEXP-functions). Tip: use package public constants k_case_sensitive/k_case_insensitive.
    -- If the character case-sensitive argument is invalid then is_equal function returns -2.
    -- Also available as a SQL Operator IS_EQUAL which can be used in a SQL query (only!)
    function is_equal
        (pi_char1 in varchar2
        ,pi_char2 in varchar2
        ,pi_case  in varchar2  -- use package public constants k_case_sensitive/k_case_insensitive
        )
    return number
    deterministic;
    -- Overload for character data, with default case insensitive
    -- Also available as a SQL Operator IS_EQUAL which can be used in a SQL query (only!)
    function is_equal
        (pi_char1 in varchar2
        ,pi_char2 in varchar2
        )
    return number
    deterministic;
    -- Overload for numeric data.
    -- Also available as a SQL Operator IS_EQUAL which can be used in a SQL query (only!)
    function is_equal
        (pi_num1 in number
        ,pi_num2 in number
        )
    return number
    deterministic;
    -- Overload for date+time data.
    -- Also available as a SQL Operator IS_EQUAL which can be used in a SQL query (only!)
    function is_equal
        (pi_date1 in date
        ,pi_date2 in date
        )
    return number
    deterministic;

    -- ---------------------------------------------------------------------------------------------
    -- Function that removes ALL leading and trailing whitespace (tab, cr, lf, space...)
    -- Also available as a SQL Operator TRIMWS which can be used in a SQL query (only!)
    function trimws
        (pi_string in varchar2
        )
    return varchar2
    deterministic;

    -- -----------------------------------------------------------------------------------------------
    -- Public function to try to convert a character value to a number.
    -- When this is not possible NULL is returned, NO exception is raised (it is ignored)
    -- When a null value is passed also a NULL is returned (garbage-in, garbage-out)
    -- Also available as a SQL Operator TO_NUM_VAL which can be used in a SQL query (only!)
    -- Possible upgrade: add optional second argument with a numeric format to be used
    function to_num_val
        (pi_value   in varchar2
        )
    return number
    deterministic;

    -- -----------------------------------------------------------------------------------------------
    -- Public function returning a string "Yes" or "No" depending on the input.
    -- If not "Yes" or "No", then "???" is returned.
    function f_yes_no
        (pi_val  in varchar2
        )
    return varchar2
    deterministic;
    function f_yes_no
        (pi_val  in pls_integer
        )
    return varchar2
    deterministic;

    -- -----------------------------------------------------------------------------------------------
    -- Public function returning a string "True" or "False" depending on the input.
    -- If not "True" or "False", then "???" is returned.
    function f_true_false
        (pi_val  in varchar2
        )
    return varchar2
    deterministic;
    function f_true_false
        (pi_val  in pls_integer
        )
    return varchar2
    deterministic;

    -- -----------------------------------------------------------------------------------------------
    -- Public function returning a string "Pass" or "Fail" depending on the input.
    -- If not "Pass" or "Fail", then "???" is returned.
    function f_pass_fail
        (pi_val  in varchar2
        )
    return varchar2
    deterministic;
    function f_pass_fail
        (pi_val  in pls_integer
        )
    return varchar2
    deterministic;

    -- -----------------------------------------------------------------------------------------------
    -- Public function returning a string "OK" or "Not OK" depending on the input.
    -- If not "OK" or "Not OK", then "???" is returned.
    function f_ok_not_ok
        (pi_val  in varchar2
        )
    return varchar2
    deterministic;

    -- -----------------------------------------------------------------------------------------------
    -- Public function returning a string "Success" or "Failed" depending on the input.
    -- If not "Success" or "Failed", then "???" is returned.
    function f_success_failed
        (pi_val  in varchar2
        )
    return varchar2
    deterministic;

    -- -----------------------------------------------------------------------------------------------
    -- Public function returning a string surounded with single quotes (apostrophes)
    -- If the passed pi_text is null, also NULL is returned.
    -- Because single quotes have a special function in Oracle SQL.
    function f_q1q
        (pi_text in varchar2
        )
    return varchar2
    deterministic;

    -- -----------------------------------------------------------------------------------------------
    -- Public function returning a string surounded with double quotes
    -- If the passed pi_text is null, also NULL is returned.
    -- Because double quotes have a special function in Oracle SQL.
    function f_q2q
        (pi_text in varchar2
        )
    return varchar2
    deterministic;

    -- -----------------------------------------------------------------------------------------------
    -- Public function returning a string of a max size.
    -- Parameters:
    -- - pi_base_chars = the base characters
    -- - pi_max        = maximum number of characters returned optionally after a not-NULL value of
    --                   pi_add_chars was concattenated. Default max = 32767
    --                   If pi_max < 0 then, the substring is taken starting at the end of the 
    --                   concattenation and the ellipsis is put at the begin.
    -- - pi_add_chars  = optional characters to be concattenated to pi_base_chars. NO space is 
    --                   inserted when concattenation is done. Also NO trim of white spaces.
    --                   Consider using the TRIMWS function.
    -- - pi_ellipsis   = optional characters places at the end of the returned string if the total
    --                   length would overflow (exceed the pi_max).
    --                   pi_ellipsis is limited to max 10 characters.
    function f_max_chars
        (pi_base_chars  in varchar2
        ,pi_max         in number   := 32767
        ,pi_add_chars   in varchar2 := null
        ,pi_ellipsis    in varchar2 := hmx_utl.k_ellipsis
        )
    return varchar2
    deterministic;

    -- ---------------------------------------------------------------------------------------------
    -- Public function that returns a hex dump of the first 8000 characters of the input.
    -- Non-printables are replaced by NCHR(183) = the middle dot.
    -- Example: hmx_utl.hex_dump('PLS-00103: Encountered the symbol "?" when expec');
    -- Returns:
    --     0001: 50 4c 53 2d 30 30 31 30 33 3a 20 45 6e 63 6f 75 = PLS-00103: Encou
    --     0017: 6e 74 65 72 65 64 20 74 68 65 20 73 79 6d 62 6f = ntered the symbo
    --     0033: 6c 20 22 3f 22 20 77 68 65 6e 20 65 78 70 65 63 = l "?" when expec
    function hex_dump
        (pi_text in varchar2
        )
    return varchar2
    deterministic;

end hmx_utl;
/

prompt *I: ScriptEOF hmx_utl.sql
