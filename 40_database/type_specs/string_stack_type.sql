prompt *I: ScriptBOF string_stack_type.sql
create or replace type string_stack_type
authid current_user
as object
/* <hmx-annotations>

.HMX_OBJECT_USAGE: This type is a stack for maximum 50 entries of varchar2(4000) strings, including methods to maintain the entries.

.HMX_OBJECT_NOTES:
    Type is invoker rights (AUTHID CURRENT_USER)
    This Oracle Advanced Data type (ADT): a type with a body.
    Instantiate in a package same as a regular type.
    Multiple instances are possible, even in the same module.

.HMX_DEVELOPER_NOTES:
    See HMX General Developer Notes
    Using schema level type t_string_varray50
.HMX_OBJECT_VERSION: 2021-10-05 08:00:00 +02:00
.HMX_DB_VERSION: Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0
.HMX_OBJECT_REPO: git@github.com:HermanMol/FJ12a_HMX-dev.git

** </hmx-annotations> */

	(c_version        varchar2(10)
	,g_string_stack	  t_string_varray50		-- collect string data, log when exception occurs. see string_stack* methods in this package body
	-- ---------------------------------------------------------------------------------------------
	-- Public procedure to initialise the stack
	,member procedure init_stack
	-- ---------------------------------------------------------------------------------------------
	-- Public procedure to add a string to the stack
	,member procedure push (SELF IN OUT NOCOPY string_stack_type, pi_string in varchar2 )
	-- ---------------------------------------------------------------------------------------------
	-- Public function to get a specific entry from the stack (entry remains on the stack)
	-- pi_idx:
	-- - when null, zero or beyond last, then null is retrieved
	-- - when < zero, counted back from the last of the stack
	-- Choosen never to throw an exception SUBSCRIPT_BEYOND_COUNT.
	,member function get (SELF IN OUT NOCOPY string_stack_type, pi_idx in number := null) return varchar2
	-- ---------------------------------------------------------------------------------------------
	-- Public procedure to remove a specific entry from the stack
	-- pi_idx:
	-- - when null, zero or beyond last, then null is retrieved
	-- - when < zero, counted back from the last of the stack
	-- Choosen never to throw an exception SUBSCRIPT_BEYOND_COUNT.
	,member procedure remove (SELF IN OUT NOCOPY string_stack_type, pi_idx in number := null)
	-- ---------------------------------------------------------------------------------------------
	-- Public function to get a specific entry and remove it from the stack
	-- So in fact the get + remove.
	-- pi_idx:
	-- - when null, zero or beyond last, then null is retrieved
	-- - when < zero, counted back from the last of the stack
	-- Choosen never to throw an exception SUBSCRIPT_BEYOND_COUNT.
	,member function pop (SELF IN OUT NOCOPY string_stack_type, pi_idx in number := null) return varchar2
	-- ---------------------------------------------------------------------------------------------
	-- Public function to return maximum size of the stack
	,member function max_idx return number
	-- ---------------------------------------------------------------------------------------------
	-- Public function to return the index of the first entry
	-- Always 1 unless the stack is empty. I.s.o. null we return zero
	,member function first_idx return number
	-- ---------------------------------------------------------------------------------------------
	-- Public function to return the index of the last entry
	,member function last_idx return number
	-- ---------------------------------------------------------------------------------------------
	-- Public function to return all strings from the stack as a string
	,member function get_serialized return varchar2
	-- ---------------------------------------------------------------------------------------------
	-- Public function to return all strings from the stack pipelined
	,member function get_strings return t_string_varray50 pipelined
	-- ---------------------------------------------------------------------------------------------
	-- Constructor initialising the type instance
	,constructor function string_stack_type
		(self in out nocopy string_stack_type)
		return self as result
);
/
prompt *I: ScriptEOF string_stack_type.sql
