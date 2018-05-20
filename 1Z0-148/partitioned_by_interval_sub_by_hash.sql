drop table parttab;

create table parttab (id number(19), server_time timestamp, other_info varchar2(2000))
partition by range(server_time) interval (numtodsinterval(1,'day'))
subpartition by hash(id) subpartitions 32
STORE IN (users, UFS_TS_TX_DATA)
(partition p0 values less than (to_date('01012018', 'ddmmyyyy'))
pctfree 0 
initrans 1
maxtrans 255)
tablespace users;


select * from user_tab_partitions where table_name = 'PARTTAB';
alter table parttab drop partition SYS_P805;
alter table parttab truncate partition SYS_P805;
alter table parttab drop subpartition SYS_SUBP2126;
alter table parttab truncate subpartition SYS_SUBP2126;
select * from user_tab_subpartitions where table_name = 'PARTTAB';

--generate data
insert into parttab
select level, 
       systimestamp + 1/24 + numtodsinterval(level, 'hour') 
      ,'text'
       from dual connect by level <= 10;

alter table parttab drop partition p0;
alter table parttab move subpartition SYS_SUBP713 tablespace UFS_TS_TX_DATA;

alter table parttab move partition P0 tablespace UFS_TS_TX_DATA;

select * from dba_tablespaces;
