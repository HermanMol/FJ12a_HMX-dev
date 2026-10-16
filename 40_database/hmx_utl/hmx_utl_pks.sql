prompt *I: ScriptBOF hmx_utl.sql
create or replace package hmx_utl
as

-- Package with functions that are the base for OPERATORS

    k_spec_version    constant varchar2(20) := '2026-10-15 15:15:10';

    subtype t_string_type   is varchar2(32767);
    type    t_strings_type  is table of t_string_type;

    k_no          constant varchar2(1) := 'N';
    k_yes         constant varchar2(1) := 'Y';
    k_fail        constant varchar2(1) := 'F';
    k_pass        constant varchar2(1) := 'P';
    k_nok         constant varchar2(1) := 'n';
    k_ok          constant varchar2(1) := 'o';
    k_failed      constant varchar2(1) := 'f';
    k_success     constant varchar2(1) := 's';
    k_ellipsis    constant varchar2(1) := '...';
    --                                          Special ASCII characters
    k_lf          constant varchar2(1) := chr(10);   -- ASCII Line Feed
    k_cr          constant varchar2(1) := chr(13);   -- ASCII Carriage Return
    k_crlf        constant varchar2(1) := k_cr || k_lf;
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

    -- other constants
    k_case_sensitive    constant varchar2(1) := 'C';
    k_case_insensitive  constant varchar2(1) := 'I';

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

    function fk_case_sensitive   return varchar2 deterministic;
    function fk_case_insensitive return varchar2 deterministic;

    -- ---------------------------------------------------------------------------------------------
    -- Public function returning all version information regarding this package
    function get_version_info
    return varchar2
    deterministic;

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
    -- arguments are NULL. Return 0 is the arguments differ. Return -1 if an error occurred.
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
    function to_num_val
        (pi_value   in varchar2
        )
    return number
    deterministic;

end hmx_utl;
/

prompt *I: ScriptEOF hmx_utl.sql
