--40
create table test_tbl(id number, object blob)
/
declare
  b blob;
begin
  b := utl_raw.cast_to_raw('01');
  insert into test_tbl values (1, b);
  b := utl_raw.cast_to_raw('11');
  insert into test_tbl values (2, b);
  commit;
end;
/

select * from test_tbl
/

create trigger trig_at 
after update on test_tbl
begin
  dbms_output.put_line('It was updated');
end;
/

declare
  dest_lob blob;
  src_lob blob;
begin
  select object into dest_lob from test_tbl where id = 2 for update;
  select object into src_lob from test_tbl where id = 1;
  dbms_lob.append(dest_lob => dest_lob, src_lob => src_lob);
end;
/

select * from test_tbl
/

--39
declare
  type ntb1 is table of varchar2(20);
  v1 ntb1 := ntb1('hello', 'world', 'test');
  type ntb2 is table of ntb1 index by pls_integer;
  v3 ntb2;
begin
  v3(31) := ntb1(4,5,6);
  v3(32) := v1;
  v3(33) := ntb1(2,5,1);
  v3(31) := ntb1(1,1);
  
  dbms_output.put_line('v3(31)(2) = ' || v3(31)(2));
  dbms_output.put_line('v3(33)(2) = ' || v3(33)(2));
  
--  dbms_output.put_line('v3(31)(3) = ' || v3(31)(3));--subscript beyond count
  
  dbms_output.put_line('v3(31)(1) = ' || v3(31)(1));
  dbms_output.put_line('v3(33)(3) = ' || v3(33)(3));
  
  dbms_output.put_line('v3(31)(1) = ' || v3(31)(1));
  
  dbms_output.put_line('v3(32)(2) = ' || v3(32)(2));
  dbms_output.put_line('v1(2) = ' || v1(2));
  
  v3.delete;
  
  dbms_output.put_line('v3.count = ' || v3.count);
end;
/

--38
declare
  type tab_type is table of number;
  my_tab tab_type;
begin
  my_tab(1) := 1;
end;
/

declare--ok
  type tab_type is table of number;
  my_tab tab_type := tab_type(2);
begin
  my_tab(1) := 55;
end;
/

declare
  type tab_type is table of number;
  my_tab tab_type;
begin
  my_tab.extend(2);
  my_tab(1) := 55;
end;
/

declare
  type tab_type is table of number;
  my_tab tab_type;
begin
  my_tab := tab_type();
  my_tab(1) := 55;
end;
/

declare
  type tab_type is table of number;
  my_tab tab_type := tab_type(2, null, 50);
begin
  my_tab.extend(2,3);
  for i in 1.. my_tab.count loop
    dbms_output.put_line(my_tab(i));
  end loop;
end;
/

--37
create type list_typ is table of number
/

declare
  l_list list_typ := list_typ();
begin
  if l_list.limit is not null then
    dbms_output.put_line('true');
  end if;
end;
/
  
declare--ok
  l_list list_typ := list_typ();
begin
  l_list.extend;
  if l_list.prior(l_list.first) is null then
    dbms_output.put_line('true');
  end if;  
end;
/

declare
  l_list list_typ := list_typ();
begin
  l_list.extend;
  if l_list is empty then
    dbms_output.put_line('true');
  end if;  
end;
/

declare
  l_list list_typ := list_typ();
begin
  l_list.extend;
  if l_list.first is null then
    dbms_output.put_line('true');
  end if;  
end;
/
  
declare--ok
  l_list list_typ := list_typ();
begin
  l_list.extend;
  if l_list.first = 1 then
    dbms_output.put_line('true');
  end if;  
end;
/

--36
alter session set plsql_ccflags = 'mode: FALSE'--ok
/

alter session set plsql_ccflags = 'mode: NULL'--ok
/

alter session set plsql_ccflags = 'mode: Level 1'
/

alter session set plsql_ccflags = 'mode: Level1'
/

alter session set plsql_ccflags = 'mode: 1'--ok
/

