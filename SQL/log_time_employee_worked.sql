drop table log_time;

create table log_time ( user_name varchar2(100) not null,
                        ins_time  date not null,
                        in_out   number,
                        constraint in_out_chk check (in_out in (0,1)),
                        constraint user_time_u unique(user_name, ins_time) using index
                        );--0 - in ; 1 - out.
--Take the first in; and last out.                        
insert into log_time(user_name, ins_time, in_out)
values('Sam', to_date('20180122 15:00:00', 'yyyymmdd hh24:mi:ss'), 0);
insert into log_time(user_name, ins_time, in_out)
values('Alex', to_date('20180122 15:14:00', 'yyyymmdd hh24:mi:ss'), 0);--in
insert into log_time(user_name, ins_time, in_out)
values('Alex', to_date('20180122 15:24:00', 'yyyymmdd hh24:mi:ss'), 0);--in

insert into log_time(user_name, ins_time, in_out)
values('Alex', to_date('20180122 15:54:00', 'yyyymmdd hh24:mi:ss'), 1);--out

insert into log_time(user_name, ins_time, in_out)
values('Alex', to_date('20180122 16:24:00', 'yyyymmdd hh24:mi:ss'), 0);--in

insert into log_time(user_name, ins_time, in_out)
values('Alex', to_date('20180122 16:34:00', 'yyyymmdd hh24:mi:ss'), 1);--out
insert into log_time(user_name, ins_time, in_out)
values('Alex', to_date('20180122 16:54:00', 'yyyymmdd hh24:mi:ss'), 1);--out

insert into log_time(user_name, ins_time, in_out)
values('Alex', to_date('20180122 18:00:00', 'yyyymmdd hh24:mi:ss'), 0);--in

--default out time 20:00:00 of the same day
commit;

--implementation
select user_name, numtodsinterval(sum(diff_time), 'day') from (
select g.*,
       case in_out
         when 1 then
          ins_time - lead(ins_time)
          over(partition by user_name order by ins_time desc)
       end as diff_time
  from (select user_name,
               ins_time,
               in_out,
               case
                 when lead(in_out) over(partition by user_name order by
                           ins_time) is null and in_out = 0 then
                  null
                 when lag(in_out)
                  over(partition by user_name order by ins_time) is null then
                  in_out
                 when lag(in_out) over(partition by user_name order by
                           ins_time) = in_out and in_out = 0 then
                  null
                 when lead(in_out) over(partition by user_name order by
                           ins_time) = in_out and in_out = 1 then
                  null
                 else
                  in_out
               end as flag
          from log_time
         order by ins_time desc) g
 where flag is not null)
 group by user_name;

