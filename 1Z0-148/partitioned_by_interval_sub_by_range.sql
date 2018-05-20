drop table parttab purge;

create table parttab (id number(19), server_time timestamp, other_info varchar2(2000))
partition by range(server_time) interval (numtodsinterval(1,'day'))
subpartition by range (id) 
(partition p0 values less than (to_date('01012018', 'ddmmyyyy'))
  (subpartition p0_0 values less than (100),
   subpartition p0_1 values less than  (1000000)
   )
   )
tablespace users;

select * from user_tab_partitions where table_name = 'PARTTAB';
alter table parttab drop partition SYS_P2267;
alter table parttab truncate partition SYS_P805;
alter table parttab drop subpartition P0_1;
alter table parttab truncate subpartition SYS_SUBP2126;
select * from user_tab_subpartitions where table_name = 'PARTTAB';

--generate data
insert into parttab
select level+10000, 
       systimestamp + numtodsinterval(level, 'hour') 
      ,'text'
       from dual connect by level <= 100;
