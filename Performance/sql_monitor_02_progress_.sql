--SET LINES 3000 PAGES 0 LONG 1000000 TRIMSPOOL ON
SPOOL out.html
select dbms_sqltune.report_sql_monitor(session_id=>185,
  event_detail => 'YES' ,report_level => 'ALL' ,type => 'HTML'
  )
from dual;
SPOOL OFF;