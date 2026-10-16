prompt *I: ScriptBOF hmx_utl_pkb.sql
create or replace package body hmx_utl
as

    k_body_version varchar2(20) := '2026-10-15 15:14:58';

    -- Public constants implemented as deterministic functions so they can be used in queries
    function fk_no          return varchar2 deterministic is begin return k_no;         end;
    function fk_yes         return varchar2 deterministic is begin return k_yes;        end;
    function fk_fail        return varchar2 deterministic is begin return k_fail;       end;
    function fk_pass        return varchar2 deterministic is begin return k_pass;       end;
    function fk_nok         return varchar2 deterministic is begin return k_nok;        end;
    function fk_ok          return varchar2 deterministic is begin return k_ok;         end;
    function fk_failed      return varchar2 deterministic is begin return k_failed;     end;
    function fk_success     return varchar2 deterministic is begin return k_success;    end;
    function fk_ellipsis    return varchar2 deterministic is begin return k_ellipsis;   end;
    --                                                                                   Special ASCII characters
    function fk_lf          return varchar2 deterministic is begin return k_lf;         end;   -- ASCII Line Feed
    function fk_cr          return varchar2 deterministic is begin return k_cr;         end;   -- ASCII Carriage Return
    function fk_crlf        return varchar2 deterministic is begin return k_cr || k_lf; end;
    --
    function fk_sp          return varchar2 deterministic is begin return k_sp;         end;   -- ASCII Space
    function fk_tab         return varchar2 deterministic is begin return k_tab;        end;   -- ASCII TAB
    function fk_2q          return varchar2 deterministic is begin return k_2q;         end;   -- ASCII double quote
    function fk_1q          return varchar2 deterministic is begin return k_1q;         end;   -- ASCII single quote
    function fk_bq          return varchar2 deterministic is begin return k_bq;         end;   -- ASCII back quote
    function fk_amp         return varchar2 deterministic is begin return k_amp;        end;   -- ASCII ampersand
    function fk_at          return varchar2 deterministic is begin return k_at;         end;   -- ASCII @
    function fk_pct         return varchar2 deterministic is begin return k_pct;        end;   -- ASCII percent
    --
    function fk_us          return varchar2 deterministic is begin return k_us;         end;   -- ASCII Unit Separator
    function fk_gs          return varchar2 deterministic is begin return k_gs;         end;   -- ASCII Group Separator
    function fk_rs          return varchar2 deterministic is begin return k_rs;         end;   -- ASCII Record Separator
    function fk_fs          return varchar2 deterministic is begin return k_fs;         end;   -- ASCII File Separator
    --
    function fk_ack         return varchar2 deterministic is begin return k_ack;        end;   -- ASCII Acknowledgment
    function fk_nak         return varchar2 deterministic is begin return k_nak;        end;   -- ASCII Negative Acknowledgment

    -- other constants
    function fk_case_sensitive    return varchar2 deterministic is begin return k_case_sensitive  ; end;
    function fk_case_insensitive  return varchar2 deterministic is begin return k_case_insensitive; end;

    -- ---------------------------------------------------------------------------------------------
    -- Public function returning all version information regarding this package
    function get_version_info
    return varchar2
    deterministic
    as
    begin
        return 'Package ' || $$plsql_unit || ' version' || ': Spec='  || k_spec_version || ', Body='  || k_body_version;
    end get_version_info;

    -- ---------------------------------------------------------------------------------------------
    -- Function to return the received character value or 'nill'
    -- Overloaded for character, date, number or boolean
    function nvlc
        (pi_cvalue  in varchar2
        ,pi_ifnull  in varchar2
        )
    return varchar2
    deterministic
    as
    begin
        return coalesce(pi_cvalue,pi_ifnull,'nill');
    end nvlc;
    function nvlc
        (pi_cvalue in varchar2
        )
    return varchar2
    deterministic
    as
    begin
        return nvlc(pi_cvalue,to_char(NULL));
    end nvlc;
    -- ---------------------------------------------------------------------------------------------
    -- Function to return the received date value as a character or 'nill'
    -- Overloaded for character, date, number or boolean
    function nvlc
        (pi_dvalue  in date
        ,pi_ifnull  in varchar2
        )
    return varchar2
    deterministic
    as
    begin
        if pi_dvalue is null
        then
            return nvl(pi_ifnull,'nill');
        end if;
        return to_char(pi_dvalue,'yyyy-mm-dd"T"hh24:mi:ss');
    exception
        when others
        then
            return 'NaD';
    end nvlc;
    function nvlc
        (pi_dvalue in date
        )
    return varchar2
    deterministic
    as
    begin
        return nvlc(pi_dvalue,to_char(NULL));
    end nvlc;
    -- ---------------------------------------------------------------------------------------------
    -- Function to return the received number value as a character or 'nill'
    -- Overloaded for character, date, number or boolean
    function nvlc
        (pi_nvalue  in number
        ,pi_ifnull  in varchar2
        )
    return varchar2
    deterministic
    as
    begin
        if pi_nvalue is null
        then
            return nvl(pi_ifnull,'nill');
        end if;
        return to_char(pi_nvalue);
    exception
        when others
        then
            return 'NaN';
    end nvlc;
    function nvlc
        (pi_nvalue in number
        )
    return varchar2
    deterministic
    as
    begin
        return nvlc(pi_nvalue,to_char(NULL));
    end nvlc;
    -- ---------------------------------------------------------------------------------------------
    -- Function to return the received boolean value as a character or 'nill'
    -- Overloaded for character, date, number or boolean
    function nvlc
        (pi_bvalue  in boolean
        ,pi_ifnull  in varchar2
        )
    return varchar2
    deterministic
    as
    begin
        if pi_bvalue is null
        then
            return nvl(pi_ifnull,'nill');
        end if;
        if pi_bvalue
        then
            return 'TRUE';
        end if;
            return 'FALSE';
    exception
        when others
        then
            return 'NaB';
    end nvlc;
    function nvlc
        (pi_bvalue in boolean
        )
    return varchar2
    deterministic
    as
    begin
        return nvlc(pi_bvalue,to_char(NULL));
    end nvlc;

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
    deterministic
    as
        l_case_sensitive varchar2(1);
    begin
        l_case_sensitive := upper(substr(pi_case,1,1));
        if l_case_sensitive not in (k_case_sensitive, k_case_insensitive)
        then
            -- use package public constants k_case_sensitive/k_case_insensitive
            return -2;  -- indicates a wrong case (in)sensitive argument. Must be c/C/i/I.
        end if;
        if  pi_char1 is null
        and pi_char2 is null
        then
            return 1;
        end if;
        if l_case_sensitive = k_case_sensitive
        then
            if pi_char1 = pi_char2
            then
                return 1;
            end if;
        else   -- case INSENSITIVE
            if upper(pi_char1) = upper(pi_char2)
            then
                return 1;
            end if;
        end if;
        return 0;
    exception
        when others
        then
            return -1;
    end is_equal;  -- varchar2-s, option case sensitive
    -- Overload for character data, with default case insensitive
    -- Also available as a SQL Operator IS_EQUAL which can be used in a SQL query (only!)
    function is_equal
        (pi_char1 in varchar2
        ,pi_char2 in varchar2
        )
    return number
    deterministic
    as
    begin
        return is_equal(pi_char1 , pi_char2, k_case_insensitive);
    end is_equal;  -- varchar2-s, default case insensitive
    -- Overload for numeric data.
    -- Also available as a SQL Operator IS_EQUAL which can be used in a SQL query (only!)
    function is_equal
        (pi_num1 in number
        ,pi_num2 in number
        )
    return number
    deterministic
    as
    begin
        if  pi_num1 is null
        and pi_num2 is null
        then
            return 'TRUE';
        elsif pi_num1 = pi_num2
        then
            return 'TRUE';
        end if;
        return 'FALSE';
    exception
        when others
        then
            return -1;
    end is_equal;  -- numbers
    -- Overload for date+time data.
    -- Also available as a SQL Operator IS_EQUAL which can be used in a SQL query (only!)
    function is_equal
        (pi_date1 in date
        ,pi_date2 in date
        )
    return number
    deterministic
    as
    begin
        if   pi_date1 is null
        and pi_date2 is null
        then
            return 'TRUE';
        elsif pi_date1 = pi_date2
        then
            return 'TRUE';
        end if;
            return 'FALSE';
    exception
        when others
        then
            return -1;
    end is_equal;  -- dates

    -- ---------------------------------------------------------------------------------------------
    -- Function that removes ALL leading and trailing whitespace (tab, cr, lf, space...)
    -- Also available as a SQL Operator TRIMWS which can be used in a SQL query (only!)
    function trimws (pi_string in varchar2)
    return varchar2
    deterministic
    as
    begin
        return regexp_replace(pi_string,'^\s*|\s*$');
    end trimws;


    -- -----------------------------------------------------------------------------------------------
    -- Public function to try to convert a character value to a number.
    -- When this is not possible NULL is returned, NO exception is raised (it is ignored)
    -- When a null value is passed also a NULL is returned (garbage-in, garbage-out)
    -- Also available as a SQL Operator TO_NUM_VAL which can be used in a SQL query (only!)
    function to_num_val
        (pi_value   in varchar2
        )
    return number
    deterministic
    as
    begin
        return to_number(pi_value);
    exception
        when others
        then
            if sqlcode in ( -01722, -6502 )
            then
                return to_number(null);
            else
                raise;  -- already some other thing?
            end if;
    end to_num_val;

-- -------------------------------------------------------------------------------------------------
-- package constructor
begin
  null;
--  dbms_output.enable(null);
--  dbms_output.put_line('*X: ' || $$PLSQL_UNIT || '.CONSTRUCTOR#1:'

end hmx_utl;
/

prompt *I: ScriptEOF hmx_utl_pkb.sql