--35
create table employee_ids(emp_id number, emp_userid varchar2(10), emp_taxid number invisible default -1)
/
insert into employee_ids(emp_id, emp_userid, emp_taxid) values(1011, 'jjones', 3789)
/
insert into employee_ids values(1011, 'ssmith')
/

select emp_id, emp_userid, emp_taxid from employee_ids
/

declare
  cursor cur is select * from employee_ids order by emp_id;
  rec cur%rowtype;
begin
  open cur;
  loop
    fetch cur into rec;
    exit when cur%notfound;
    dbms_output.put_line('Fetched ' || rec.emp_id || ',' || rec.emp_userid || ',' /*|| rec.emp_taxid*/ /*cause compilation error*/);
  end loop;
  close cur;
exception 
  when others then
    if cur%isopen then
      close cur;
    end if;
    raise;
end;
/

--34
begin
  dbms_output.put_line(dbms_assert.ENQUOTE_NAME('this is a test message', true)); 
end;
/

begin
  dbms_output.put_line(dbms_assert.ENQUOTE_NAME('this is a "test" message', true)); 
end;
/

begin
  dbms_output.put_line(dbms_assert.ENQUOTE_NAME('"this is a "test" message"', true)); 
end;
/

begin
  dbms_output.put_line(dbms_assert.ENQUOTE_NAME('"this is a test message"', true));--ok
end;
/

begin
  dbms_output.put_line(dbms_assert.ENQUOTE_NAME('this is a test message', false));--ok 
end;
/

--33
create table departments(department_id number, department_name varchar2(100))
/
insert into departments values(10, 'dept10')
/
commit
/

declare--ok
  type dept_cur is ref cursor;
  cv1 dept_cur;
  v_dept_name departments.department_name%TYPE;
begin
  open cv1 for select department_name from departments where department_id = 10;
  
  if cv1 is not null then 
    fetch cv1 into v_dept_name;
    dbms_output.put_line(v_dept_name);
  end if;
  close cv1;    
end;
/

declare
  type dept_cur is ref cursor return departments%rowtype;
  cv1 dept_cur;
  v_dept_name departments.department_name%TYPE;
begin
  open cv1 for select * from departments where department_id = 10;
  fetch cv1.department_name into v_dept_name;
  dbms_output.put_line(v_dept_name);
  close cv1;    
end;
/

declare
  type names_t is table of sys_refcursor index by pls_integer;--disallowed
  type dept_cur is ref cursor;
  cv1 dept_cur;
  v_dept_name departments.department_name%TYPE;
begin
  open cv1 for select department_name from departments where department_id = 10;
  
  if cv1 is not null then 
    fetch cv1 into v_dept_name;
    dbms_output.put_line(v_dept_name);
  end if;
  close cv1;    
end;
/

declare
  cv1 sys_refcursor;
  v_dept_name departments.department_name%TYPE;
begin
  execute immediate 'begin open :cv1 for select department_name from departments where department_id = 10; end;' using in cv1;
  fetch cv1 into v_dept_name;
  dbms_output.put_line(v_dept_name);
  close cv1;    
end;
/

--31
create or replace package pkg1 
accessible by (pkg2) as
  procedure proc1a;
end pkg1;
/

create or replace package body pkg1 as
  procedure proc1a as
  begin
    dbms_output.put_line('proc1'); 
  end proc1a;
  
  procedure proc1b as
  begin
    proc1a;
  end proc1b;
end pkg1;
/

create or replace package pkg2 as
  procedure proc2;
  procedure proc3;
end pkg2;
/

create or replace package body pkg2 as

  procedure proc2 as
  begin
    pkg1.proc1a;
  end;
  procedure proc3 as
  begin
    proc2;
  end;
end pkg2;
/

create or replace procedure my_proc as
begin
  pkg1.proc1a;
end;
/

begin
  my_proc;
end;
/

begin
  pkg2.proc3;
end;
/

begin
  pkg2.proc2;
end;
/

begin
  pkg1.proc1a;
end;
/

