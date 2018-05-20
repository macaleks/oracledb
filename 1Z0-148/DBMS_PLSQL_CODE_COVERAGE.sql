--CREATE A FUNCTION TO BE TESTED
CREATE OR REPLACE FUNCTION func1 (p_code IN VARCHAR2)
  RETURN VARCHAR2
AS
BEGIN
  -- Validate input.
  IF p_code IS NULL THEN
    DBMS_OUTPUT.put_line('Parameter P_CODE cannot be NULL.');
    RETURN 'Error';
  ELSIF LENGTH(p_code) NOT BETWEEN 3 and 5 THEN
    DBMS_OUTPUT.put_line('Parameter P_CODE must be between 3-5 characters inclusive.');
    RETURN 'Error';
  ELSIF TO_NUMBER(p_code DEFAULT -1 ON CONVERSION ERROR) != -1 THEN
    DBMS_OUTPUT.put_line('Parameter P_CODE must contain at least 1 non-numeric character.');
    RETURN 'Error';
  END IF;

  -- The parameter is good, so do something.
  RETURN LOWER(p_code);
END;
/

--CREATE TEST SUITE
CREATE OR REPLACE PROCEDURE run_func1_test(
  p_test    IN  VARCHAR2,
  p_code    IN  VARCHAR2,
  p_return  IN  VARCHAR2)
AS
  l_return VARCHAR2(32767);
BEGIN
  DBMS_OUTPUT.put_line('----------------------------------------');
  DBMS_OUTPUT.put_line('p_test=' || p_test || ' : p_code=' || p_code || ' : p_return=' || p_return);
  l_return := func1(p_code);
  DBMS_OUTPUT.put_line('l_return=' || l_return);
  DBMS_OUTPUT.put(p_test || ' Result=');
  IF l_return = p_return THEN
    DBMS_OUTPUT.put_line('Passed');
  ELSE
    DBMS_OUTPUT.put_line('Failed');
  END IF;
END run_func1_test;
/

--------------------------------------------------------------------------------
SET SERVEROUTPUT ON
BEGIN
  run_func1_test('Test 1', 'ABC', 'abc');
END;
/
--------------------------------------------------------------------------------
BEGIN
  DBMS_PLSQL_CODE_COVERAGE.create_coverage_tables(
    force_it => TRUE);
END;
/

SET SERVEROUTPUT ON
DECLARE
  l_run  NUMBER;
BEGIN
  l_run := DBMS_PLSQL_CODE_COVERAGE.start_coverage(run_comment => 'Example Run');
  DBMS_OUTPUT.put_line('l_run=' || l_run);
END;
/

BEGIN
  run_func1_test('Test 1', 'ABC', 'abc');
END;
/

BEGIN
  DBMS_PLSQL_CODE_COVERAGE.stop_coverage;
END;
/
--------------------------------------------------------------------------------
SELECT * FROM DBMSPCC_RUNS
/
SELECT * FROM DBMSPCC_UNITS
/

SELECT * FROM DBMSPCC_BLOCKS
/
--------------------------------------------------------------------------------
SELECT LISTAGG(ccb.col, ',') WITHIN GROUP (ORDER BY ccb.col) AS col,
       LISTAGG(ccb.covered, ',') WITHIN GROUP (ORDER BY ccb.col) AS covered,
       s.line,
       s.text
FROM   user_source s
       JOIN dbmspcc_units ccu ON s.name = ccu.name AND s.type = ccu.type
       LEFT OUTER JOIN dbmspcc_blocks ccb ON ccu.run_id = ccb.run_id AND ccu.object_id = ccb.object_id AND s.line = ccb.line
WHERE  s.name = 'FUNC1'
AND    s.type = 'FUNCTION'
AND    ccu.run_id = 2
GROUP BY s.line, s.text
ORDER BY 3;

