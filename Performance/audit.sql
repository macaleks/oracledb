alter system set audit_trail=db scope=spfile;
shutdown immediate;
startup;
show parameter audit_trail;
--------------------------------------------------------------------------------
audit select, insert, update, delete on /*owner.table*/;
--------------------------------------------------------------------------------
select
 username
,obj_name
,timestamp
,substr(ses_actions,4,1) del
,substr(ses_actions,7,1) ins
,substr(ses_actions,10,1) sel
,substr(ses_actions,11,1) upd
from dba_audit_object;
--------------------------------------------------------------------------------
noaudit select, insert, update, delete on /*owner.table*/;
--------------------------------------------------------------------------------
If you want to move the AUD$ table to a non-SYSTEM tablespace, refer to 
My Oracle Support (MetaLink) note 72460.1 for instructions.
--------------------------------------------------------------------------------
