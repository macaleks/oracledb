select * from
(
select
segment_name
,partition_name
,segment_type
,owner
,bytes/1024/1024 mb
from dba_segments
order by bytes desc)
where rownum <=20;