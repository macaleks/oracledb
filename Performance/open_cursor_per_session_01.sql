SELECT a.value ,
  c.username ,
  c.machine ,
  c.sid ,
  c.serial#
FROM v$sesstat a ,
  v$statname b ,
  v$session c
WHERE a.statistic# = b.statistic#
AND c.sid          = a.sid
AND b.name         = 'opened cursors current'
AND a.value       != 0
AND c.username    IS NOT NULL
ORDER BY 1,2;