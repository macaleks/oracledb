1. PL/Scope Reports on Static SQL Statements and Call Sites for Dynamic SQL
The new view, DBA_STATEMENTS, reports on the occurrences of static SQL in PL/SQL units; 
listing, for example, the statement text, the type (SELECT, INSERT, UPDATE, or DELETE) 
and the SQL_ID. Dynamic SQL call sites (EXECUTE IMMEDIATE, OPEN cursor FOR dynamic text="") 
are also listed in this view family. The DBA_IDENTIFIERS view family now reports on identifiers 
used in static SQL and notes their type (table, column, materialized view, sequence, and so on).

The purpose of PL/SQL is to issue SQL statements. Therefore, it is useful that PL/Scope now knows 
about the uses of SQL in PL/SQL source code. For example, if performance investigation reports 
the SQL_ID of a slow statement, its call sites in the PL/SQL programs can be found immediately. 
When PL/SQL source is under quality control for SQL injection risks, where dynamic SQL is used, 
  the sites to look at can also be found immediately.
  
2.CAST default value ON CONVERSION ERROR
--test in a separate file VALIDATE_CONVERSION*.SQL
3.New SQL and PL/SQL Function VALIDATE_CONVERSION
--test in a separate file VALIDATE_CONVERSION*.SQL
4.Binding PL/SQL-Only Data Types to SQL Statements Using DBMS_SQL
This improvement brings the DBMS_SQL API in parity with the native dynamic SQL.

5. Improving the PL/SQL Debugger
Continue debugging in a different session...

6. New pragma DEPRICATED.
--The DEPRECATE pragma warnings may be managed with the PLSQL_WARNINGS parameter 
--or with the DBMS_WARNING package.
--Enable the Deprecation Warnings
ALTER SESSION SET PLSQL_WARNINGS='ENABLE:(6019,6020,6021,6022)'

--Check warning setting
SELECT DBMS_WARNING.get_warning_setting_string() FROM DUAL

--create depricated package
CREATE OR REPLACE PACKAGE pack1 AS 
PRAGMA DEPRECATE(pack1); 
 PROCEDURE foo; 
 PROCEDURE bar; 
 END pack1; 
/

CREATE OR REPLACE PACKAGE BODY pack1 AS   
 PROCEDURE foo AS   
 BEGIN   
  DBMS_OUTPUT.PUT_LINE('Executing foo.');    
 END foo;   
 PROCEDURE bar IS   
 BEGIN   
  DBMS_OUTPUT.PUT_LINE('bar references foo inside the same package.');  
  foo;    
 END bar;   
END; 
/

call pack1.bar

CREATE OR REPLACE PROCEDURE proc2 AS   
BEGIN   
 pack1.foo;   
    
END proc2;
/

SELECT * FROM USER_ERRORS

7. Materialized Views: Real-Time Materialized Views
Using materialized view logs for delta computation together with the stale materialized view, 
the database can compute the query and return correct results in real time.

8. Materialized Views: Statement-Level Refresh
ON COMMIT, ON DEMAND PLUS ON STATEMENT refresh

9. DBMS_PLSQL_CODE_COVERAGE Package
DBMS_PLSQL_CODE_COVERAGE
/
DECLARE    
   testsuite_run NUMBER;
BEGIN
   testsuite_run :=  DBMS_PLSQL_CODE_COVERAGE.START_COVERAGE(RUN_COMMENT => 'Test Suite ABC');
END;
/

--RUN THE TESTS
--.....

EXECUTE DBMS_PLSQL_CODE_COVERAGE.STOP_COVERAGE;

EXEC DBMS_PLSQL_CODE_COVERAGE.CREATE_COVERAGE_TABLES
/

SELECT * FROM DBMSPCC_RUNS
/
SELECT * FROM DBMSPCC_UNITS
/

SELECT * FROM DBMSPCC_BLOCKS
/


10. Approximate Query Processing

11. White List (ACCESSIBLE BY) Enhancements
CREATE OR REPLACE PACKAGE helper
  AUTHID DEFINER
  ACCESSIBLE BY (api)
IS
  PROCEDURE h1;
  PROCEDURE h2;
END;
/
 
CREATE OR REPLACE PACKAGE BODY helper
IS
  PROCEDURE h1 IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Helper procedure h1');
  END;
 
  PROCEDURE h2 IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Helper procedure h2');
  END;
END;
/
 
CREATE OR REPLACE PACKAGE api
  AUTHID DEFINER
IS
  PROCEDURE p1;
  PROCEDURE p2;
END;
/
 
CREATE OR REPLACE PACKAGE BODY api
IS
  PROCEDURE p1 IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('API procedure p1');
    helper.h1;
  END;
 
  PROCEDURE p2 IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('API procedure p2');
    helper.h2;
  END;
END;
/

12. Enhancing LISTAGG Functionality
--DONE
