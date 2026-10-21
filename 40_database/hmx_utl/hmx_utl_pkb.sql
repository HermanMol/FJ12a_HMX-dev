prompt *I: ScriptBOF hmx_utl_pkb.sql
create or replace package body hmx_utl
as
/* <hmx-annotations>

.HMX_OBJECT_USAGE: Package with constants and smart functions, some used in OPERATORS

.HMX_OBJECT_NOTES: -

.HMX_DEVELOPER_NOTES: 
    - See HMX General Developer Notes
    - Some functions are used in schema level operators. See hmx_operators_opr.sql

.HMX_OBJECT_VERSION: 2026-10-21 12:17:12 CEST
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */

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

    -- for use with hmx_types.t_bool
    function fk_bno         return pls_integer deterministic is begin return 0 ;        end;
    function fk_byes        return pls_integer deterministic is begin return 1 ;        end;
    function fk_bfalse      return pls_integer deterministic is begin return 0 ;        end;
    function fk_btrue       return pls_integer deterministic is begin return 1 ;        end;
    function fk_bfail       return pls_integer deterministic is begin return 0 ;        end;
    function fk_bpass       return pls_integer deterministic is begin return 1 ;        end;
    function fk_berror      return pls_integer deterministic is begin return -1;        end;

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
    function fk_none        return varchar2 deterministic is begin return k_none;       end;   -- ASCII Del

    -- other constants
    function fk_case_sensitive    return varchar2 deterministic is begin return k_case_sensitive  ; end;
    function fk_case_insensitive  return varchar2 deterministic is begin return k_case_insensitive; end;

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
        gdblog.log_msg('*D: ' || hmx_call_stack.get_called_from);

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
            gdblog.log_msg('*E: chr3 - ' || sqlerrm);
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
        gdblog.log_msg('*D: ' || hmx_call_stack.get_called_from);
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
        gdblog.log_msg('*D: ' || hmx_call_stack.get_called_from);
        if  pi_num1 is null
        and pi_num2 is null
        then
            return 1;
        elsif pi_num1 = pi_num2
        then
            return 1;
        end if;
        return 0;
    exception
        when others
        then
            gdblog.log_msg('*E: num - ' || sqlerrm);
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
        gdblog.log_msg('*D: ' || hmx_call_stack.get_called_from);
        if   pi_date1 is null
        and pi_date2 is null
        then
            return 1;
        elsif pi_date1 = pi_date2
        then
            return 1;
        end if;
        return 0;
    exception
        when others
        then
            gdblog.log_msg('*E: date - ' || sqlerrm);
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

    -- -----------------------------------------------------------------------------------------------
    -- Public function returning a string "Yes" or "No" depending on the input.
    -- If not "Yes" or "No", then "???" is returned.
    function f_yes_no
        (i_val  in varchar2)
    return varchar2
    deterministic
    as
    begin
        return case i_val
                when k_no  then 'No'
                when k_yes then 'Yes'
                else '???'
                end;
    end f_yes_no;
    -- overload for numeric boolean
    function f_yes_no
                (i_val  in pls_integer)
    return varchar2
    deterministic
    as
    begin
        return case i_val
                when k_bno  then 'No'
                when k_byes then 'Yes'
                else '???'
                end;
    end f_yes_no;

    -- -----------------------------------------------------------------------------------------------
    -- Public function returning a string "True" or "False" depending on the input.
    -- If not "True" or "False", then "???" is returned.
    function f_true_false
        (i_val  in varchar2)
    return varchar2
    deterministic
    as
    begin
        return case i_val
                when k_true  then 'True'
                when k_false then 'False'
                else '???'
                end;
    end f_true_false;
    -- overload for numeric boolean
    function f_true_false
        (i_val  in pls_integer)
    return varchar2
    deterministic
    as
    begin
        return case i_val
                when k_btrue  then 'True'
                when k_bfalse then 'False'
                else '???'
                end;
    end f_true_false;

    -- -----------------------------------------------------------------------------------------------
    -- Public function returning a string "Pass" or "Fail" depending on the input.
    -- If not "Pass" or "Fail", then "???" is returned.
    function f_pass_fail
        (i_val  in varchar2)
    return varchar2
    deterministic
    as
    begin
        return case i_val
                when k_pass then 'Pass'
                when k_fail then 'Fail'
                else '???'
                end;
    end f_pass_fail;
    -- overload for numeric boolean
    function f_pass_fail
        (i_val  in pls_integer)
    return varchar2
    deterministic
    as
    begin
        return case i_val
                when k_bpass then 'Pass'
                when k_bfail then 'Fail'
                else '???'
                end;
    end f_pass_fail;

    -- -----------------------------------------------------------------------------------------------
    -- Public function returning a string "OK" or "Not OK" depending on the input.
    -- If not "OK" or "Not OK", then "???" is returned.
    function f_ok_not_ok
        (i_val  in varchar2)
    return varchar2
    deterministic
    as
    begin
        return case i_val
                when k_ok  then 'OK'
                when k_nok then 'Not OK'
                else '???'
                end;
    end f_ok_not_ok;

    -- -----------------------------------------------------------------------------------------------
    -- Public function returning a string "Success" or "Failed" depending on the input.
    -- If not "Success" or "Failed", then "???" is returned.
    function f_success_failed
        (i_val  in varchar2)
    return varchar2
    deterministic
    as
    begin
        return case i_val
                when k_success then 'Success'
                when k_failed  then 'Failed'
                else '???'
                end;
    end f_success_failed;

    -- -----------------------------------------------------------------------------------------------
    -- Public function returning a string surounded with single quotes (apostrophes)
    -- If the passed pi_text is null, also NULL is returned.
    -- Because single quotes have a special function in Oracle SQL.
    function f_q1q
        (pi_text in varchar2)
    return varchar2
    deterministic
    as
    begin
        if pi_text is null
        then
            return to_char(null);
        end if;
        return k_1q || pi_text || k_1q;
    end f_q1q;

    -- -----------------------------------------------------------------------------------------------
    -- Public function returning a string surounded with double quotes
    -- If the passed pi_text is null, also NULL is returned.
    -- Because double quotes have a special function in Oracle SQL.
    function f_q2q
        (pi_text in varchar2)
    return varchar2
    deterministic
    as
    begin
        if pi_text is null
        then
            return to_char(null);
        end if;
        return k_2q || pi_text || k_2q;
    end f_q2q;

-- -------------------------------------------------------------------------------------------------
-- package constructor
begin
  null;
--  dbms_output.enable(null);
--  dbms_output.put_line('*X: ' || $$PLSQL_UNIT || '.CONSTRUCTOR#1:'

end hmx_utl;
/

prompt *I: ScriptEOF hmx_utl_pkb.sql
