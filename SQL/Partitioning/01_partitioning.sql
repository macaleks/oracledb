--SPLIT PARTITION
create table f_sales
 (reg_salesnumber number
 ,d_date_idnumber number
 ,state_code varchar2(20)
)
partition by list (state_code)
( partition reg_west values ('AZ','CA','CO','MT','OR','ID','UT','NV')
,partition reg_mid values ('IA','KS','MI','MN','MO','NE','OH','ND')--values to be split
,partition reg_rest values (default)
);

alter table f_sales split partition reg_mid values ('IA','KS','MI','MN') into
(partition reg_mid_a,--listed values on the above line will be stored here
 partition reg_mid_b);--the rest here

---------------------------------------

create table f_regs
(reg_count number
,d_date_id number
)
partition by range (d_date_id)(
partition p_2009 values less than (20100101),
partition p_2010 values less than (20110101),--to be splitted
partition p_max values less than (maxvalue)
);

--add new partition p_2010_a between p_2009 and p_2010 with less than 20100601
alter table f_regs split partition p_2010 at (20100601)
into (partition p_2010_a, partition p_2010) update indexes;
