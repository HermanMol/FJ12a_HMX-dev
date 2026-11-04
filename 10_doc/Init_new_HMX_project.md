# The HMX project environment

_A **suggested** structure and management for Oracle database development._

<br>Author: Herman Mol
<br>Date  : 2026-10-30 08:15:23
<br>Status: * WIP * - * WIP * - * WIP * - * WIP * - * WIP * - * WIP * - * WIP * - * WIP * - * WIP * - * WIP *
<br>HMX   : Herman Mol's eXtra's ;-)

---

## References:

- Oracle SQLcl Users Guide
    <br>Document: oracle-sqlcl-users-guide_26_03.pdf
    <br>Version: Release 26.3 | G62131-02 | September 2026
- GitHub
    <br>repo for all artifacts

----

## Environment: 
- Directory = H:\20_projects\FK02a_SQLcl_project
<br>Created using my `New_HMX-project.bat`. This bat file creates a new unique project code, XCOPY-s a template folder structure to a new folder with that 
project code in the name and performs some simple editing like putting the project code in some files.


# SQLcl Project command

## Create project




## Example workflow git & SQLcl

Line prefixes used:
- remote = GitHub
- local  = on your PC
- cmd>   = OS-command on local
- SQLcl> = command on local in a SQLcl session
- DB     = in the database e.g. using Oracle SQL Developer or VScode with the SqlDev extension.
- \#      = comments
- main    = the git definite base branch (aka: "master")

### Step-by_step instructions

Using some example names.

1. local : create a new HMX-project folder.
<br>`cmd> New_HMX-project.bat`
<br>Example for this document: "FK02a_SQLcl_project"
1. local : Navigate to the new HMX-project home folder
<br>`cmd> cd (...)FK02a_SQLcl_project`
1. remote: create a new GitHub repo to hold the new HMX-project.
<br>I use the generated HMX-project code as repo name.
1. local : git clone git@github.com:HermanMol/FK02a_SQLcl_project.git .\00_gittemp
<br># The git repo is temporarily cloned to the not existing HMX-folder 00_gittemp.
<br># Because the `git clone` only exports to an empty folder
<br># Now we __move__ the contents of the 00_gittemp folder to the existing HMX-project 10_wrk
1. local : Open a CMD window in the 10_wrk folder
<br># Step 1: copy the files and folders from 00_gittemp into 10_wrk, including the (hidden) .git folder
1. local : xcopy ..\00_gittemp\* . /e /h
<br># Step 2: delete the 00_gittemp folder after veryfing the copy was successful.
1. local : rmdir /s /q ..\00_gittemp
1. local : git add --all
1. local : git commit -m "Initial project folder into git repo"
1. local : git push
<br># Now the HMX-project folder has been "connected" to the remote git repo.
1. remote: Check the repo in GitHub.

1. # Initial loading of the database objects into the main repo branch
<br>local : Navigate to the 40_database folder in the HMX-project
<br>`cd 40_database`
<br># Initiate the SQLcl-project. 
1. Start SQLcl on local
<br>`oci1 hmol`
<br># I use a batchfile oci1.bat with all connection stuff and only the user (developer, initial schema) as argument
1. SQLcl : Initialise the SQLcl project for the issue_001
<br>`project init -name issue_001 -schemas hmol -con tdq02cei7gikc7j5_medium`
<br>    Output something like
<br>    `------------------------`
<br>    `PROJECT DETAILS`
<br>    `------------------------`
<br>    `Project name:    issue_001`
<br>    `Schema(s):       HMOL`
<br>    `Directory:       H:\20_projects\FK02a_SQLcl_project\10_wrk\40_database`
<br>    `Connection name: tdq02cei7gikc7j5_medium`
<br>    `Project root:     40_database`
<br>    `Your project has been successfully created`
1. SQLcl : export all database objects into the 40_database folder
<br>`project export -schemas hmol`
<br>    Output something like
<br>    `Please first connect to tdq02cei7gikc7j5_medium, as specified in project.config.json`
<br>    `*** TABLES ***`
<br>    `*** VIEWS ***`
<br>    `*** PACKAGE_SPECS ***`
<br>    `*** PACKAGE_BODIES ***`
<br>    `*** PROCEDURES ***`
<br>    `*** SEQUENCES ***`
<br>    `*** SYNONYMS ***`
<br>    `*** TRIGGERS ***`
<br>    `*** TYPE_SPECS ***`
<br>    `*** TYPE_BODIES ***`
<br>    `*** REF_CONSTRAINTS ***`
<br>    `*** OBJECT_GRANTS ***`
<br>    `--------------------------------`
<br>    `COMMENT                        6`
<br>    `GRANT                         81`
<br>    `PACKAGE_BODY                  10`
<br>    `PACKAGE_SPEC                  11`
<br>    `PROCEDURE                      2`
<br>    `REF_CONSTRAINT                 1`
<br>    `SEQUENCE                       3`
<br>    `SYNONYM                       53`
<br>    `TABLE                         11`
<br>    `TRIGGER                        1`
<br>    `TYPE_BODY                      1`
<br>    `TYPE_SPEC                      2`
<br>    `VIEW                          10`
<br>    `--------------------------------`
<br>    `Exported 192 objects`
<br>    `Elapsed 21 sec`
<br>    `The following objects have status "invalid":`
<br>    `PACKAGE BODY  HMOL.HMX_ANNOTATIONS`
1. # Now push the initial sources
1. git add --all
1. git commit -m "Initial loading the database exported sources into the git repo branch issue-001"
1. git push
1. remote: create an issue branch from the proper parent branch, e.g. "issue_001"
1. local : get the branch issue_001
1. local : git pull
1. local : git checkout issue_001
