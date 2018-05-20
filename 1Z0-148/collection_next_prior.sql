declare
  type ntt is table of number;
  type att is table of number index by simple_integer;
  nt ntt;
  "at" att;
   idx number := 1;
begin
  null;
  --ntt
  dbms_output.put_line('ntt');
  select rownum
  bulk collect into nt
  from dual connect by level <= 10;
  
  dbms_output.put_line(nt(idx));
  
  idx := nt.next(idx);
  dbms_output.put_line(idx);
  
  --att
  dbms_output.put_line('att');
  idx := 1;
  
  select rownum
  bulk collect into "at"
  from dual connect by level <= 10;

  dbms_output.put_line(nt(idx));

  idx := nt.next(idx);
  dbms_output.put_line(idx);
end;
/
