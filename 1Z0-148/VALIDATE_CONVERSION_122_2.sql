create table qz_input (
   name  varchar2(20)
 , dob   varchar2(10)
)
/

insert into qz_input values ('Malcolm McMoonie', '1970-10-10')
/
insert into qz_input values ('Nelson Newbury'  , '1975.05.05')
/
insert into qz_input values ('Oscar O''Rourke' , '1965-30-01')
/
insert into qz_input values ('Paddy Patricks'  , '11/11/80'  )
/
commit
/

--------------------------------------------------------------------------------
select name, dob as bad_input
  from qz_input
where validate_conversion(dob AS DATE, 'YYYY-MM-DD') = 0
 order by name
/

select name, dob as bad_input
  from qz_input
where to_date(
          dob default NULL on conversion error
        , 'YYYY-MM-DD'
       ) IS NULL
 order by name
/

select name, dob as bad_input
  from qz_input
 where to_date(
          dob default '3999-12-31' on conversion error
        , 'YYYY-MM-DD'
       ) = DATE '3999-12-31'
 order by name
/

