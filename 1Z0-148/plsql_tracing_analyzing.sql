create or replace procedure p_calc_user_points(p_user    varchar2 default user,
                                               p_correct number,
                                               p_wrong   number) as
  l_num number;

  function f_calc_points(p_ques number, p_factor number) return number as
  begin
    return(p_ques * p_factor);
  end f_calc_points;

  procedure p_net_calc(p_net_points out number) as
  begin
    p_net_points := f_calc_points(p_correct, 4) +
                    f_calc_points(p_wrong, -2);
  end p_net_calc;

begin
  p_net_calc(l_num);
  dbms_output.put_line(user || ' earned ' || to_char(l_num) || ' points');
end;
/

--user_arguments;
select argument_name, data_type, defaulted, position, data_level, in_out, pls_type
from user_arguments
where object_name in ('P_CALC_USER_POINTS')
order by position
/

select *
from user_arguments
where object_name in ('P_CALC_USER_POINTS')
order by position
/

--user_objects;
select object_id, object_type, status, namespace
from user_objects
where object_name in ('P_CALC_USER_POINTS')
/

select *
from user_objects
where object_name in ('P_CALC_USER_POINTS')
/

--user_object_size;
select type, source_size, parsed_size, code_size, error_size
from user_object_size
where name in ('P_CALC_USER_POINTS')
/

--user_source;
select line, text
from user_source
where name = 'P_CALC_USER_POINTS'
order by line
/

select *
from user_source
where name = 'P_CALC_USER_POINTS'
order by line
/

--user_procedures;
select object_type, 
       aggregate, 
       pipelined,
       parallel,
       interface,
       deterministic,
       authid
from user_procedures
where object_name = 'P_CALC_USER_POINTS'
/

select *
from user_procedures
where object_name = 'P_CALC_USER_POINTS'
/

--user_plsql_object_settings
select NAME, PNAME, PVAL 
FROM (
select *
from user_plsql_object_settings
where name = 'P_CALC_USER_POINTS')
UNPIVOT INCLUDE NULLS
(pval for (pname) in (
    --PLSQL_OPTIMIZE_LEVEL AS 'PLSQL_OPTIMIZE_LEVEL',
    PLSQL_CODE_TYPE AS 'PLSQL_CODE_TYPE',
    PLSQL_DEBUG AS 'PLSQL_DEBUG',
    PLSQL_WARNINGS AS 'PLSQL_WARNINGS',
    NLS_LENGTH_SEMANTICS AS 'NLS_LENGTH_SEMANTICS',
    PLSQL_CCFLAGS AS 'PLSQL_CCFLAGS',
    PLSCOPE_SETTINGS AS 'PLSCOPE_SETTINGS'
  )
)
/
--user_stored_settings
select * 
from user_stored_settings
where object_name = 'P_CALC_USER_POINTS'
/

--user_dependencies
SELECT referenced_owner,
       referenced_name rname,
       referenced_type rtype,
       dependency_type dtype
from user_dependencies
where name = 'P_CALC_USER_POINTS'
/

--dbms_describe
DECLARE

/*Declare the local variables of associative array type*/

  v_overload  DBMS_DESCRIBE.NUMBER_TABLE;
  v_position  DBMS_DESCRIBE.NUMBER_TABLE;
  v_level     DBMS_DESCRIBE.NUMBER_TABLE;
  v_arg_name  DBMS_DESCRIBE.VARCHAR2_TABLE;
  v_datatype  DBMS_DESCRIBE.NUMBER_TABLE;
  v_def_value DBMS_DESCRIBE.NUMBER_TABLE;
  v_in_out    DBMS_DESCRIBE.NUMBER_TABLE;
  v_length    DBMS_DESCRIBE.NUMBER_TABLE;
  v_precision  DBMS_DESCRIBE.NUMBER_TABLE;
  v_scale     DBMS_DESCRIBE.NUMBER_TABLE;
  v_radix     DBMS_DESCRIBE.NUMBER_TABLE;
  v_spare     DBMS_DESCRIBE.NUMBER_TABLE;
BEGIN

/*Call the procedure DESCRIBE_PROCEDURE for P_CALC_USER_POINTS */
  DBMS_DESCRIBE.DESCRIBE_PROCEDURE
  (object_name=> 'P_CALC_USER_POINTS',
   reserved1 => null,
   reserved2 => null,
   overload  => v_overload,
   position  => v_position,
   level     => v_level,
   argument_name => v_arg_name,datatype => v_datatype,
   default_value => v_def_value,
   in_out    => v_in_out,
   length    => v_length,
   precision => v_precision,
   scale     => v_scale,
   radix     => v_radix,
   spare     => v_spare,
   include_string_constraints => null);

  FOR i IN v_arg_name.FIRST .. v_arg_name.LAST
  LOOP
   DBMS_OUTPUT.PUT_LINE (RPAD('_',40,'_'));

/*Check if the position if zero or not*/
    IF v_position(i) = 0 THEN

