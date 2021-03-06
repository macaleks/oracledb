select
 a.tablespace_name
 ,(f.bytes/a.bytes)*100 pct_free
 ,f.bytes/1024/1024 mb_free
 ,a.bytes/1024/1024 mb_allocated
from
(select nvl(sum(bytes),0) bytes, x.tablespace_name
from dba_free_space y, dba_tablespaces x
where x.tablespace_name = y.tablespace_name(+)
and x.contents != 'TEMPORARY' and x.status != 'READ ONLY'
and x.tablespace_name not like 'UNDO%'
group by x.tablespace_name) f,
(select sum(bytes) bytes, tablespace_name
from dba_data_files
group by tablespace_name) a
where a.tablespace_name = f.tablespace_name
order by 1;