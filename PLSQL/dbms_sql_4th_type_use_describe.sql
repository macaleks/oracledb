--PASS INTO A PROCEDURE text of sql and target table
--check intersection of source sql and in a target table columns
--and populate only them in a target table
declare
    v_tgt_table varchar2(30) := 'PLCH_SALES';
    v_tmp_src varchar2(30) := 'TMP_SRC';
    v_src_sql varchar2(32000) := 'select * from PLCH_SALES2';
    v_tmp_create varchar2(32000) := 'CREATE TABLE [TMP_SRC] AS [SRC]';
    v_populate_sql varchar2(32000) := 'INSERT INTO [TGT_TABLE]([COL_LIST])
    SELECT [COL_LIST] FROM [TMP_SRC]';

    sys_cur sys_refcursor;
    n number;
    desctab dbms_sql.desc_tab;
    colcnt integer;
    
    type ntt is table of varchar2(30);
    v_tgt_cols ntt;
    v_src_cols ntt := ntt();
    
    v_col_list varchar2(1000);
begin
    EXECUTE IMMEDIATE REPLACE('SELECT COLUMN_NAME FROM USER_TAB_COLUMNS WHERE TABLE_NAME = ''[TGT_TAB]''', '[TGT_TAB]', v_tgt_table)
    BULK COLLECT INTO v_tgt_cols;

    execute immediate REPLACE(replace(v_tmp_create, '[TMP_SRC]', V_TMP_SRC), '[SRC]', V_SRC_SQL);
    open sys_cur for REPLACE('SELECT * FROM [TMP_SRC]', '[TMP_SRC]', V_TMP_SRC);

    n := dbms_sql.to_cursor_number(sys_cur);
    DBMS_SQL.DESCRIBE_COLUMNS(n, colcnt, desctab);
    for idx in 1..colcnt loop
        v_src_cols.EXTEND;
        v_src_cols(v_src_cols.last) := desctab(idx).col_name;
    end loop;
    
    v_tgt_cols := v_tgt_cols multiset intersect distinct v_src_cols;
    for i in 1.. v_tgt_cols.count loop
      v_col_list := v_col_list || ',' || v_tgt_cols(i) ;
    end loop;
    v_col_list := ltrim(v_col_list, ',');
    
    --DBMS_OUTPUT.PUT_LINE(replace(replace(replace(v_populate_sql, '[TGT_TABLE]', v_tgt_table), '[TMP_SRC]', v_tmp_src), '[COL_LIST]', v_col_list));
    execute immediate replace(replace(replace(v_populate_sql, '[TGT_TABLE]', v_tgt_table), '[TMP_SRC]', v_tmp_src), '[COL_LIST]', v_col_list);

end;
/
set serveroutput on
/
select * from PLCH_SALES;
select * from PLCH_SALES2;

CREATE TABLE TMP_SRC AS select * from PLCH_SALES2 WHERE 1=2
/
DROP TABLE TMP_SRC;

alter table PLCH_SALES add country_code varchar2(10);

INSERT INTO [TGT_TABLE](SOLD_DATE,SOLD_QTY)
    SELECT SOLD_DATE,SOLD_QTY FROM TMP_SRC