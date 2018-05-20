select * from 
v$result_cache_objects
where type = 'Result';

select * from 
v$result_cache_statistics;

select free, count(*) from 
v$result_cache_memory
group by free;

select * from 
v$result_cache_dependency d
join dba_objects o on d.OBJECT_NO = o.OBJECT_ID;

create table my_objects as
select * from user_objects uo;

select /*+ result_cache gather_plan_statistics */
    object_type,
    status,
    count(*)
from my_objects
group by object_type, status
order by object_type, status;

select * from 
v$result_cache_objects
where  cache_id = '11fkgsaxsw8fca70gsr8x34rkj';

update my_objects
set object_name = initcap(object_name);

select * from 
v$result_cache_objects
where  cache_id = '11fkgsaxsw8fca70gsr8x34rkj';

commit;

select * from 
v$result_cache_objects
where  cache_id = '11fkgsaxsw8fca70gsr8x34rkj';

select /*+ result_cache gather_plan_statistics */
    object_type,
    status,
    count(*)
from my_objects
group by object_type, status
order by object_type, status;

select * from 
v$result_cache_objects
where  cache_id = '11fkgsaxsw8fca70gsr8x34rkj';

select cache_id, name, status, depend_count, scan_count
from v$result_cache_objects, dba_users
where creator_uid = user_id
and username = 'QZ';

select *
from v$result_cache_statistics
where name in ('Create Count Success', 'Find Count');

create or replace function rslt1 (p1 in number) return number
result_cache as
begin
  return rslt2(p1); 
end rslt1;
/

create or replace function rslt2(p2 in number) return number as
  v number;
begin
    v := p2/2+2;
    return v;
end rslt2;
/

begin
  dbms_output.put_line(rslt1(2)); 
end;
/
select *
from v$result_cache_objects, dba_users
where creator_uid = user_id
and username = 'QZ'
and cache_id = 'fybxnk5rsn91n6qrkzu3nm761s';

select d.*
from 
v$result_cache_dependency d
join all_objects on object_no = object_id
where result_id = 18;

--OCI Result cache (Client cache)
--

--DBMS_RESULT_CACHE package
dbms_result_cache.Bypass(bypass_mode => ;

begin
    dbms_result_cache.Memory_Report(detailed => true); 
end;
/

select * from 
v$result_cache_objects
where type = 'Result'
order by status, namespace;

--Result cache with invoker rights
create or replace function f_count_myobj(obj_type in varchar2)
return number 
authid current_user
result_cache 
as
    l_count number;
begin
    select count(object_type)
    into l_count
    from qz.my_objects
    where object_type = obj_type;
    
    return l_count;
end f_count_myobj;
/

grant execute on f_count_myobj to sh;
grant select on my_objects to sh;
--grant inherit privileges on user qz to sh;
grant inherit privileges on user sh to qz;

begin
    dbms_output.put_line(f_count_myobj('PACKAGE')); 
end;
/


select *
from v$result_cache_objects, dba_users
where creator_uid = user_id
and username = 'QZ'
and cache_id = '7jagyq9nvau9h5430a5a3xx75b';
