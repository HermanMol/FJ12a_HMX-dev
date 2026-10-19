# HMX General Developer Notes
This note describes the conventions used in the HMX domain.

## Naming convention used in the HMX domain

### Main conventions
    - database object source file names
        - Always _all_ lowercase
        - Always extension .sql
        - Start with the object name
        - End with a 3-character type abbreviation. 
          See the HMX database object type abbreviations list (see below)
        - Example: `hmx_call_stack_pkb.sql` is the source file of the HMX_CALL_STACK package body.
        - Example: `hmx_call_stack_pkg_install.sql` is installation for the HMX_CALL_STACK package spec and body.
    - Prefixes used in sources: See HMX prefixes used in source files (below)

### HMX database object type abbreviations
In the HMX domain, next abbreviations are used in source file names for the database (schema level) object types.

| HMX Abbr. | Oracle DDL type | HMX notes |
|:--- |:--- |:--- |
| adn | ATTRIBUTE DIMENSION     | - |
| atn | ANNOTATION              | - |
| avw | ANALYTIC VIEW           | - |
| cgp | CONSUMER GROUP          | - |
| csr | CLUSTER                 | - |
| ctx | CONTEXT                 | - |
| dir | DIRECTORY               | - |
| dlk | DATABASE LINK           | - |
| dsn | DESTINATION             | - |
| ecx | EVALUATION CONTEXT      | - |
| edn | EDITION                 | - |
| fcn | FUNCTION                | - |
| hry | HIERARCHY               | - |
| idx | INDEX                   | - |
| ixp | INDEX PARTITION         | - |
| ixt | INDEXTYPE               | - |
| jbc | JOB CLASS               | - |
| job | JOB                     | DBMS_SCHEDULER |
| jsc | SCHEDULE                | DBMS_SCHEDULER |
| jsg | SCHEDULER GROUP         | DBMS_SCHEDULER |
| lbp | LOB PARTITION           | - |
| lib | LIBRARY                 | - |
| lob | LOB                     | - |
| mvw | MATERIALIZED VIEW       | - |
| opr | OPERATOR                | - |
| pgm | PROGRAM                 | - |
| pkb | PACKAGE BODY            | - |
| pkg | -                       | Package without a package body. Or a script to create the package spec and package body in one call, then additionally suffxed with *\_install*. |
| pks | PACKAGE                 | Package specification when there is also a package body |
| prc | PROCEDURE               | - |
| que | QUEUE                   | - |
| rle | RULE                    | - |
| rls | RULE SET                | - |
| rpn | RESOURCE PLAN           | - |
| seq | SEQUENCE                | - |
| stp | SQL TRANSLATION PROFILE | - |
| svw | VIEW                    | Simple (standard) view |
| syn | SYNONYM                 | - |
| tbl | TABLE                   | - |
| tbp | TABLE PARTITION         | - |
| tpb | TYPE BODY               | The type body|
| tps | TYPE                    | Type specification when there is also a type body (so-called "Advanced Data Type" - ADT) |
| trg | TRIGGER                 | Any trigger: table, logon, ddl-trigger, ... or a script to create the trigger spec and trigger body in one call, then additionally suffxed with *\_install*. |
| tsp | TABLE SUBPARTITION      | - |
| typ | TYPE                    | A (simple) type when there is NO type body |
| uap | UNIFIED AUDIT POLICY    | - |
| ufd | UNDEFINED               | - |
| usr | -                       | User creation scripts |
| wdw | WINDOW                  | - |

### HMX prefixes used in source files
In the HMX domain next prefixes are used in source files:

| HMX prefix | Meaning       | Notes |
|:------- |:--------------   |:---   |
| l       | local            | Inside a function or procedure. |
| g       | global           | Accessible from anywhere. Could be changed in other objects than it was defined. |
| s       | self, script     | Accessible only in the object/script, not-public. |
| (none)  | assumed global   | Preferred to use the g (global) prefix to emphasize public access. |
|         |                  |
| **Related to a type**  |
| c       | cursor             | - |
| k       | constant           | - |
| pi      | input parameter    | For functions and procedures |
| po      | output parameter   | For functions and procedures |
| pio     | in/out parameter   | For procedures. Functions only have the return value, **never** an output parameter. |
| ci      | input parameter    | For cursors |
| ix      | index              | For loops, when the index is not separately defined: the index is only accessible inside the scope of the itteration |
| exn     | exception          | See HMX exception definitions below. |
| exv     | exception value    | The numeric value used in the exception. This can then be used in the RAISE_APPLICATION_ERROR call to raise the exn exception. |
| rec     | record             | A structure consisting of multiple attributes (fields) |     
| arr     | array              | A Variable-size Array (VARRAY), Associative Array or Nested Table. Also known as collection |

### HMX exception definitions
```
    (...)
    
    exv_unknown number := -20001;
    exn_unknown exception;
    pragma exception_init(exn_unknown, -20001); -- = exv_unknown
    
    (...)
    
    raise_application_error(exv_unknown, 'The requested item ' || l_item_name || ' is unknown.', true);
    
    (...)
    
    exception
        when exn_unknown
        then
            dbms_output(....);
    (...)
```

## Appendix

### Page specifics

| Date       | Author  | Description         |
|:----------:|:-------:|:--------------------|
| 2026-10-19 | H.Mol   | New                 |
| "          | "     | Using [MarkDown](https://daringfireball.net/projects/markdown/syntax) and [CommonMark](https://commonmark.org/) |