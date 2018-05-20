select a.group#
 ,a.member
 ,b.status
 ,b.bytes/1024/1024 meg_bytes
from v$logfile a,
     v$log  b
where a.group# = b.group#
order by a.group#;

select optimal_logfile_size from v$instance_recovery;