# Oracle SQLcl Users Guide

    Date: 2026-10-30 08:15:23
    Document: oracle-sqlcl-users-guide_26_03.pdf
    Version: Release 26.3 | G62131-02 | September 2026

----

## 4. AI Enrichment Using the Annotation Command

### Create an annotation
```
    annotation annotate
    -type <object-type>
    -name <object-name>
    -label <annotation-label>
    -value <annotation-value>
    [-debug]
    [-verbose]
```

__Example:__
```
annotation annotate 
    -type VIEW 
    -name HMX_ALL_OBJECT_VERSIONS 
    -label HMX_OBJECT_VERSION 
    -value '2026-10-30 08:35:19 versie' 
    -debug 
    -verbose
```

### Get an annotation
```
    annotation get-annotation
    -type <object-type>
    -name <object-name>
    -label <annotation-label>
    [-debug]
    [-verbose]
```

__Example:__
```
annotation get-annotation 
    -type VIEW 
    -name HMX_ALL_OBJECT_VERSIONS 
    -label HMX_OBJECT_VERSION 
    -debug 
    -verbose
```
### Create a group
```
annotation add-group -group <group-name>
[-debug] [-verbose]
```

__Example:__
```
annotation add-group -group MATCH_ANALYTICS
```

### List groups
```
annotation list-groups
```

### Add an Object to a Group
```
annotation add-to-group -group <group-name>
    -type <object-type> 
    -name <object-name>
```

__Example:__
```
    annotation add-to-group -
    -group HMX_OBJECTS -
    -type VIEW -
    -name HMX_ALL_OBJECT_VERSIONS
```

