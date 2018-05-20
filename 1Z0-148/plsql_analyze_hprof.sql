select * from dba_directories;

create or replace directory dir_profiles as
'D:\dir_profiles'
/

grant read, write on directory dir_profiles to scott;

grant execute on sys.DBMS_HPROF to scott;

begin
  dbms_hprof.start_profiling(location => 'DIR_PROFILES',
                             filename => 'hprof_p_calc.log'); 
end;
/

begin
  p_calc_user_points(user, 10, 3); 
end;
/

begin
  dbms_hprof.stop_profiling(); 
end;
/

connect sys/oracle as sysdba
GRANT select, insert on DBMSHP_RUNS to scott,qz
/
GRANT select, insert on DBMSHP_FUNCTION_INFO  to scott,qz
/
GRANT select, insert on DBMSHP_PARENT_CHILD_INFO  to scott,qz
/
GRANT select on DBMSHP_RUNNUMBER to scott,qz
/

create public synonym dbmshp_runs for sys.dbmshp_runs;
create public synonym dbmshp_function_info for sys.dbmshp_function_info;
create public synonym dbmshp_parent_child_info for sys.dbmshp_parent_child_info;
create public synonym dbmshp_runnumber for sys.dbmshp_runnumber;

sys.dbmshp_runnumber

alter session set current_schema=sys;
declare
  l_runid number;
begin
  l_runid := dbms_hprof.analyze(
  location => 'DIR_PROFILES',
  filename => 'hprof_p_calc.log',
  run_comment => 'Analyzing execution of p_calc_user_points');

  dbms_output.put_line('l_runid = ' || l_runid);
end;
/ 

--QUERYING THE PROFILER TABLES
SELECT runid, total_elapsed_time,run_comment
FROM dbmshp_runs
ORDER BY runid
/

SELECT *
FROM dbmshp_runs
ORDER BY runid
/

SELECT  namespace,
       function,
       module,
       calls,
       function_elapsed_time "time_ms"
FROM dbmshp_function_info
WHERE runid = 1
/

SELECT  *
FROM dbmshp_function_info
WHERE runid = 1
/

select * 
from DBMSHP_PARENT_CHILD_INFO
/

plshprof -summary hprof_p_calc.log

plshprof -output HPROF_PCALC hprof_p_calc.log
;
select * from dual;

