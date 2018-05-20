SELECT *
FROM
  (SELECT a.sid session_id ,
    a.sql_id ,
    a.status ,
    a.cpu_time/1000000 cpu_sec ,
    a.buffer_gets ,
    a.disk_reads ,
    b.sql_text sql_text
  FROM v$sql_monitor a ,
    v$sql b
  WHERE a.sql_id = b.sql_id
  and a.status = 'EXECUTING'
  ORDER BY a.cpu_time DESC
  )
WHERE rownum <=20;