select '.HMX_OBJECT_VERSION' 
    || ' ' || to_char(current_date,'yyyy-mm-dd hh24:mi:ss') 
    || ' ' || extract(timezone_abbr from current_timestamp) 
    as for_objects
    ,'add hmx_object_version'     
        || ' ''' || to_char(current_date,'yyyy-mm-dd hh24:mi:ss') 
        || ' ' || extract(timezone_abbr from current_timestamp) 
        || ''''
        as for_annotation
from dual
/
