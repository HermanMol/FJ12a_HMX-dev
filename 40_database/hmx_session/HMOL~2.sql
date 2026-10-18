select atc.owner
    ,atc.table_name
    ,atc.column_name
    ,atc.data_type
    ,coalesce(nullif(atc.char_length,0),atc.data_length) as data_size
    ,decode (atc.char_used, 'C','CHAR','B','BYTE', null) as char_or_byte
    ,atc.column_id
    ,tcc.comments
    ,atc.char_col_decl_length
    ,atc.char_length
    ,atc.char_used
    ,atc.data_length
from all_tab_columns atc
left join all_col_comments tcc on (tcc.owner = atc.owner
                                    and tcc.table_name = atc.table_name
                                    and tcc.column_name = atc.column_name
                                    )
where atc.owner = 'HMOL'
order by atc.owner
    ,atc.table_name
    ,atc.column_id
/
