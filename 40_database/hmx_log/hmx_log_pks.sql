/* <hmx-annotations>


.HMX_OBJECT_USAGE: This package/script...

.HMX_OBJECT_NOTES:
    ?Package must be invoker rights (AUTHID CURRENT_USER)
    ...

.HMX_DEVELOPER_NOTES: See HMX General Developer Notes
.HMX_OBJECT_VERSION: 2026-10-22 10:58:08 +02:00
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */
prompt *I: ScriptBOF hmx_log_pks.sql
create or replace package hmx_log
AUTHID CURRENT_USER
as
-- package must be AUTHID CURRENT_USER
-- =================================================================================================
-- Project: e-CertNL
-- Purpose: e-CertNL Database Logger - public logging functionality
-- =================================================================================================

/* Wijzigingshistorie
|  versie   datum           auteur             reden
|  1        27-10-2023      HMO                USEC-5926 eDBLog sources Herman installeren
*/

/*                                        DEVELOPER NOTES
* * Naming convention used:
*   - the b[c|v|p|f|t]_ prefix stands for private Body [Constant|Variable|Procedure|Function|Type]
*   - when the name does not start with a b[c|v|p|f|t]_ prefix it can be assumed to be public
*     available (in the spec)
*   - method parameter prefixes: pi_* /po_* /pio_* resp. for IN / OUT / IN OUT parameters
*   - local variable, function or procedure prefixes: l_* / lf_* / lp_*
*/

  c_spec_version        constant varchar2(9)  := '20231112a';

  -- Constants related to this package
  -- Note: also see package GDBUTL
  c_no                  constant varchar2 (01) := 'N';
  c_yes                 constant varchar2 (01) := 'Y';

  -- For pi_log_opt to control additional logging using bitwise value (BITAND)
  c_log_call_stack      constant number(1,0) := 1;
  c_log_error_backtrace constant number(1,0) := 2;
  c_add_cached_msg      constant number(1,0) := 4;
  c_force_logging       constant number(1,0) := 8;

  -- Public constants implemented as functions so they can be used in queries.
  -- Log message type, predefined constants
  -- INFO/TECH/FUNC, TRACE, DEVELOP, DEBUG, TESTING, AUDIT, SECURITY
  function c_info        return varchar2 deterministic;  -- constant varchar2(8) := 'INFO';  -- default
  function c_tech        return varchar2 deterministic;  -- constant varchar2(8) := 'TECH';
  function c_func        return varchar2 deterministic;  -- constant varchar2(8) := 'FUNC';
  function c_trace       return varchar2 deterministic;  -- constant varchar2(8) := 'TRACE';
  function c_debug       return varchar2 deterministic;  -- constant varchar2(8) := 'DEBUG';
  function c_develop     return varchar2 deterministic;  -- constant varchar2(8) := 'DEVELOP';
  function c_testing     return varchar2 deterministic;  -- constant varchar2(8) := 'TESTING';
  function c_auditing    return varchar2 deterministic;  -- constant varchar2(8) := 'AUDIT';
  function c_security    return varchar2 deterministic;  -- constant varchar2(8) := 'SECURITY';
  function c_logging     return varchar2 deterministic;  -- constant varchar2(8) := 'LOGGING';   -- internally hmx_log usage
  -- Log message level, predefined constants
  -- For Message Types TRACE and DEBUG the logged level will be negative and indicate at which the
  -- call stack level the log message was issued.
  function c_no_level    return number   deterministic;  -- constant number :=  0; -- default
  function c_cache       return number   deterministic;  -- constant number :=  5; -- cache the message i.s.o. immediately writing it to the log table
  function c_normal      return number   deterministic;  -- constant number := 10;
  function c_attention   return number   deterministic;  -- constant number := 15;
  function c_warning     return number   deterministic;  -- constant number := 20;
  function c_error       return number   deterministic;  -- constant number := 25; -- possible to recover/continue
  function c_severe      return number   deterministic;  -- constant number := 30; -- more serious error that just an error
  function c_critical    return number   deterministic;  -- constant number := 35; -- unrecoverable, abort processing
  function c_force       return number   deterministic;  -- constant number := 99; -- just force log without any other reason
  -- Log message scope, predefined constants
  -- DEVELOPER, TESTER, ADMIN, OPERATIONS, USER, KEYUSER
  function c_anyone      return varchar2 deterministic;  -- constant varchar2 (10) := 'ANYONE';  -- default
  function c_developer   return varchar2 deterministic;  -- constant varchar2 (10) := 'DEVELOPER';
  function c_tester      return varchar2 deterministic;  -- constant varchar2 (10) := 'TESTER';
  function c_admin       return varchar2 deterministic;  -- constant varchar2 (10) := 'ADMIN';
  function c_operations  return varchar2 deterministic;  -- constant varchar2 (10) := 'OPERATIONS';
  function c_user        return varchar2 deterministic;  -- constant varchar2 (10) := 'USER';
  function c_keyuser     return varchar2 deterministic;  -- constant varchar2 (10) := 'KEYUSER';

  -- =============================================================================================
  -- Function that returns all version information regarding this package spec and body
  function get_version_info
  return varchar2
  deterministic;

  -- ---------------------------------------------------------------------------------------------
  -- Public function get the log level active in this session
  function get_minimum_log_level
  return number;

  -- -----------------------------------------------------------------------------------------------
  -- Public procedure set the log level active in this session
  procedure set_minimum_log_level
    (pi_log_level in number := null
    );

  -- ---------------------------------------------------------------------------------------------
  -- Get the tags
  function get_tags
  return varchar2;

  -- ---------------------------------------------------------------------------------------------
  -- Set the logging tags
  procedure set_tags
    (pi_tags  in varchar2
    );

  -- ---------------------------------------------------------------------------------------------
  -- Get the app_user
  function get_app_user
  return varchar2;

  -- ---------------------------------------------------------------------------------------------
  -- Set the app_user.
  -- For APEX this will always be the APP_USER unless pi_from_sys is set to false.
  -- For non-APEX this will be a value that is expected to be in the session CLIENT_INFO in a
  -- predefined format, also unless pi_from_sys is set to false.
  procedure set_app_user
    (pi_app_user in varchar2 := null
    ,pi_from_sys in boolean  := true
    );

  -- ---------------------------------------------------------------------------------------------
  -- Log the message
  -- All values SUBSTR-ed - better safe than sorry
  -- - pi_level = The severity level of the message: (default) 0=not_specified, 5-cache, 10=info,
  --              15=attention, 20=warning, 25=error, 30=severe, 35=critical
  --              For types TRACE and DEBUG a negative value indicates the execution level at
  --              which the message was issued. Unrestricted.
  -- - pi_type  = The type of message. Unrestricted but these are the predefined values:
  --              (default) INFO, TECH, FUNC, TRACE, DEVELOP, DEBUG, TESTING, AUDIT, SECURITY.
  -- - pi_scope = The scope of the message, Unrestricted but these are the predefined values:
  --              DEVELOPER, TESTER, ADMIN, OPERATIONS, USER, KEYUSER and (default) ANYONE.
  -- - pi_tags  = Free format for tags for logical grouping of messages, e.g. a test case
  --              reference or a REST message UID.
  -- - pi_log_opt: Logging options
  --    SQLCode | Force | Call_Stack | Error_Backtrace | Result      | Call_Stack | Error_Stack
  --    <>0     | *1    |    n/a     |    n/a          | log message | yes        | yes
  --    =0      | n/a   |    false   |    false        | log message | no         | no
  --    =0      | n/a   |    false   |    true         | log message | no         | yes
  --    =0      | n/a   |    true    |    false        | log message | yes        | no
  --    =0      | n/a   |    true    |    true         | log message | yes        | yes
  --  *1 = if force=true then will log even when the error is in this hmx_log-package itself, so
  --       this should not be used when called from another package.
  procedure log_msg
    (pi_msg     in varchar2
    ,pi_level   in number   := c_no_level
    ,pi_type    in varchar2 := c_info
    ,pi_scope   in varchar2 := c_anyone
    ,pi_tags    in varchar2 := null
    ,pi_log_opt in number   := 0
    );

  -- ---------------------------------------------------------------------------------------------
  -- Get the maximum logged messages per second
  -- When the process exceeds this number, ALL logging is suppressed
  function get_max_log_rate
  return number;

  -- ---------------------------------------------------------------------------------------------
  -- Set the maximum logged messages per second
  -- When the process exceeds this number, ALL logging is suppressed
  -- The returned number is the old value.
  -- Allowed values for p_rate: between 1 and 1000 (inclusive). When an
  -- invalid value is specified the default 50 messages / second is used.
  function set_max_log_rate
    (pi_rate  in number := 50)
  return number;

  -- ---------------------------------------------------------------------------------------------
  -- Get the current process_id
  function get_process_id
  return varchar2;

  -- ---------------------------------------------------------------------------------------------
  -- Generate and new process_id and return that value
  function new_process_id
  return varchar2;

  -- ---------------------------------------------------------------------------------------------
  -- Procedure to set the private process_id with a custom value
  -- Example: testrun_2023-05-15T14:52:22
  -- The (internal) process_id is automatically set to some GUID when this package is instantiated.
  procedure set_process_id
    (pi_process_id in varchar2);

  -- ---------------------------------------------------------------------------------------------
  -- Procedure to initialize the cached message stack.
  procedure clear_cached_msg;

  -- ---------------------------------------------------------------------------------------------
  -- Procedure to add a message to the message stack for possible later print
  procedure cache_msg (pi_msg in varchar2);

  -- ---------------------------------------------------------------------------------------------
  -- Function to retrieve all cached messages (separated by LF) in a string, maximum 32767 characters.
  -- pi_flush, when yes then the stack will be cleared after the messages have been retrieved.
  -- pi_max_length:
  -- - null    = no max, all is returned (max 32767 characters, default from start of the messages)
  -- - 0(zero) = NULL string is returned
  -- - >0      = maximum characters from begin (position 1) of the string of serialized cached messages
  -- - <0      = maximum characters from END of the string of serialized cached messages
  -- When the messages are truncated an ellipsis (...) is added in the begin or the end.
  function get_cached_msg
    (pi_flush      in varchar2 := c_no
    ,pi_max_length in number   := null
    )
  return varchar2;

  -- ---------------------------------------------------------------------------------------------
  -- Procedure that logs connection values
  procedure log_connection;

-- hmo?  -- ---------------------------------------------------------------------------------------------
-- hmo?  -- Procedure to set a log filter
-- hmo?  procedure set_filter
-- hmo?    (pi_field     in varchar2 := hmx_log_ctx_api.c_min_log_lvl
-- hmo?    ,pi_condition in varchar2
-- hmo?    ,pi_log_this  in boolean  := false
-- hmo?    );

end hmx_log;
/
prompt *I: ScriptEOF hmx_log_pks.sql
