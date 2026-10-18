prompt *I: ScriptBOF hmx_annotations_pks.sql
create or replace package hmx_annotations
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

    k_spec_version    constant varchar2(20) := '2026-10-18 16:42:50';

    -- ---------------------------------------------------------------------------------------------
    -- Public function returning all version information regarding this package
    function get_version_info
    return varchar2
    deterministic;

    -- ---------------------------------------------------------------------------------------------
    -- Public function that checks if a certain annotation exists. Input parameters are the 
    -- attributes that uniquely identify an annotation.
    -- Returned:
    -- - hmx_utl.k_byes   if the annotation exists
    -- - hmx_utl.k_bno    if the annotation does not exist, but the related object/column exists
    -- - hmx_utl.k_berror if the annotation does not exist AND the related object/column does not exist.
    function check_annotation_exists
        (pi_object_name      in varchar2                    -- max length 128
        ,pi_object_type      in varchar2                    -- max length 9
        ,pi_column_name      in varchar2 := hmx_utl.k_none  -- max length 128
        ,pi_domain_name      in varchar2 := hmx_utl.k_none  -- max length 128
        ,pi_domain_owner     in varchar2 := hmx_utl.k_none  -- max length 128
        ,pi_annotation_owner in varchar2                    -- max length 128
        ,pi_annotation_name  in varchar2                    -- max length 1024
        )
    return hmx_types.t_y_n_e;


end hmx_annotations;
/

prompt *I: ScriptEOF hmx_annotations_pks.sql
