declare
  v simple_integer := 2147483646;
  procedure p (v varchar2) as
  begin
    dbms_output.put_line(v);
  end p;
begin
  null;
  p(v);
  v := v + 1;
  p(v);
  v := v + 1;
  p(v);
  v := v + 1;
  p(v);
  v := v - 1;
  p(v);
end;
/
