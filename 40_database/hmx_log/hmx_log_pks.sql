prompt *I: ScriptBOF hmx_log_pks.sql
create or replace package hmx_log
AUTHID CURRENT_USER
as
/* <hmx-annotations>

.HMX_OBJECT_USAGE: This package/script...

.HMX_OBJECT_NOTES:
Package must be invoker rights (AUTHID CURRENT_USER)
...

.HMX_DEVELOPER_NOTES: See HMX General Developer Notes
.HMX_OBJECT_VERSION: 2026-10-29 09:02:48 +01:00
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */-- package must be AUTHID CURRENT_USER

    -- Constants related to this package
    -- For pi_log_opt to control additional logging using bitwise value (BITAND)
    k_log_call_stack      constant number(1,0) := 1;
    k_log_error_backtrace constant number(1,0) := 2;
    k_add_cached_msg      constant number(1,0) := 4;
    k_force_logging       constant number(1,0) := 8;

    -- Public constants.
    -- Log message type, predefined constants
    -- INFO/TECH/FUNC, TRACE, DEVELOP, DEBUG, TESTING, AUDIT, SECURITY
    k_info        constant varchar2(8) := 'INFO';  -- default
    k_tech        constant varchar2(8) := 'TECH';
    k_func        constant varchar2(8) := 'FUNC';
    k_trace       constant varchar2(8) := 'TRACE';
    k_debug       constant varchar2(8) := 'DEBUG';
    k_develop     constant varchar2(8) := 'DEVELOP';
    k_testing     constant varchar2(8) := 'TESTING';
    k_auditing    constant varchar2(8) := 'AUDIT';
    k_security    constant varchar2(8) := 'SECURITY';
    k_logging     constant varchar2(8) := 'LOGGING';   -- internally hmx_log usage
    -- Log message level, predefined constants
    -- For Message Types TRACE and DEBUG the logged level will be negative and indicate at which the
    -- call stack level the log message was issued.
    k_no_level    constant number(2,0) :=  0; -- default
    k_cache       constant number(2,0) :=  5; -- cache the message i.s.o. immediately writing it to the log table
    k_normal      constant number(2,0) := 10;
    k_attention   constant number(2,0) := 15;
    k_warning     constant number(2,0) := 20;
    k_error       constant number(2,0) := 25; -- possible to recover/continue
    k_severe      constant number(2,0) := 30; -- more serious error that just an error
    k_critical    constant number(2,0) := 35; -- unrecoverable, abort processing
    k_force       constant number(2,0) := 99; -- just force log without any other reason
    -- Log message scope, predefined constants
    -- DEVELOPER, TESTER, ADMIN, OPERATIONS, USER, KEYUSER
    k_anyone      constant varchar2 (10) := 'ANYONE';  -- default
    k_developer   constant varchar2 (10) := 'DEVELOPER';
    k_tester      constant varchar2 (10) := 'TESTER';
    k_admin       constant varchar2 (10) := 'ADMIN';
    k_operations  constant varchar2 (10) := 'OPERATIONS';
    k_user        constant varchar2 (10) := 'USER';
    k_keyuser     constant varchar2 (10) := 'KEYUSER';

    -- Public constant functions so they can be used in queries.
    -- Log message type, predefined constants
    -- INFO/TECH/FUNC, TRACE, DEVELOP, DEBUG, TESTING, AUDIT, SECURITY
    function fk_info        return varchar2 deterministic;
    function fk_tech        return varchar2 deterministic;
    function fk_func        return varchar2 deterministic;
    function fk_trace       return varchar2 deterministic;
    function fk_debug       return varchar2 deterministic;
    function fk_develop     return varchar2 deterministic;
    function fk_testing     return varchar2 deterministic;
    function fk_auditing    return varchar2 deterministic;
    function fk_security    return varchar2 deterministic;
    function fk_logging     return varchar2 deterministic;
    -- Log message level, predefined constants
    -- For Message Types TRACE and DEBUG the logged level will be negative and indicate at which the
    -- call stack level the log message was issued.
    function fk_no_level    return number   deterministic;
    function fk_cache       return number   deterministic;
    function fk_normal      return number   deterministic;
    function fk_attention   return number   deterministic;
    function fk_warning     return number   deterministic;
    function fk_error       return number   deterministic;
    function fk_severe      return number   deterministic;
    function fk_critical    return number   deterministic;
    function fk_force       return number   deterministic;
    -- Log message scope, predefined constants
    -- DEVELOPER, TESTER, ADMIN, OPERATIONS, USER, KEYUSER
    function fk_anyone      return varchar2 deterministic;
    function fk_developer   return varchar2 deterministic;
    function fk_tester      return varchar2 deterministic;
    function fk_admin       return varchar2 deterministic;
    function fk_operations  return varchar2 deterministic;
    function fk_user        return varchar2 deterministic;
    function fk_keyuser     return varchar2 deterministic;

    -- ---------------------------------------------------------------------------------------------
    -- Public function returning the default name of a numeric log level
    function log_level_name
        (pi_log_level_num   in number)
    return varchar2
    deterministic;

    -- ---------------------------------------------------------------------------------------------
    -- Public function get the log level active in this session
    function get_minimum_log_level
    return number;

    -- ---------------------------------------------------------------------------------------------
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
        (pi_log_msg     in varchar2
        ,pi_log_level   in number   := fk_no_level
        ,pi_log_type    in varchar2 := fk_info
        ,pi_log_scope   in varchar2 := fk_anyone
        ,pi_log_tags    in varchar2 := null
        ,pi_log_opt     in number   := 0
        ,pi_object_type in varchar2 := null
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
        (pi_rate  in number := null)
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
    procedure cache_msg (pi_log_msg in varchar2);

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
        (pi_flush      in varchar2 := hmx_utl.k_no
        ,pi_max_length in number   := null
        )
    return varchar2;

    -- ---------------------------------------------------------------------------------------------
    -- Procedure that logs connection values
    procedure log_connection;

    -- ---------------------------------------------------------------------------------------------
    -- Public function that returns the object name and line number where this was called from.
    -- Parameters:
    -- - pi_log_pkid = Required, primary key of the HMX_LOG record where to return the object and
    --     line number.
    function get_called_from_formatted
        (pi_log_pkid in hmx_log_data.log_pkid%type
        )
    return varchar2;


end hmx_log;
/
prompt *I: ScriptEOF hmx_log_pks.sql
