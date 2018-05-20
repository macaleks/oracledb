select t.SID,t.SERIAL#,/*идентификаторы сессии*/
'sys.dbms_system.set_ev( '||t.Sid||','||t.SERIAL#||' , 10046,8 , '''');--'||p.spid TRACE_CODE/*код для постановки сессии на трэйс*/,
p.SPID/*идентификатор процесса в операционной системе сервера БД*/,
t.USERNAME/*имя пользователя*/,t.MACHINE/*машина с которой залогинился*/,
t.STATUS/*активный - неактивный - убитый*/,
t.OSUSER/*пользователь операционной системы под которым зашло приложение*/,
t.PROGRAM,t.MODULE,t.ACTION/*информация о модуле приложения*/,
t.SQL_ID/*какой запрос выполняется сейчас*/,t.PREV_SQL_ID/*какой запрос выполнен предыдущий*/,
t.EVENT/*чего ждет данная сессия*/,t.SECONDS_IN_WAIT/*сколько времени ждет*/ ,
t.ROW_WAIT_OBJ#,t.ROW_WAIT_FILE#,t.ROW_WAIT_BLOCK#,t.ROW_WAIT_ROW#,/*при взаимных блокировках идентифицируем объект*/
t.LOGON_TIME/*когда сессия зашла в БД*/,
t.BLOCKING_SESSION_STATUS,t.BLOCKING_SESSION,/*кто ее блокирует*/
t.*/*на всякий случай все остальные поля из v$session*/
from v$session t , v$process p
where t.PADDR=p.ADDR
and t.USERNAME='SELFCARE'
and t.MACHINE='scc1'

