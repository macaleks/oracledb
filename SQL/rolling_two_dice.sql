create table rolls (
   roll  number,
   d1    number,
   d2    number
)
/
I populate the table with the results of 36 rolls:

insert into rolls
select  1 roll, 5 d1, 4 d2 from dual union all
select  2 roll, 1 d1, 1 d2 from dual union all
select  3 roll, 6 d1, 5 d2 from dual union all
select  4 roll, 5 d1, 1 d2 from dual union all
select  5 roll, 1 d1, 6 d2 from dual union all
select  6 roll, 5 d1, 2 d2 from dual union all
select  7 roll, 4 d1, 4 d2 from dual union all
select  8 roll, 2 d1, 5 d2 from dual union all
select  9 roll, 4 d1, 1 d2 from dual union all
select 10 roll, 2 d1, 2 d2 from dual union all
select 11 roll, 1 d1, 5 d2 from dual union all
select 12 roll, 5 d1, 3 d2 from dual union all
select 13 roll, 2 d1, 5 d2 from dual union all
select 14 roll, 5 d1, 1 d2 from dual union all
select 15 roll, 5 d1, 5 d2 from dual union all
select 16 roll, 5 d1, 2 d2 from dual union all
select 17 roll, 4 d1, 6 d2 from dual union all
select 18 roll, 3 d1, 1 d2 from dual union all
select 19 roll, 1 d1, 5 d2 from dual union all
select 20 roll, 4 d1, 6 d2 from dual union all
select 21 roll, 6 d1, 2 d2 from dual union all
select 22 roll, 5 d1, 2 d2 from dual union all
select 23 roll, 1 d1, 5 d2 from dual union all
select 24 roll, 2 d1, 5 d2 from dual union all
select 25 roll, 3 d1, 6 d2 from dual union all
select 26 roll, 6 d1, 2 d2 from dual union all
select 27 roll, 1 d1, 1 d2 from dual union all
select 28 roll, 2 d1, 6 d2 from dual union all
select 29 roll, 2 d1, 5 d2 from dual union all
select 30 roll, 1 d1, 4 d2 from dual union all
select 31 roll, 4 d1, 3 d2 from dual union all
select 32 roll, 3 d1, 5 d2 from dual union all
select 33 roll, 6 d1, 1 d2 from dual union all
select 34 roll, 3 d1, 5 d2 from dual union all
select 35 roll, 3 d1, 6 d2 from dual union all
select 36 roll, 5 d1, 3 d2 from dual
/

commit
/

select roll, d1+d2 as result
from rolls
order by roll;

select result
     , avg(rolls_to_7) rolls_to_7
  from (
   select d1+d2 as result
        , first_value(
             case when d1+d2=7 then roll end ignore nulls
          ) over (
             order by roll
             rows between 1 following and unbounded following
          ) - roll as rolls_to_7
   from rolls
       )
group by result
order by rolls_to_7
/

select result
     , avg(rolls_to_7) rolls_to_7
  from (
   select d1+d2 as result
        , (
            select min(roll)
              from rolls r2
             where r2.roll > rolls.roll
               and r2.d1+r2.d2 = 7
          ) - roll as rolls_to_7
   from rolls
       )
group by result
order by rolls_to_7
/

select d1+d2 as result
     , avg(
          (
            select min(roll)
              from rolls r2
             where r2.roll > rolls.roll
               and r2.d1+r2.d2 = 7
          ) - roll
       ) rolls_to_7
  from rolls
group by d1+d2
order by rolls_to_7
/