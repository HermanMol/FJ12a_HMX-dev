# HMX General Developer Notes
This note describes the conventions used in the HMX domain.

## Naming convention used in the HMX domain

### Main conventions
    - Database object source file names
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
| trg | TRIGGER                 | Any trigger: table, logon, ddl-trigger, ... Or a script to create the trigger spec and trigger body in one call, then additionally suffxed with *\_install*. |
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
| g       | global           | Accessible from anywhere. Value can referenced and changed in other objects than it was defined. |
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

## HMX developer tools and utilities

### Tip: SQLPATH
Add the 80_tools\sql folder to your SQLPATH environment variable. Then all SQL command files in that 
folder are available for SQLcl.

#### Generate HMX-annotation block
- Generate the initial full HMX-annotation block with script `hmx_generate_annotation_block.sql`
    The output in DBMS_OUTPUT
- Generate the HMX object version line with script `hmx_generate_annotation_version_line.sql`
- ...

## Annotations
### Oracle Schema Annotations
Since Oracle database version 19 annotations can be specified for tables, table columns, views
view columns, materialized views, materialized view columns and indexes. For details see the Oracle 
database decumentation, e.g. for version 19:

   - the [Oracle Database Database Concepts](https://docs.oracle.com/en/database/oracle/oracle-database/19/cncpt/application-data-usage.html) document, the section about "Schema Annotations" 
   - the [Oracle Database Database Development Guide](https://docs.oracle.com/en/database/oracle/oracle-database/19/adfns/registering-application-data-usage-database.html), the section about "Schema Annotations" 
   - The [Oracle SQL Language Reference](https://docs.oracle.com/en/database/oracle/oracle-database/19/sqlrf/annotations_clause.html) the paragraph "annotations_clause".

### HMX-annotations
The Oracle Schema Annotations are available for a limited selection of database object types. In order
to be able to specify Schema Annotation-like information for not-Oracle Schema Annotation supported 
database types, the HMX-annotations have been defined. 

The HMX-annotations are implemented as regular multiple line comments. Example, the default block template:

```
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
```
   - The HMX-annotation block is started with `/* <hmx-annotations>` on a line starting in column 1 and ends with `** </hmx-annotations> */`  on a line starting in column 1.
   - Each HMX-annotation starts at the begin of the line, the annotation name starting at column 1 with `.HMX_`-prefix and stops before the colon `:`.
   - Preferably the annotation name and value are on the same line, but multi-line values are allowed.
   - Multi-line annotation values start on the line immediately after the line containing the annotation name and end either when a new annotation name 
     starts, or when the annotation block ends.

A view is available to show all annotations: `select * from hmx_all_annotations`. This view lists the Oracle Schema Annotations and the HMX-annotations.

### Annotation names used in HMX
The annotation names used in HMX are:

| Annotation name     | Description |
|:--------------------|:------------|
| HMX_COLUMN_NOTES    | Details about the column. |
| HMX_COLUMN_SEQUENCE | The value only states either the sequence name used for the primary key, or `GENERATED IDENTITY`.|
| HMX_COLUMN_USAGE    | A simple one-liner describing the intended use of the column. |
| HMX_DB_VERSION      | This is generated by `select replace (banner_full,chr(10),' ') as db_banner_full from v$version`. Example: `Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production Version 19.33.0.1.0` |
| HMX_DEVELOPER_NOTES | Any notes that could be of interest for the developer. By default always refering to this document with "See HMX General Developer Notes". |
| HMX_OBJECT_NOTES    | Details about the object. |
| HMX_OBJECT_REPO     | The (git) repository where the object source is kept. Example: `git@github.com:HermanMol/FJ12a_HMX-dev.git` |
| HMX_OBJECT_USAGE    | A simple one-liner describing the intended use of the object. |
| HMX_OBJECT_VERSION  | The version of the object, a timestamp with timezone in the format `2026-10-22 15:55:35 +02:00`. This code can be generated by `select to_char(current_timestamp,'yyyy-mm-dd hh24:mi:ss TZH:TZM') as vsn from dual;`.  The value can be converted to UTC with `select sys_extract_utc(to_timestamp_tz('2026-10-22 15:55:35 +02:00','yyyy-mm-dd hh24:mi:ss TZH:TZM')) as hmx_version_utc from dual;` to compare with other versions.|

## Testing HMX objects
For most of the HMX objects and methods test scripts are available. 

Example:
- package HMX_UTL
- Test script: hmx_utl_pkg_tests.sql
- Output is in a spoolfile.
- Output includes the tested HMX-UTL version and other environment info.

## Appendix

### Page specifics

| Date       | Author  | Description         |
|:----------:|:-------:|:--------------------|
| 2026-10-28 | H.Mol   | Few little fixes    |
| 2026-10-19 | H.Mol   | New                 |
| "          | "     | Using [MarkDown](https://daringfireball.net/projects/markdown/syntax) and [CommonMark](https://commonmark.org/) |