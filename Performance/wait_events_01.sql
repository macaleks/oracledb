SELECT wait_class,
  ROUND(100 * time_class / total_waits, 2) "CLASS AS % OF WHOLE",
  event,
  ROUND(100 * time_waited / time_class, 2) "EVENT AS % OF CLASS",
  ROUND(100 * time_waited / total_waits, 2) "EVENT AS % OF WHOLE"
FROM
  (SELECT wait_class ,
    event ,
    time_waited ,
    SUM(time_waited) over (partition BY wait_class) time_class ,
    rank() over (partition BY wait_class order by time_waited DESC) rank_within_class ,
    SUM(time_waited) over () total_waits
  FROM v$system_event
  WHERE wait_class <> 'Idle'
  )
WHERE rank_within_class <= 3
ORDER BY time_class DESC,
  rank_within_class;