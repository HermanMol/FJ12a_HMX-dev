# Oracle SQLcl Users Guide

    Date: 2026-10-30 08:15:23
    Document: oracle-sqlcl-users-guide_26_03.pdf
    Version: Release 26.3 | G62131-02 | September 2026
    Author(this): Herman Mol

----

# Environment: 
- Directory = H:\20_projects\FJ12a_HMX-dev\44_project\!about_44_project.txt
- 

# Project command

## Create project

```
SQLcl> project init -name hmol_hmx -schemas hmol -d /workspace/ -con tdq02cei7gikc7j5_medium
or
SQLcl> project init -name hmol_ws02 -schemas hmol -con tdq02cei7gikc7j5_medium
```
Generates project tree:
```
    H:.
    +---workspace
        +---.dbtools
        ¦   +---filters
        +---dist
        +---src
            +---database
                +---admin
                ¦   +---object_grants
                +---hmol
                ¦   +---comments
                ¦   +---object_grants
                ¦   +---package_bodies
                ¦   +---package_specs
                ¦   +---procedures
                ¦   +---ref_constraints
                ¦   +---sequences
                ¦   +---synonyms
                ¦   +---tables
                ¦   +---triggers
                ¦   +---type_bodies
                ¦   +---type_specs
                ¦   +---views
                +---ut3
                    +---object_grants
```

### Interesting

Project "home" ( ~\ ) = H:\20_projects\FJ12a_HMX-dev\44_project_

- ~\workspace\.dbtools\project.config.json
    <br>configuration for the project
- ~\workspace\.dbtools\project.sqlformat.xml
    <br>SQL formatting rules

### Step into the project
```
SQLcl> cd workspace
```
## Export the database contents (of one schema?)

```
SQLcl> project export -schemas hmol
```
... has exported the whole HMOL schema plus the grants to HMOL in other schema's.
<br>Probably the filters what to export is in ~\.dbtools\filters\ddl.filters

```
SQLcl> proj cfg -li
```

__Result:__

 | SETTING NAME                           | VALUE                             |
 |:--- |:---|
 | project                                | hmol_hmx                          |
 | sqlcl.connectionName                   | tdq02cei7gikc7j5_medium           |
 | sqlcl.autoConnect                      | false                             |
 | sqlcl.version                          | 26.3.0.0                          |
 | schemas                                | ["HMOL"]                          |
 | lastReleaseVersion                     |                                   |
 | apex.apexlang                          | false                             |
 | dml                                    | false                             |
 | export.format.enable                   | true                              |
 | export.setTransform.collationClause    | NEVER                             |
 | export.setTransform.constraints        | true                              |
 | export.setTransform.constraintsAsAlter | true                              |
 | export.setTransform.emitSchema         | true                              |
 | export.setTransform.force              | true                              |
 | export.setTransform.partitioning       | false                             |
 | export.setTransform.segmentAttributes  | false                             |
 | export.setTransform.sizeByteKeyword    | true                              |
 | export.setTransform.sqlterminator      | true                              |
 | export.setTransform.storage            | false                             |
 | export.setTransform.tablespace         | false                             |
 | export.apex.exptype                    | ["APEXLANG","APPLICATION_SOURCE"] |
 | export.apex.expAclAssignments          | false                             |
 | export.apex.expComments                | false                             |
 | export.apex.skipExportDate             | true                              |
 | export.apex.expirNotif                 | false                             |
 | export.apex.expOriginalIds             | false                             |
 | export.apex.expSavedReports            | false                             |
 | export.apex.expPubReports              | true                              |
 | export.apex.expSubscriptions           | false                             |
 | export.apex.expSupportingObjects       | N                                 |
 | export.apex.expTranslations            | false                             |
 | export.apex.auditType                  | NULL                              |
 | git.protectedBranches                  | ["main","master"]                 |
 | git.defaultBranch                      | main                              |
 | stage.excludeObjects                   | ["ALL.user"]                      |
 | stage.generatedFormat                  | liquibase                         |
 | stage.softObjectIsolation              | change                            |
 | stage.substituteSchemas                | false                             |

----

## Example workflow git & SQLcl

Line prefixes used:
- remote = GitHub
- local  = on your PC or laptop
- SQLcl  = local in a SQLcl session
- DB     = in the database e.g. using Oracle SQL Developer or VScode with the SqlDev extension.
- \#      = comments

__Steps:__

1. remote: Create a new repository, e.g.: FJ30a_CICD
1. local : cd to where you want to work 
1. local : mkdir ws03
1. local : cd ws03
1. local : git clone git@github.com:HermanMol/FJ30a_CICD.git 
1. local : start SQLcl: oci1 hmol
<br># I use a batchfile with all connection stuff and only the user (developer, initial schema) as argument
1. SQLcl : project init -name hmol_ws03 -schemas hmol -con tdq02cei7gikc7j5_medium
1. SQLcl : project export -schemas hmol
1. SQLcl : exit
1. local : git pull
1. local : git add --all
1. local : git commit -m "initial_ws03"
1. local : git push <br># Local, DB and remote are now on branch main and are in sync.
1. remote: Create new branch, e.g.: _ws03-b001_
1. local : git pull <br># New branch _ws03-b001_ is now on local
1. local : git checkout _ws03-b001_ <br># Now on the new branch
1. DB    : Make a change to an object. <br># For this example changing package spec HMX_ANNOTATIONS 
1. local : Be shure you are in the ws03 folder where you cloned the repo en exported the DB project
1. SQLcl : project export -schemas hmol <br># Exports all from the DB; changes source on local
1. SQLcl : !git add --all
1. SQLcl : !git commit -m "Changes 30-10-2026 for testing SQLcl project with git on OCI"
1. SQLcl : project stage <br># New files:
<br># - ~\ws03\dist
<br># - ~\ws03\dist\env
<br># - ~\ws03\dist\env\default.properties
<br># - ~\ws03\dist\install.sql
<br># - ~\ws03\dist\releases
<br># - ~\ws03\dist\releases\main.changelog.xml
<br># - ~\ws03\dist\releases\next
<br># - ~\ws03\dist\releases\next\changes
<br># - ~\ws03\dist\releases\next\changes\ws03-b001
<br># - ~\ws03\dist\releases\next\changes\ws03-b001\hmol
<br># - ~\ws03\dist\releases\next\changes\ws03-b001\hmol\package_specs
<br># - ~\ws03\dist\releases\next\changes\ws03-b001\hmol\package_specs\hmx_annotations.sql
<br># - ~\ws03\dist\releases\next\changes\ws03-b001\stage.changelog.xml
<br># - ~\ws03\dist\releases\next\release.changelog.xml
<br># - ~\ws03\dist\utils
<br># - ~\ws03\dist\utils\prechecks.sql
<br># - ~\ws03\dist\utils\recompile.sql
1. SQLcl : exit
1. local : git status
<br># Shows the changes due to the `project stage` command in SQLcl
1. local : git commit -m "WS03 added files after the SQLcl project stage command"
1. local : git push
<br># The changes are pushed to the remote repo in branch _ws03-b001_.
1. local : git checkout main
1. local : git merge ws03-b001
1. local : git commit -m "Merged branch ws03-b001"
1. local : git branch -d ws03-b001
<br># Maybe later, in the remote repo?
1. local : git push
