SELECT a.sid ,
  a.status ,
  TO_CHAR(a.sql_exec_start,'yymmdd hh24:mi') start_time ,
  a.plan_line_id ,
  a.plan_operation ,
  a.plan_options ,
  a.output_rows ,
  a.workarea_mem mem_bytes ,
  a.workarea_tempseg temp_bytes
FROM v$sql_plan_monitor a ,
  v$sql_monitor b
WHERE a.status NOT LIKE '%DONE%'
AND a.key = b.key
ORDER BY a.sid,
  a.sql_exec_start,
  a.plan_line_id;