begin
  pkg1.proc1b;
end;
/

--29
dbms_result_cache.Status;

--28
declare
  type emp_info is record(
    emp_id       number(3),
    expr_summary clob);
  type emp_typ is table of emp_info;
  l_emp emp_typ;
  l_rec emp_info;
begin
  l_rec := null;
  l_emp := emp_typ(l_rec);
  if l_emp(1).expr_summary is empty then
    dbms_output.put_line('Summary is null');
  end if;
end;
/

declare--ok
  type emp_info is record(
    emp_id       number(3),
    expr_summary clob);
  type emp_typ is table of emp_info;
  l_emp emp_typ;
  l_rec emp_info;
begin
  l_rec.emp_id := 1;
  l_rec.expr_summary := null;
  l_emp := emp_typ(l_rec);
  if l_emp(1).expr_summary is null then
    dbms_output.put_line('Summary is null');
  end if;
end;
/

declare
  type emp_info is record(
    emp_id       number(3),
    expr_summary clob);
  type emp_typ is table of emp_info;
  l_emp emp_typ;
  l_rec emp_info;
begin
  l_rec.emp_id := 1;
  l_rec.expr_summary := empty_clob();
  l_emp := emp_typ(l_rec);
  if l_emp(1).expr_summary is null then
    dbms_output.put_line('Summary is null');
  end if;
end;
/

declare--ok
  type emp_info is record(
    emp_id       number(3),
    expr_summary clob);
  type emp_typ is table of emp_info;
  l_emp emp_typ;
  l_rec emp_info;
begin
  l_emp := emp_typ();
  if not l_emp.exists(1) then
    dbms_output.put_line('Summary is null');
  end if;
end;
/

declare
  type emp_info is record(
    emp_id       number(3),
    expr_summary clob);
  type emp_typ is table of emp_info;
  l_emp emp_typ;
  l_rec emp_info;
begin
  l_emp.extend;
  if not l_emp.exists(1) then
    dbms_output.put_line('Summary is null');
  end if;
end;
/

--27
create table employees(employee_id number, last_name varchar2(20))
/
create or replace package pkg authid current_user as
  type rec is record(f1 number, f2 varchar2(20));
  type mytab is table of rec index by pls_integer;
end;
/
insert into employees values (1, 'adf');

insert into employees select 99 + level, 'adf' || level from dual connect by level <= 101;

declare
  v1 pkg.mytab;
  --v2 employees%rowtype;
  v2 pkg.rec;
  c1 sys_refcursor;
begin
  for i in 100..200 loop
    select employee_id, last_name into v1(i)
    from employees where employee_id = i;
  end loop; 
  open c1 for select * from table(v1);
  fetch c1 into v2;
  close c1;
end;
/

--26
declare
  type databuf_arr is table of clob index by binary_integer;
  pdatabuf databuf_arr;
begin
  pdatabuf(1) := null;
  dbms_output.put_line(pdatabuf.count); 
  dbms_lob.createtemporary(pdatabuf(1), true, dbms_lob.session);
end;
/

--25
--NOLOGGING
--DBMS_REDEFININTION

--24
--MASKING
--SECURITY RULES

--23
--CAN'T USE REF CURSOR AFTER TO_CURSOR_NUMBER
--EITHER STRONGLY OR WEAKLY TYPED CURSOR VARIABLE
declare
  type rf is ref cursor return dual%rowtype;
  vs rf;
  n number;
  res varchar2(10);
begin
  open vs for select * from dual;
  n := dbms_sql.to_cursor_number(rc => vs);
--  fetch vs into res;--NONE
  dbms_output.put_line(res); 
end;
/

--22
declare
  p_prod varchar2(10) := 'prod';
begin
  dbms_output.put_line(dbms_assert.ENQUOTE_LITERAL('%' || p_prod || '%'));  
  dbms_output.put_line(dbms_assert.ENQUOTE_NAME('"%' || p_prod || '%"'));    
end;
/

--21
create or replace function remap_schema return clob as
  h number;
  th number;
  doc clob;
