set lin 200 hea off longc 1000000 long 1000000 feed off; exec

DBMS_METADATA.SET_TRANSFORM_PARAM(DBMS_METADATA.SESSION_TRANSFORM,'SQLTERMINATOR',TRUE); 

select replace(DBMS_METADATA.GET_DDL('USER','SCOTT'),'CREATE USER','ALTER USER') from dual; 

ALTER USER "SCOTT" IDENTIFIED BY VALUES'S:F0091E6EDDBA71592E8E9A40B1459492C3E7778B5194A5358A0122DF8FA7;F894844C34402B67'
      DEFAULT TABLESPACE "USERS"
      TEMPORARY TABLESPACE "TEMP";