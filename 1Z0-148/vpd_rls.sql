create user mgr identified by mgr;

grant execute on dbms_rls to public;

grant create any context to scott;

grant create any synonym to scott;

alter session set current_schema = scott;
create context myjob using scott.job_context;

create or replace procedure JOB_CONTEXT is 
begin
  dbms_session.set_context('myjob', 'role', 'MANAGER'); 
end;
/


SELECT * FROM DBA_OBJECTS WHERE OBJECT_NAME = 'MYJOB';

GRANT EXECUTE ON JOB_CONTEXT TO MGR;

GRANT SELECT ON EMP TO MGR;

GRANT CREATE SESSION TO MGR;

CREATE OR REPLACE TRIGGER SET_SECURITY_CONTEXT
AFTER LOGON ON DATABASE
BEGIN
   SCOTT.JOB_CONTEXT; 
END;
/


CREATE OR REPLACE FUNCTION scott.FUN_VPD
(P1 VARCHAR2, P2 VARCHAR2) RETURN VARCHAR2 AS
BEGIN
  RETURN case when user = 'MGR' THEN 'JOB = SYS_CONTEXT(''MYJOB'',''ROLE'')' END;
END;
/

CREATE PUBLIC SYNONYM FUN_VPD FOR FUN_VPD;

GRANT EXECUTE ON SCOTT.FUN_VPD TO MGR;


BEGIN
  DBMS_RLS.ADD_POLICY(
  OBJECT_SCHEMA => 'SCOTT',
  OBJECT_NAME => 'EMP',
  POLICY_NAME => 'VPD_RLS',
  FUNCTION_SCHEMA => 'SCOTT',
  POLICY_FUNCTION => 'FUN_VPD',
  STATEMENT_TYPES => 'SELECT');
END;
/

select * from scott.emp;

BEGIN
  DBMS_RLS.drop_policy('SCOTT','EMP', 'vpd_column'); 
END;
/

BEGIN
  DBMS_RLS.drop_policy('SCOTT','EMP', 'vpd_rls'); 
END;
/

------------------------------------------------------------------------

begin
  dbms_rls.add_policy( object_schema => 'scott', object_name => 'emp', 
  policy_name => 'vpd_column', function_schema => 'scott', policy_function => 'fun_vpd',
  sec_relevant_cols => 'sal, comm');    
end;
/

begin
  dbms_rls.add_policy( object_schema => 'scott', object_name => 'emp', 
  policy_name => 'vpd_column2', function_schema => 'scott', policy_function => 'fun_vpd',
  sec_relevant_cols => 'sal, comm',
  sec_relevant_cols_opt => dbms_rls.ALL_ROWS);    
end;
/