begin
  h := dbms_metadata.open('TABLE');
  dbms_metadata.set_filter(h, 'SCHEMA', 'SCOTT');
  dbms_metadata.set_filter(h, 'NAME', 'EMP');
  th := dbms_metadata.add_transform(h, 'MODIFY');
  dbms_metadata.set_remap_param(th, 'REMAP_SCHEMA', 'SCOTT', NULL);
  dbms_metadata.set_remap_param(th, 'REMAP_TABLESPACE', 'USERS', 'SYSAUX');
  th := dbms_metadata.add_transform(h, 'DDL');
  dbms_metadata.set_transform_param(th, 'SEGMENT_ATTRIBUTES', FALSE);
  doc := dbms_metadata.fetch_clob(h);
  dbms_metadata.close(h);
  return doc;
end;
/

declare
  h number;
  th number;
  doc clob;
begin
  h := dbms_metadata.open('TABLE');
  dbms_metadata.set_filter(h, 'SCHEMA', 'SCOTT');
  dbms_metadata.set_filter(h, 'NAME', 'EMP');
  th := dbms_metadata.add_transform(h, 'MODIFY');
  dbms_metadata.set_remap_param(th, 'REMAP_SCHEMA', 'SCOTT', NULL);
  dbms_metadata.set_remap_param(th, 'REMAP_TABLESPACE', 'USERS', 'SYSAUX');
  th := dbms_metadata.add_transform(h, 'DDL');
  dbms_metadata.set_transform_param(th, 'SEGMENT_ATTRIBUTES', FALSE);
  doc := dbms_metadata.fetch_clob(h);
  dbms_metadata.close(h);
  dbms_output.put_line(doc); 
end;
/

select remap_schema from dual;

--20
create or replace package pkg7 as
--  type tab_typ is table of varchar2(10) index by varchar2;
  function tab_end(p_tab in tab_typ) return varchar2;
end pkg7;
/

create or replace package body pkg7 as
  function tab_end(p_tab in tab_typ) return /*tab_typ*/varchar2 as
  begin
      return p_tab.LAST;
  end;
end pkg7;
/

declare
  l_stmt varchar2(100);
  l_list tab_typ;
  l_result varchar2(10);
begin
  l_list := tab_typ();
  l_list.extend(5); 
 l_list(1) := 'MONDAY';
 l_list(2) := 'TUESDAY';
 l_list(5) := 'FRIDAY';
  
  l_stmt := 'select pkg7.tab_end(:l_list) into :l_result from dual'; 
  execute immediate l_stmt into l_result using l_list;
  dbms_output.put_line(l_result);
  l_list.delete(1);
  execute immediate l_stmt into l_result using l_list;
  dbms_output.put_line(l_result); 
  dbms_output.put_line(l_list(l_result)); 
end;
/

create or replace type tab_typ is table of varchar2(10) index by varchar2(10);

--19
create table products(prod_id number);
insert into products values (555);
declare
  v_cur number;
  v_ret number;
  v_ref_cur sys_refcursor;
  type prod_tab is table of products.prod_id%type;
  v_prod_tab prod_tab;
begin
  v_cur := dbms_sql.open_cursor;
  dbms_sql.parse(v_cur, 'select prod_id from products', dbms_sql.native);
  v_ret := dbms_sql.execute(v_cur);
  v_ref_cur := dbms_sql.to_refcursor(cursor_number => v_cur);
  fetch v_ref_cur bulk collect into v_prod_tab;
  dbms_output.put_line('No of products is: ' || v_prod_tab.count);
  close v_ref_cur;
end;
/

--18
create or replace procedure oe.my_new_proc authid current_user as
  pragma autonomous_transaction;
begin
  execute immediate 'grant dba to oe';
  commit;
exception
  when others then null;
end;
/

create or replace function oe.return_date(param1 in number) return date
authid current_user as
begin
  my_new_proc;
  return sysdate + param1;
end;
/

grant execute on oe.return_date to public;

