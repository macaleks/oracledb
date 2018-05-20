drop table tab_basicfile;
drop table tab_securefile;

create table tab_basicfile(doc clob ) 
  lob(doc) store as basicfile;

alter table tab_basicfile add id number;
alter table tab_basicfile add primary key(id);

insert into tab_basicfile values('adfasfasfas', 1);  
  
select column_name, securefile
from user_lobs
where table_name = 'TAB_BASICFILE';

create table tab_securefile
(id number,
doc clob)
lob(doc) store as securefile;

select column_name, securefile
from user_lobs
where table_name = 'TAB_SECUREFILE';


select * from tab_basicfile;
select * from tab_securefile;
--REDEFINITON PROCESS
declare
  l_error pls_integer := 0;
begin
  dbms_redefinition.start_redef_table(
  uname => 'qz',
  orig_table => 'tab_basicfile',
  int_table => 'tab_securefile',
  col_mapping => 'id id'
  
  );
  
  dbms_redefinition.copy_table_dependents(
  uname => 'qz',
  orig_table => 'tab_basicfile',
  int_table => 'tab_securefile',
  copy_indexes => 1,
  copy_triggers => true,
  copy_constraints => true,
  copy_privileges => true,
  ignore_errors => false,
  num_errors => l_error,
  copy_statistics => false,
  copy_mvlog => false);
  
  dbms_output.put_line('Errors := ' || to_char(l_error));
  
  dbms_redefinition.finish_redef_table(
  uname                 => 'qz',
  orig_table            => 'tab_basicfile',
  int_table             => 'tab_securefile');
end;
/

drop table tab_securefile;
