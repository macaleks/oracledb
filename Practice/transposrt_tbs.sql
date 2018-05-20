--Create tablespace for transportation
CREATE TABLESPACE trn_tbs_2 
DATAFILE 'D:\appOrcl\oracle\oradata\orcl1\trn_tbs_2_01.dbf' SIZE 10M
   EXTENT MANAGEMENT LOCAL
   SEGMENT SPACE MANAGEMENT AUTO;

--Create table with the same structure as transpostable partition
CREATE TABLE temp_partition NOLOGGING TABLESPACE USERS
AS SELECT * FROM sh.sales 
WHERE 1=2;

--Partition should be in tablespace to be transported
alter table sh.sales move partition sales_q4_2001 tablespace trn_tbs_2;
--Exchange partiton and the table --without indexes
alter table sh.sales exchange partition SALES_Q4_2001
with table temp_partition without validation;

--Check exchanged partitions
select * from dba_objects where object_name in ('SALES_CUST_BIX', 'SALES_CHANNEL_BIX', 'SALES_PROMO_BIX', 'SALES_TIME_BIX', 'SALES_PROD_BIX') and status = 'INVALID';
select * from dba_ind_partitions where index_name in ('SALES_CUST_BIX', 'SALES_CHANNEL_BIX', 'SALES_PROMO_BIX', 'SALES_TIME_BIX', 'SALES_PROD_BIX')
and partition_name = 'SALES_Q4_2001';

--Check data in temp_partition and the partition
select * from sh.sales partition (SALES_Q4_2001);
select * from temp_partition;

--Mark the tablespace read only to make it transportable
alter tablespace trn_tbs_2 read only;

--export data
exp transport_tablespace=y tablespaces=trn_tbs_2 file=sales_q4_2001.dmp
--or
EXPDP system/password DUMPFILE=expdat.dmp DIRECTORY = dpump_dir 
      TRANSPORT_TABLESPACES=sales_1,sales_2 TRANSPORT_FULL_CHECK=Y

--copy datafiles of the tablespace to a new location

--Copy dump with the tablespace metadata and import it in a target db
imp transport_tablespace=y datafiles='D:\appOrcl\oracle\oradata\orcl2\trn_tbs_2_01.dbf' tablespaces=trn_tbs_2 file=sales_q4_2001.dmp
--or
IMPDP system/password DUMPFILE=expdat.dmp DIRECTORY=dpump_dir
   TRANSPORT_DATAFILES=
   /salesdb/sales_101.dbf,
   /salesdb/sales_201.dbf
   REMAP_SCHEMA=(dcranney:smith) REMAP_SCHEMA=(jfee:williams)
--or
IMPDP system/password PARFILE='par.f'
where the parameter file, par.f contains the following:

DIRECTORY=dpump_dir
DUMPFILE=expdat.dmp
TRANSPORT_DATAFILES="'/db/sales_jan','/db/sales_feb'"
REMAP_SCHEMA=dcranney:smith
REMAP_SCHEMA=jfee:williams

   
--Optionally return data back into partition
alter table sh.sales exchange partition SALES_Q4_2001
with table temp_partition without validation;

--Change mode of the partition
alter tablespace trn_tbs_2 read write;

--On the target database move data from imported table into partition
alter table sh.sales exchange partition SALES_Q4_2001
with table temp_partition without validation;

SELECT * FROM DBA_TABLESPACES;

--auxiliary scripts
select * from dba_tables t where t.TABLESPACE_NAME = 'TRN_TBS_2';
select * from dba_TAB_PARTITIONS t where t.TABLESPACE_NAME = 'TRN_TBS_2';
alter table temp_partition move tablespace users;
alter table sh.sales move partition sales_q4_2001 tablespace trn_tbs_2;
alter tablespace trn_tbs_2 read write;
alter user sh quota unlimited on trn_tbs_2;

select * from dba_tablespaces where tablespace_name = 'TRN_TBS_2';
drop tablespace trn_tbs_2 including contents and datafiles;
