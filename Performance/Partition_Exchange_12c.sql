drop TABLE tmp_sales 
/
ALTER TABLE emp SET UNUSED COLUMN comm
/
CREATE TABLE tmp_sales AS
SELECT * FROM EMP
WHERE 1 = 2
/
ALTER TABLE emp
EXCHANGE --PARTITION p_2012_06
WITH TABLE tmp_sales
INCLUDING INDEXES WITHOUT VALIDATION
/
SELECT column_id, column_name, hidden_column
FROM user_tab_cols
WHERE table_name = 'EMP'
ORDER BY internal_column_id
/
SELECT column_id, column_name, hidden_column
FROM user_tab_cols
WHERE table_name = 'TMP_SALES'
ORDER BY internal_column_id
/
CREATE TABLE tmp_sales_2
FOR EXCHANGE WITH TABLE EMP
/
SELECT column_id, column_name, hidden_column
FROM user_tab_cols
WHERE table_name = 'TMP_SALES_2'
ORDER BY internal_column_id
/