select * from dba_role_privs rp where rp.GRANTEE in 'OE';
--CONNECT SYS
revoke inherit privileges on user qz from public;
--connect qz with dba role
select * from dba_role_privs rp where rp.GRANTEE in 'QZ';
select oe.return_date(1) from dual
/--FAIL

--CONNECT SYS
grant inherit privileges on user qz to public;
--connect qz with dba role
select * from dba_role_privs rp where rp.GRANTEE in 'QZ';
select oe.return_date(1) from dual
/--SUCCEEDED
select * from dba_role_privs rp where rp.GRANTEE in 'OE';

--17
create or replace type tp_rec# as object (col1 number, col2 number);
/
create or replace type tp_test# as table of tp_rec#;
/

declare
  wk# tp_test# := tp_test#();
begin
  for i in 1..100 loop
    wk#.extend(1);
    wk#(i) := tp_rec#(i,i);
    /*wk#(i).col1 := i;
    wk#(i).col2 := i;*/
  end loop;
end;
/

--16
--ALL_SOURCE
--ALL_ARGUMENTS

--15
--small definite amounts of data

--14
create or replace view qz_view 
--bequeath current_user
as
select qz_function as func_name from dual;

create or replace function qz_function return varchar2
authid current_user
 as
begin
  return sys_context('userenv', 'current_user');--sys_context('userenv', 'current_user');--user
end;
/

select * from qz_view;
grant select on qz_view to sh;

--12
--dbms_lob
--dbms_lob.compare  -- compare entire or parts of two LOBs
--??

--11
--lob 
--??


--10
create table students(last_name varchar2(100));
insert into students select 'Astory' || (25+level) from dual connect by level <=25;

declare
  cursor name_cur is 
    select last_name from students where last_name like 'A%';
  type l_name_type is varray(25) of students.last_name%TYPE;
  names l_name_type := l_name_type();
  v_index integer := 0;
begin
  for name_rec in name_cur loop
    names.extend;
    v_index := v_index + 1;
    names(v_index) := name_rec.last_name;
    dbms_output.put_line(names(v_index));  
  end loop;  
end;
/

--9
--lob
--??
declare
  c clob := 'fdasfasd';
begin
  dbms_output.put_line(dbms_lob.instr(lob_loc => c, pattern => 'asf'));  
end;
/


--8
alter table students drop column sal;
alter table students add sal number default 50;
declare
  cursor name_cur is 
    select last_name, sal *   sal from students where last_name like 'A%';
  type l_name_type is varray(25) of students.last_name%TYPE;
  names l_name_type := l_name_type();
  v_index integer := 0;
begin
  for name_rec in name_cur loop
    dbms_output.put_line(name_rec."SAL*SAL");  
  end loop;  
end;
/

--5
--unreachable code
alter session set plsql_warnings='enable:all';

create or replace function compare_numbers(p1 number, p2 number)
return number
authid current_user
as
begin
  if p1 > p2 then
    return 1;
  elsif p1 < p2 then
    return -1;
    else return 0;
  end if;
    return 99;
end;
/

--3
create table mstudents (name varchar2(10), marks integer);

insert into mstudents select 'name' || level, dbms_random.value(1,5) from dual connect by level < 101;
select * from mstudents;
 
create or replace function rc_func(p_name in varchar2)
return number
result_cache as
  v_mark number;
begin
  select marks
  into v_mark
  from mstudents
  where name = p_name;
  dbms_output.put_line(p_name);
  return v_mark;
end;
/

update mstudents
set marks = 5
where name = 'name2';
commit;
begin
  dbms_output.put_line(rc_func('name1')); 
end;
/

begin
  dbms_result_cache.Bypass(bypass_mode => true);
end;
/

--2
create or replace function invoice_date return date
result_cache authid definer as
  l_date := date;
begin
  l_date := sysdate;
  return l_date;
end;
/

select invoice_date from dual;

alter session set nls_date_format = 'MM dd yyyy';
begin
  dbms_output.put_line(invoice_date);  
end;
/
