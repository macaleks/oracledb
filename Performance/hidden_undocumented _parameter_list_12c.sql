select 
   ksppinm, 
   ksppdesc 
from 
   x$ksppi 
where
   substr(ksppinm,1,1) = '_'
order by 
   1,2;