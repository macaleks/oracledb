create table var10 (v varchar2(10))
/

declare
  lv dbms_sql.Varchar2_Table;
  
  bulk_error exception;
  pragma exception_init(bulk_error, -24381);
begin
  lv(1) := 'ssssd33';
  lv(2) := 'sdfsfdsfsdfsdfsf';
  lv(3) := 'sss';
  lv(4) := '5hgfghf';
  lv(5) := 'sdfgdsdsgdsgfsdgds';
  lv(6) := 'sf';
  
  forall i in 1..lv.count save exceptions
    insert into var10 values (lv(i));
    
exception
  when bulk_error then
    dbms_output.put_line(sql%rowcount);--4
    dbms_output.put_line(sql%bulk_rowcount(3));--1
    for i in 1..sql%bulk_exceptions.count loop
      dbms_output.put_line('Index of error: ' ||sql%bulk_exceptions(i).error_index);
      dbms_output.put_line('Code of error: ' || sqlerrm(-sql%bulk_exceptions(i).error_code));
    end loop;
  
end;
/

select * from var10;
