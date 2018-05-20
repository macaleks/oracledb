declare
  l_temp_lob clob;
  amt number;
  offset number := 15;
  
  l_write varchar2(100) := 'Text to write';
  l_append varchar2(100) := 'Text to append';
begin
  dbms_lob.createtemporary(lob_loc => l_temp_lob,
                           cache => true,
                           dur => dbms_lob.session);
                           
  if dbms_lob.istemporary(l_temp_lob) = 1 then
    dbms_output.put_line('This is temp lob');
  else
    dbms_output.put_line('Given lob is not temp');
  end if;
  
  dbms_lob.open(lob_loc => l_temp_lob,
                open_mode => dbms_lob.lob_readwrite);
                
  dbms_lob.write(lob_loc => l_temp_lob,    
                 amount  => length(l_write),
                 offset  => offset,
                 buffer  => l_write);
                 
  dbms_output.put_line('Length afte write is ' || dbms_lob.getlength(l_temp_lob));
  
  dbms_lob.writeappend(lob_loc => l_temp_lob,
                       amount => length(l_append),
                       buffer => l_append);
                       
  dbms_output.put_line('Length afte write is ' || dbms_lob.getlength(l_temp_lob));
  
  dbms_output.put_line(dbms_lob.substr(lob_loc => l_temp_lob,
                                       amount =>  dbms_lob.getlength(l_temp_lob),
                                       offset => 1));
                                       
  dbms_output.new_line();
  dbms_output.new_line();
  dbms_output.new_line();
  
  dbms_output.put_line(l_temp_lob);
  
  dbms_lob.close(l_temp_lob);
  dbms_lob.freetemporary(l_temp_lob);                      
end;
/
