SELECT ROUND(100           *CPU_sec/available_time,2) "ORACLE CPU TIME AS % AVAIL." ,
  ROUND(100                *(DB_sec - CPU_sec)/available_time,2) "NON-IDLE WAITS AS % AVAIL." ,
  CASE SIGN(available_time - DB_sec)
    WHEN 1
    THEN ROUND(100*(available_time - DB_sec) / available_time, 2)
    ELSE 0
  END "ORACLE IDLE AS % AVAIL."
FROM
  (SELECT (sysdate - i.startup_time) * 86400 * c.cpus available_time ,
    t.DB_sec ,
    t.CPU_sec
  FROM v$instance i ,
    (SELECT value cpus FROM v$parameter WHERE name = 'cpu_count'
    ) c ,
    (SELECT SUM(
      CASE name
        WHEN 'DB time'
        THEN ROUND(value/100)
        ELSE 0
      END) DB_sec ,
      SUM(
      CASE name
        WHEN 'DB time'
        THEN 0
        ELSE ROUND(value/100)
      END) CPU_sec
    FROM v$sysstat
    WHERE name IN ('DB time', 'CPU used by this session')
    ) t
  WHERE i.instance_number = userenv('INSTANCE')
  );