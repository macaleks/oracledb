declare
  --type ntt is table of number;--1
  --type ntt is table of pls_integer index by pls_integer;--2
  nt ntt;
begin
  --1
/*  select rownum
  bulk collect into nt
  from dual connect by level <= 10;

  forall i in indices of nt--works
    insert into ntt(n) values (nt(i));
      
  forall i in values of nt--pls-00667
    insert into ntt(n) values (i);
*/    
  --2  
  /*select rownum
  bulk collect into nt
  from dual connect by level <= 10;

  forall i in values of nt--works
    insert into ntt(n) values (nt(i)); 
    
  forall i in indices of nt--works
    insert into ntt(n) values (nt(i));  */
    
  --with varchar it doesn't work
end;
/

select * from ntt;

create table ntt_tab(n number, v varchar2(100), d date)
/
