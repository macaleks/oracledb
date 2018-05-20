grant execute on dbms_redact to scott;

alter session set current_schema = scott;

begin
  dbms_redact.add_policy(
  object_schema => 'scott',
  object_name => 'emp',
  column_name => 'job',
  policy_name => 'redact_emp_info',
  function_type => dbms_redact.FULL,
  expression => q'|sys_context('userenv', 'current_user') in ('MGR')|'
  );
end;
/

alter session set current_schema = MGR;
SELECT * FROM SCOTT.EMP;

begin
  dbms_redact.ALTER_policy(
  object_schema => 'scott',
  object_name => 'emp',
  column_name => 'HIREDATE',
  ACTION => DBMS_REDACT.ADD_COLUMN,
  policy_name => 'redact_emp_info',
  function_type => dbms_redact.PARTIAL,
  FUNCTION_PARAMETERS => 'm1d1y1900',
  expression => q'|sys_context('userenv', 'current_user') in ('MGR')|'
  );
end;
/

alter table emp add email varchar2(30);

update emp set email = lower(ename) || '@xyz.com';

begin
  dbms_redact.ALTER_policy(
  object_schema => 'scott',
  object_name => 'emp',
  column_name => 'email',
  ACTION => DBMS_REDACT.ADD_COLUMN,
  policy_name => 'redact_emp_info',
  function_type => dbms_redact.regexp,
  regexp_pattern => dbms_redact.re_pattern_email_address,
  regexp_replace_string => dbms_redact.re_redact_email_name,
  expression => q'|sys_context('userenv', 'current_user') in ('MGR')|'
  );
end;
/