/*Zero position is reserved for RETURN types*/
      DBMS_OUTPUT.PUT_LINE (' RETURN type of the function: ');
      DBMS_OUTPUT.PUT_LINE (rpad('Function Return type:',30,' ')||v_datatype(i));
    ELSE

/*Print the argument name*/
      DBMS_OUTPUT.PUT_LINE (RPAD('Parameter name:',30,' ')||v_arg_name(i));
    END IF;

/*Display the position, type and mode of parameters*/
    DBMS_OUTPUT.PUT_LINE(rpad('Parameter position:',30,' ')||
                         v_position(i));
    DBMS_OUTPUT.PUT_LINE(rpad('Parameter data type:',30,' ')||
                         case v_datatype(i)
            when 1 then 'VARCHAR2'
            when 2 then 'NUMBER'
            when 3 then 'BINARY_INTEGER'
            when 8 then 'LONG'
            when 11 then 'ROWID'
            when 12 then 'DATE'
            when 23 then 'RAW'
            when 24 then 'LONG RAW'
            when 58 then 'OPAQUE TYPE'
            when 96 then 'CHAR'
            when 106 then 'LONG RAW'
            when 121 then 'OBJECT'
            when 122 then 'NESTED TABLE'
            when 123 then 'VARRAY'
            when 178 then 'TIME'
            when 179 then 'TIME WITH TIME ZONE'
            when 180 then 'TIMESTAMP'
            when 230 then 'PL/SQL RECORD'
            when 251 then 'PL/SQL TABLE'
            when 252 then 'PL/SQL BOLLEAN'
           end);
    DBMS_OUTPUT.PUT_LINE(rpad('Parameter default:',30,' ')||
           case v_def_value(i)
            when 0 then 'No Default'
            when 1 then 'Defaulted'
                         end);

    DBMS_OUTPUT.PUT_LINE(rpad('Parameter pass mode:',30,' ')||
                         case v_in_out(i)
            when 0 then 'IN mode'
            when 1 then 'OUT mode'
            when 2 then 'IN OUT mode'
           end);
    DBMS_OUTPUT.PUT_LINE (rpad('_',40,'_'));
    END LOOP;
  END;
/

--Tracking the program execution subprogram call stack
CREATE OR REPLACE PROCEDURE P1
IS
BEGIN
  DBMS_OUTPUT.PUT_LINE ('Executing P1..');
  DBMS_OUTPUT.PUT_LINE (RPAD ('~',15,'~'));
  DBMS_OUTPUT.PUT_LINE (dbms_utility.format_call_Stack);
END;
/

/*Create the procedure P2*/
CREATE OR REPLACE PROCEDURE P2
IS
BEGIN
  DBMS_OUTPUT.PUT_LINE ('Executing P2..');
  DBMS_OUTPUT.PUT_LINE ('Calling P1..');
  DBMS_OUTPUT.PUT_LINE (RPAD ('~',15,'~'));
/*Call procedure P1*/
  P1;
END;
/

/*Create the procedure P3*/
CREATE OR REPLACE PROCEDURE P3
IS
BEGIN
  DBMS_OUTPUT.PUT_LINE ('Executing P3..');
  DBMS_OUTPUT.PUT_LINE ('Calling P2..');
  DBMS_OUTPUT.PUT_LINE (RPAD ('~',15,'~'));
/*Call procedure P2*/
  P2;
END;
/

/*Start a PL/SQL block to invoke P3*/
BEGIN
/*Call P3*/
  P3;
END;
/

/*Create the procedure to print call stack using UTL_CALL_STACK*/
CREATE OR REPLACE PROCEDURE show_call_stack
is
   lvl PLS_INTEGER;
BEGIN

  /*Retrieve the dynamic depth of the call stack */
  lvl := UTL_CALL_STACK.DYNAMIC_DEPTH();

  /*Iterate the call depth structure */
  FOR i IN 1..lvl LOOP
    DBMS_OUTPUT.put_line(
      RPAD('Call depth:'||UTL_CALL_STACK.lexical_depth(i), 15)||
      RPAD('Line:'||TO_CHAR(UTL_CALL_STACK.unit_line(i),'99'), 15)||
      UTL_CALL_STACK.CONCATENATE_SUBPROGRAM
      (UTL_CALL_STACK.SUBPROGRAM(i))
    );
  END LOOP;
END;
/

/*Create a procedure to invoke SHOW_CALL_STACK */
CREATE OR REPLACE PROCEDURE p_calc_point_callstack
(p_user VARCHAR2, p_correct NUMBER, p_wrong NUMBER)
IS
 l_num NUMBER;

 FUNCTION f_calc_points (p_ques NUMBER, p_factor NUMBER)
 RETURN NUMBER
 IS
 BEGIN
  /*Invoke SHOW_CALL_STACK */
  show_call_stack;
  RETURN (p_ques*p_factor);
 END;

 PROCEDURE p_net_calc (p_net_points OUT NUMBER) IS
 BEGIN
  p_net_points := f_calc_points (p_correct,4) + f_calc_points (p_wrong,-2);
 END;
