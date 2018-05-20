DROP PROCEDURE get_description;
DROP VIEW redef_tab_v;
DROP SEQUENCE redef_tab_seq;
DROP TABLE redef_tab PURGE;

CREATE TABLE redef_tab (
  id           NUMBER,
  description  VARCHAR2(50),
  CONSTRAINT redef_tab_pk PRIMARY KEY (id)
);

CREATE VIEW redef_tab_v AS
SELECT * FROM redef_tab;

CREATE SEQUENCE redef_tab_seq;

CREATE OR REPLACE PROCEDURE get_description (
  p_id          IN  redef_tab.id%TYPE,
  p_description OUT redef_tab.description%TYPE) AS
BEGIN
  SELECT description
  INTO   p_description
  FROM   redef_tab
  WHERE  id = p_id;
END;
/

CREATE OR REPLACE TRIGGER redef_tab_bir
BEFORE INSERT ON redef_tab
FOR EACH ROW
WHEN (new.id IS NULL)
BEGIN
  :new.id := redef_tab_seq.NEXTVAL;
END;
/
--------------------------------------------------------------------------------
SELECT object_name, object_type, status FROM user_objects ORDER BY object_name;

-- Check table can be redefined
EXEC DBMS_REDEFINITION.can_redef_table('QZ', 'REDEF_TAB');

-- Create new table
CREATE TABLE qz.redef_tab2 AS
SELECT * 
FROM   qz.redef_tab WHERE 1=2;

-- Alter parallelism to desired level for large tables.
--ALTER SESSION FORCE PARALLEL DML PARALLEL 8;
--ALTER SESSION FORCE PARALLEL QUERY PARALLEL 8;

-- Start Redefinition
EXEC DBMS_REDEFINITION.start_redef_table('QZ', 'REDEF_TAB', 'REDEF_TAB2');

-- Optionally synchronize new table with interim data before index creation
EXEC DBMS_REDEFINITION.sync_interim_table('qz', 'REDEF_TAB', 'REDEF_TAB2'); 

-- Add new PK.
ALTER TABLE qz.redef_tab2 ADD (CONSTRAINT redef_tab2_pk PRIMARY KEY (id));

-- Complete redefinition
EXEC DBMS_REDEFINITION.finish_redef_table('qz', 'REDEF_TAB', 'REDEF_TAB2');

-- Remove original table which now has the name of the new table
DROP TABLE qz.redef_tab2;

-- Rename the primary key constraint.
ALTER TABLE qz.redef_tab RENAME CONSTRAINT redef_tab2_pk TO redef_tab_pk;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
