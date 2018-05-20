select * from user_java_classes;

select object_name, object_type, status
from user_objects
where trunc(created) = trunc(sysdate)
order by timestamp;

select * 
from java$options
/

select table_name,
       column_name,
       data_type
from user_tab_cols
where table_name = 'CREATE$JAVA$LOB$TABLE'
/

SELECT table_name, column_name, securefile
FROM user_lobs
WHERE table_name = 'CREATE$JAVA$LOB$TABLE'
/

/*Function to publish Java class method*/
CREATE OR REPLACE FUNCTION F_COMPUTE_SUM
(P_X NUMBER, P_Y NUMBER)
RETURN NUMBER
AS

/*Specify the external programs base language*/
  LANGUAGE JAVA
  NAME 'Compute.Sum(int,int) return int';
/

select f_compute_sum(15,42) from dual
/