BEGIN
 p_net_calc (l_num);
 DBMS_OUTPUT.PUT_LINE (USER||' earned '||TO_CHAR (l_num)||' points');
end;
/


BEGIN
 p_calc_point_callstack (user, 10, 3);
END;
/


--Tracking propagating exceptions in PL/SQL code
/*Create a procedure to trace print error stack */
CREATE OR REPLACE PROCEDURE p_calc_point_errStack
(p_user VARCHAR2, p_correct NUMBER, p_wrong NUMBER)
IS
 l_num     NUMBER;

 /*Declare user defined exceptions */
 myFunExp   EXCEPTION;
 myProcExp   EXCEPTION;
 myBlkExp   EXCEPTION;
 PRAGMA EXCEPTION_INIT(myFunExp,-20020);
 PRAGMA EXCEPTION_INIT(myProcExp,-20021);
 PRAGMA EXCEPTION_INIT(myBlkExp,-20022);

 /*Explicitly raise the user defined exception in the local function*/
 FUNCTION f_calc_points (p_ques NUMBER, p_factor NUMBER)
 RETURN NUMBER
 IS
 BEGIN
   RAISE myFunExp;
   RETURN (p_ques*p_factor);
 EXCEPTION
 WHEN myFunExp THEN
   RAISE myProcExp;
 END;

/*Explicitly raise the user defined exception in the local procedure */
 PROCEDURE p_net_calc (p_net_points OUT NUMBER) IS
 BEGIN
  p_net_points := f_calc_points (p_correct,4) + f_calc_points (p_wrong,-2);
 EXCEPTION
 WHEN myProcExp THEN
   RAISE myBlkExp;
 END;

/*Explicitly raise the user defined exception in the program body*/
BEGIN
 p_net_calc (l_num);
 DBMS_OUTPUT.PUT_LINE (USER||' earned '||to_char (l_num)||' points');
EXCEPTION
 WHEN myBlkExp THEN
    DBMS_OUTPUT.PUT_LINE( '-----DBMS_UTILITY.FORMAT_ERROR_BACKTRACE');
    DBMS_OUTPUT.PUT_LINE( DBMS_UTILITY.FORMAT_ERROR_BACKTRACE );
    DBMS_OUTPUT.PUT_LINE( '-----DBMS_UTILITY.format_error_stack');
    DBMS_OUTPUT.PUT_LINE( DBMS_UTILITY.format_error_stack );
END;
/

BEGIN
 p_calc_point_errstack (USER, 10, 3);
END;
/


/*Create a procedure to print error stack using UTL_CALL_STACK*/
CREATE OR REPLACE PROCEDURE display_error_stack AS
  l_depth PLS_INTEGER;
BEGIN

  /*Retrieve the count of the error stack */
  l_depth := UTL_CALL_STACK.ERROR_DEPTH;

  /*Iterate the error stack structure to print errors */
  FOR i IN 1..l_depth LOOP
    DBMS_OUTPUT.put_line(
    RPAD(i, 10)||
    RPAD('ORA-'||LPAD(UTL_CALL_STACK.error_number(i), 5, '0'), 10)||
    UTL_CALL_STACK.error_msg(i)
    );
  END LOOP;
END;
/

/*Rewrite the procedural logic to invoke DISPLAY_ERROR_STACK*/
CREATE OR REPLACE PROCEDURE p_calc_point_errStack
(p_user VARCHAR2, p_correct NUMBER, p_wrong NUMBER)
IS
 l_num NUMBER;

 /*Declare user-defined exceptions */
 myFunExp EXCEPTION;
 myProcExp EXCEPTION;
 myBlkExp EXCEPTION;
 PRAGMA EXCEPTION_INIT(myFunExp,-20020);
 PRAGMA EXCEPTION_INIT(myProcExp,-20021);
 PRAGMA EXCEPTION_INIT(myBlkExp,-20022);

 /*Explicitly raise the user defined exception in the local function*/
 FUNCTION f_calc_points (p_ques NUMBER, p_factor NUMBER)
 RETURN NUMBER
 IS
 BEGIN
   RAISE myFunExp;
   RETURN (p_ques*p_factor);
 EXCEPTION
 WHEN myFunExp THEN
   RAISE myProcExp;
 END;

 /*Explicitly raise the user defined exception in the local procedure*/
 PROCEDURE p_net_calc (p_net_points OUT NUMBER) IS
 BEGIN
  p_net_points := f_calc_points (p_correct,4) + f_calc_points (p_wrong,-2);
 EXCEPTION
 WHEN myProcExp THEN
   RAISE myBlkExp;
 END;

/*Explicitly raise the user defined exception in the program body*/
BEGIN
 p_net_calc (l_num);
 DBMS_OUTPUT.PUT_LINE (USER||' earned '||to_char (l_num)||' points');
EXCEPTION
 WHEN myBlkExp THEN
    display_error_stack;
END;
/

BEGIN
 p_calc_point_errStack (user, 10, 3);
END;
/
