create or replace type nt_scores as table of number;

select * from user_types;

create table t_bat_scores
(name varchar2(30),
pos number,
score nt_scores)
nested table score store as nt_scores_nt;


insert into t_bat_scores(name, pos, score)
values('Dorn', 1, nt_scores(115, 37));

insert into t_bat_scores(name, pos, score)
values('Dorn', 2, nt_scores(71, 29, 13));

insert into t_bat_scores(name, pos, score)
values('Lewis', 1, nt_scores(34,65,23));

insert into t_bat_scores(name, pos, score)
values('Lewis', 2, nt_scores(0, 1));

insert into t_bat_scores(name, pos, score)
values('Larry', 1, nt_scores());

select * from t_bat_scores;

insert into table(select score from t_bat_scores where name = 'Dorn' and pos = 1)
values (125);

update table(select score from t_bat_scores where name = 'Dorn' and pos = 1) p
set p.column_value = 124
where p.column_value = 125;

select * from t_bat_scores t, table(t.score)(+) t1, table(t.score)(+) t2;

select * from user_nested_tables;
select * from user_nested_table_cols;

--return as locator?

declare
   type nt_scores is table of number;
   c1 nt_scores := nt_scores(1,2,3,4,1,2,3, 4);
   c2 nt_scores := nt_scores(4,3,2,1, 4);
   c3 nt_scores := nt_scores(3,4,1);
   rs nt_scores;
   procedure get_result(p_cols nt_scores) as
   begin
     if p_cols is not null then 
       for i in 1..p_cols.count loop
         dbms_output.put(p_cols(i));
       end loop;
       dbms_output.new_line;
     end if;
   end get_result;
begin
   if c3 submultiset of c1 then
     dbms_output.put_line('TRUE');
   else
     dbms_output.put_line('FALSE');
   end if; 
   
   dbms_output.put_line('--union');
   --rs := ;
   get_result(c1 multiset union distinct c2);
   dbms_output.put_line('--intersect');
   get_result(c1 multiset intersect c2);
   dbms_output.put_line('--minus');
   get_result(c1 multiset except distinct c2);
end;
/   
