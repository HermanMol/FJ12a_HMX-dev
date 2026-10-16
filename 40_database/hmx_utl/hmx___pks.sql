prompt *I: ScriptBOF hmx___pks.sql
create or replace package hmx_session
AUTHID CURRENT_USER
as

-- Package must be AUTHID CURRENT_USER

/*                                        DEVELOPER NOTES
* * Naming convention used:
*   - the b+[k|v|p|f|t|c]_ prefix stands for private Body 
*           [Konstant|Variable|Procedure|Function|Type|Cursor]
*   - when the name does not start with a b+[k|v|p|f|t|c]_ prefix it can be assumed to be public
*     available (in the spec)
*   - method parameter prefixes: pi_* /po_* /pio_* resp. for IN / OUT / IN OUT parameters
*   - local variable, function or procedure prefixes: l_* / lf_* / lp_*
*/


    k_spec_version    constant varchar2(20) := '2026-10-16 09:04:52';

    -- ---------------------------------------------------------------------------------------------
    -- Public function returning all version information regarding this package
    function get_version_info
    return varchar2
    deterministic;

end hmx_session;
/

prompt *I: ScriptEOF hmx___pks.sql
