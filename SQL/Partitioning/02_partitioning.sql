--MERGE
create table f_regs
(reg_count number
,d_date_id number
)
partition by range (d_date_id)(
partition p_2009 values less than (20100101),
partition p_2010 values less than (20110101),
partition p_max values less than (maxvalue)
);

alter table f_regs merge partitions p_2009, p_2010 into partition p_2009_2010;
