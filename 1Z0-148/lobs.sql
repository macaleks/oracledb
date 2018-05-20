select * from v$parameter where name = 'db_securefile';
alter session set db_securefile ='PERMITTED';

--Create manually managed tablespace
CREATE TABLESPACE trn_basic
DATAFILE 'D:\appOrcl\oracle\oradata\orcl1\trn_basic_01.dbf' 
   SIZE 200M
   SEGMENT SPACE MANAGEMENT MANUAL;
   
--Create a tablespace with ASSM
CREATE TABLESPACE trn_secure
DATAFILE 'D:\appOrcl\oracle\oradata\orcl1\trn_secure_01.dbf' 
SIZE 200M
SEGMENT SPACE MANAGEMENT AUTO;

--Verify the segment space management of tablespaces 
select tablespace_name, segment_space_management
from dba_tablespaces
where regexp_like(tablespace_name, 'trn_(basic|secure)', 'i');



--conn scott

--create a table EMP_BASIC
create table emp_basic
(empno, ename, deptno, job, sal, misc_docs)
lob(misc_docs)
store as basicfile
(tablespace trn_basic)
as
select empno, ename, deptno, job, sal, empty_blob()
from emp
/

--create a table EMP_SECURE
create table emp_secure
(empno, ename, deptno, job, sal, misc_docs)
lob(misc_docs)
store as securefile
(tablespace trn_secure)
as
select empno, ename, deptno, job, sal, empty_blob()
from emp
/

--query user_lobs for lob metadata
with c as 
(
select table_name,
       column_name,
       segment_name,
       tablespace_name,
       in_row,
       securefile
from user_lobs
where table_name in ('EMP_BASIC', 'EMP_SECURE')
)
select * from c
unpivot
(column_value for column_name in (column_name, segment_name, tablespace_name, in_row, securefile))
/

--query user_segments to query initial bytes for LOB
with c as
(
select table_name,
       column_name,
       l.segment_name,
       s.segment_type,
       s.segment_subtype,
       to_char(s.bytes/1024) as bytes
from user_lobs l, user_segments s
where l.SEGMENT_NAME = s.segment_name
and l.TABLE_NAME in ('EMP_BASIC', 'EMP_SECURE')
)
select * from c
unpivot
(column_value for column_name in (column_name, segment_name, segment_type, segment_subtype, bytes))
/

--query temporary LOB metadata
select * from v$temporary_lobs;

--query user_lobs to view advanced features of SecureFile
select column_name,
       encrypt,
       compression,
       deduplication
from user_lobs
where table_name = 'EMP_SECURE'
/

--modify the misc_docs to enable compression and deduplication
alter table emp_secure
modify lob(misc_docs)
(
compress high
deduplicate
)
/

--query user_lobs to view advanced features of SecureFile
select column_name,
       encrypt,
       compression,
       deduplication
from user_lobs
where table_name = 'EMP_SECURE'
/


--authenticate the wallet
  --add wallet directory
  mkdir $ORACLE_BASE/admin/<database_name>/wallet
  --conn systme as sysdba
  alter system set encryption key identified by "orcl";
  --open wallet
  alter system set encryption wallet open identified by "orcl";
  --check wallet status
  select wrl_type, wrl_parameter, status
  from v$encryption_wallet;
  
--conn scott

--modify the misc_docs to enable encription
alter table emp_secure modify
(
 misc_docs encrypt using 'AES192'
)
/

--query user_lobs to view advanced features of SecureFile
select column_name,
       encrypt,
       compression,
       deduplication
from user_lobs
where table_name = 'EMP_SECURE'
/

--create a procedure for populating lob data
create or replace procedure upload_emp_docs
(p_dir varchar2,
 p_file varchar2,
 p_table varchar2,
 p_empno number) as
 
  l_source_blob BFILE;
  
  l_amt_blob integer := 4000;
  
  l_blob blob := empty_blob();
  l_clob clob := empty_clob();

  l_stmt varchar2(2000);
begin
  l_source_blob := bfilename(p_dir, p_file);
  
  dbms_lob.createtemporary(l_blob, true);
  
  dbms_lob.open(l_source_blob, dbms_lob.lob_readonly);
  
  l_amt_blob := dbms_lob.getlength(l_source_blob);
  
  dbms_lob.loadfromfile(l_blob, l_source_blob, l_amt_blob);
  
  dbms_lob.close(l_source_blob);
  
  l_stmt := 'UPDATE ' || p_table || ' SET misc_docs = :p2 where empno = :p3';
  execute immediate l_stmt using l_blob, p_empno;
  
  if sql%rowcount = 0 then
    dbms_output.put_line('Wrong input - employee does not exist');
  else
    dbms_output.put_line('Document uploaded successfully for employee ' || p_empno);
  end if; 
end;
/

--create diretory secure_dir
  --con as sysdba
  create or replace directory secure_dir as 'D:\secure_dir';
  --grant read, write
  grant read, write on directory secure_dir to scott;
  
--conn scott

--LOAD pictures into emp_basic, emp_secure
begin
   for rc in (select rownum, empno from scott.emp where rownum <= 6) loop
     scott.upload_emp_docs('SECURE_DIR',
                     'CIMG087' || (1 + rc.rownum) || '.jpg',
                     'EMP_BASIC',
                     rc.empno);
     
     scott.upload_emp_docs('SECURE_DIR',
                     'CIMG087' || (1 + rc.rownum) || '.jpg',
                     'EMP_SECURE',
                     rc.empno);
   end loop;
end;
/  

--check the size of loaded files
select empno, dbms_lob.getlength(misc_docs)
from scott.emp_secure 
where empno = 7698;

--compare the total blocks consumed
select table_name,
       l.segment_name,
       bytes/1024 KB,
       blocks,
       extents
from user_lobs l, user_segments s
where l.SEGMENT_NAME = s.segment_name
and l.TABLE_NAME in ('EMP_BASIC', 'EMP_SECURE')
/
