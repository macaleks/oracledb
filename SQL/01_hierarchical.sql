select employee_id, level,
   lpad(' ',(level-1)*3) || last_name || ', ' || first_name full_name,
   connect_by_isleaf,
   connect_by_root employee_id,
   sys_connect_by_path(last_name, '/'),
   CONNECT_BY_ISCYCLE is_cycle
from oe.employees
--where not (last_name = 'Cambrault' and first_name = 'Gerald')--removes only that row leaves its child. where executes after hierarchical part
start with manager_id is null
connect by nocycle/*nocycle is used to avoid cycles*/ manager_id = prior employee_id
        --and not (last_name = 'Cambrault' and first_name = 'Gerald')--removes all branch starting from that row
order siblings by last_name, first_name;
