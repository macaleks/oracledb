--Равномерное распределение данных идет только при количестве 
--партиций 2м в степени.
drop table qz_orders;

create table qz_orders (
  order_id       not null primary key,
  customer_id    not null,
  order_datetime not null
) partition by hash ( order_id ) 
  partitions 2
as 
  select level order_id, 
         mod ( level * 2, 743 ),
         date'2018-01-01' + ( level / 192 )
  from   dual
  connect by level <= 10000;
  
  
select uo.subobject_name, count(*), 
       round ( (
           1 - min(count(*)) over() / max(count(*)) over()
         ) * 100 
       ) pct_diff
from   qz_orders t, user_objects uo
where  dbms_rowid.rowid_object(t.rowid) = uo.data_object_id
group  by uo.subobject_name;