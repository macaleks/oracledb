create user ea identified by ea;
grant dba to ea;
alter user ea enable editions force;

--------------------------------------------------------------------------------
create edition e2;
grant use on edition e2 to ea;
--------------------------------------------------------------------------------
select sys_context('userenv', 'session_edition_name') from dual;
alter session set edition = E2;

SELECT username, editions_enabled
FROM   dba_users
WHERE  editions_enabled = 'Y';

SELECT * FROM dba_editions;
--------------------------------------------------------------------------------
CREATE TABLE employees_tab (
  employee_id   NUMBER(5)    NOT NULL,
  name          VARCHAR2(40) NOT NULL,
  date_of_birth DATE         NOT NULL,
  CONSTRAINT employees_pk PRIMARY KEY (employee_id)
);

CREATE SEQUENCE employees_seq;

CREATE OR REPLACE EDITIONING VIEW employees AS
SELECT employee_id,
       name,
       date_of_birth
FROM   employees_tab;

CREATE OR REPLACE PROCEDURE create_employee (p_name          IN employees.name%TYPE,
                                             p_date_of_birth IN employees.date_of_birth%TYPE) AS
BEGIN
  INSERT INTO employees (employee_id, name, date_of_birth)
  VALUES (employees_seq.NEXTVAL, p_name, p_date_of_birth);
END create_employee;
/

set serveroutput on
BEGIN
  create_employee('Peter Parker', TO_DATE('20100101', 'yyyymmdd'));
  COMMIT;
END;
/

SELECT * FROM employees;

SELECT object_name, object_type, edition_name
FROM   user_objects_ae
ORDER BY object_name;
--------------------------------------------------------------------------------
create edition e3;
alter session set edition = e3;

BEGIN
  create_employee('Clark Kent', TO_DATE('20100102', 'yyyymmdd'));
  COMMIT;
END;
/

SELECT * FROM employees;

ALTER TABLE employees_tab ADD (
  postcode   VARCHAR2(20)
);

alter session set edition = e2;

select * from dba_editions;

BEGIN
  create_employee('Flash Gordon', TO_DATE('20100102', 'yyyymmdd'));
  COMMIT;
END;
/

SELECT * FROM employees;

alter session set edition = e3;

CREATE OR REPLACE EDITIONING VIEW employees AS
SELECT employee_id,
       name,
       date_of_birth,
       postcode
FROM   employees_tab;

CREATE OR REPLACE PROCEDURE create_employee (p_name          IN employees.name%TYPE,
                                             p_date_of_birth IN employees.date_of_birth%TYPE,
                                             p_postcode      IN employees.postcode%TYPE) AS
BEGIN
  INSERT INTO employees (employee_id, name, date_of_birth, postcode)
  VALUES (employees_seq.NEXTVAL, p_name, p_date_of_birth, p_postcode);
END create_employee;
/

BEGIN
  create_employee('Mighty Mouse', TO_DATE('20100104', 'yyyymmdd'), 'AA1 2BB');
  COMMIT;
END;
/

SELECT * FROM employees;

SELECT object_name, object_type, edition_name
FROM   user_objects_ae
ORDER BY object_name, edition_name;

alter session set edition = e2;
SELECT * FROM employees;

alter session set edition = e3;
ALTER TABLE employees_tab ADD (
  first_name VARCHAR2(20),
  last_name  VARCHAR2(20)
);

UPDATE employees_tab
SET    first_name = SUBSTR(name, 1, INSTR(name, ' ')-1),
       last_name  = SUBSTR(name, INSTR(name, ' ')+1)
WHERE  first_name IS NULL;

ALTER TABLE employees_tab MODIFY (
  first_name VARCHAR2(20) NOT NULL,
  last_name  VARCHAR2(20) NOT NULL
);

CREATE OR REPLACE EDITIONING VIEW employees AS
SELECT employee_id,
       first_name,
       last_name,
       date_of_birth,
       postcode
FROM   employees_tab;

CREATE OR REPLACE PROCEDURE create_employee (p_first_name    IN employees.first_name%TYPE,
                                             p_last_name     IN employees.last_name%TYPE,
                                             p_date_of_birth IN employees.date_of_birth%TYPE,
                                             p_postcode      IN employees.postcode%TYPE) AS
BEGIN
  INSERT INTO employees (employee_id, first_name, last_name, date_of_birth, postcode)
  VALUES (employees_seq.NEXTVAL, p_first_name, p_last_name, p_date_of_birth, p_postcode);
END create_employee;
/

alter session set edition = e3;
SELECT * FROM employees;

select * from user_objects_ae;

alter session set edition = e3;
CREATE OR REPLACE TRIGGER employees_rvrs_xed_trg
  BEFORE INSERT OR UPDATE ON employees_tab
  FOR EACH ROW
  REVERSE CROSSEDITION
  DISABLE
BEGIN
  :NEW.name := :NEW.first_name || ' ' || :NEW.last_name;
END employees_rvrs_xed_trg;
/

CREATE OR REPLACE TRIGGER employees_fwd_xed_trg
  BEFORE INSERT OR UPDATE ON employees_tab
  FOR EACH ROW
  FORWARD CROSSEDITION
  DISABLE
BEGIN
  :NEW.first_name := SUBSTR(:NEW.name, 1, INSTR(:NEW.name, ' ')-1);
  :NEW.last_name  := SUBSTR(:NEW.name, INSTR(:NEW.name, ' ')+1);
END employees_fwd_xed_trg;
/

ALTER TRIGGER employees_fwd_xed_trg enable;
ALTER TRIGGER employees_rvrs_xed_trg enable;

select * from user_objects_ae;

set serveroutput on
DECLARE
  l_scn              NUMBER  := NULL;
  l_timeout CONSTANT INTEGER := NULL;
BEGIN
  IF NOT DBMS_UTILITY.wait_on_pending_dml(tables  => 'employees_tab',
                                          timeout => l_timeout,
                                          scn     => l_scn)
  THEN
    RAISE_APPLICATION_ERROR(-20000, 'Wait_On_Pending_DML() timed out. CETs were enabled before SCN: ' || l_scn);
  END IF;
END;
/

DECLARE
  l_cursor NUMBER := DBMS_SQL.open_cursor();
  l_return NUMBER;
BEGIN
  DBMS_SQL.PARSE(
    c                          => l_cursor,
    Language_Flag              => DBMS_SQL.NATIVE,
    Statement                  => 'UPDATE employees_tab SET name = name',
    apply_crossedition_trigger => 'employees_fwd_xed_trg'
  );
  l_return := DBMS_SQL.execute(l_cursor);
  DBMS_SQL.close_cursor(l_cursor);
  COMMIT;
END;
/

/*ALTER TABLE employees_tab MODIFY (
  first_name VARCHAR2(20) NOT NULL,
  last_name  VARCHAR2(20) NOT NULL
);*/

SELECT SYS_CONTEXT('USERENV', 'SESSION_EDITION_NAME') AS edition FROM dual;

BEGIN
  create_employee('Wonder', 'Woman', TO_DATE('20101001','yyyymmdd'), 'A11 2BB');
  COMMIT;
END;
/

SELECT * FROM employees_tab;

ALTER SESSION SET EDITION = e2;

BEGIN
  create_employee('Inspector Gadget', TO_DATE('20101001','yyyymmdd'));
  COMMIT;
END;
/

SELECT * FROM employees_tab;

