begin
  dbms_trace 
end;
/

select * from dba_tables where table_name like 'PLSQL_TRACE%';
select * from dba_objects where object_name like 'PLSQL_TRACE%';

ALTER PROCEDURE p_calc_user_points COMPILE PLSQL_OPTIMIZE_LEVEL=1
/


BEGIN
/*Enable tracing for all calls in the session*/
   DBMS_TRACE.SET_PLSQL_TRACE(
    DBMS_TRACE.TRACE_ALL_CALLS +
    DBMS_TRACE.NO_TRACE_ADMINISTRATIVE);
END;
/

BEGIN
 p_calc_user_points (USER, 10, 3);
END;
/

BEGIN
/*Stop the trace session*/
   DBMS_TRACE.CLEAR_PLSQL_TRACE;
END;
/

SELECT MAX(runid)
FROM PLSQL_TRACE_RUNS
--WHERE run_owner='SCOTT'
/

SELECT  event_seq,
        event_comment,
        event_unit_owner||'.'||event_unit unit,
        proc_name,
        proc_unit,
        proc_unit_kind
FROM PLSQL_TRACE_EVENTS
WHERE RUNID=2
ORDER BY EVENT_SEQ
/

SELECT  *
FROM PLSQL_TRACE_EVENTS
WHERE RUNID=2
ORDER BY EVENT_SEQ
/

P_CALC_USER_POINTS
