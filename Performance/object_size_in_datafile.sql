select
 a.table_name
 ,b.tablespace_name
 ,b.partition_name
 ,c.file_name
 ,sum(b.bytes)/1024/1024 mb
from dba_tables  a
 ,dba_extents b
 ,dba_data_files c
where a.owner = upper('&owner')
and a.owner = b.owner
and a.table_name = b.segment_name
and b.file_id = c.file_id
group by
  a.table_name
 ,b.tablespace_name
 ,b.partition_name
 ,c.file_name
order by a.table_name, b.tablespace_name;