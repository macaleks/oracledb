drop table qz_deliveries
/

create table qz_deliveries (
  delivery_id   int not null primary key ,
  address_id    int not null ,
  delivery_date varchar2(30) not null
)
/

truncate table qz_deliveries
/
--1
alter table qz_deliveries add constraint qz_date_c check (
  to_date ( 
    delivery_date default null on conversion error, 'FXYYYY/MM/DD' 
  ) is not null or
  to_date ( 
    delivery_date default null on conversion error, 'FXDD-MON-YYYY' 
  ) is not null
)
/

--2
alter table qz_deliveries add constraint qz_date_c check (
  validate_conversion ( delivery_date as date , 'FXYYYY/MM/DD' ) = 1 
  or
  validate_conversion ( delivery_date as date , 'FXDD-MON-YYYY' ) = 1
)
/

/* These must insert a row */
insert into qz_deliveries (
  delivery_id , address_id , delivery_date 
) values (1 , 1 , '2017/08/31' );
insert into qz_deliveries (
  delivery_id , address_id , delivery_date 
) values (2 , 2 , '31-AUG-2017');

/* These must raise an exception */
insert into qz_deliveries (
  delivery_id , address_id , delivery_date 
) values (3 , 3 , 'AUG/2017/31');
insert into qz_deliveries (
  delivery_id , address_id , delivery_date 
) values (4 , 4 , 'invalid date');
insert into qz_deliveries (
  delivery_id , address_id , delivery_date 
) values (5 , 5 , '31#AUG#2017');