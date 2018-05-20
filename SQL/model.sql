drop table plch_sales
/
create table plch_sales (
   region      varchar2(4)
 , month       date
 , private     number
 , corporate   number
 , government  number
)
/

insert into plch_sales values (
   'AMER', date '2015-01-01', 15000, 45500, 22250)
/
insert into plch_sales values (
   'ASOC', date '2015-01-01',  8500, 37000, 55225)
/
insert into plch_sales values (
   'EMEA', date '2015-01-01', 42500, 39750, 11550)
/
insert into plch_sales values (
   'AMER', date '2015-02-01', 12500, 48000, 19400)
/
insert into plch_sales values (
   'ASOC', date '2015-02-01',  9800, 32650, 52300)
/
insert into plch_sales values (
   'EMEA', date '2015-02-01', 46200, 41900, 10225)
/
commit
/

So in the table, rows contain regions and columns contain our customer groups.

I would like to swap row and column dimensions, so I view regions as columns and customer groups as rows.

Which of the choices contain a query that returns this desired output:

CUST_GROUP MONTH          AMER       ASOC       EMEA
---------- -------- ---------- ---------- ----------
CORPORATE  2015 Jan      45500      37000      39750
GOVERNMENT 2015 Jan      22250      55225      11550
PRIVATE    2015 Jan      15000       8500      42500
CORPORATE  2015 Feb      48000      32650      41900
GOVERNMENT 2015 Feb      19400      52300      10225
PRIVATE    2015 Feb      12500       9800      46200
Note: The output has been formatted using this NLS setting:

select cust_group, month, amer, asoc, emea
  from (
   select *
     from plch_sales
    model
      dimension by (
         region, month
       , cast(null as varchar2(10)) cust_group
      )
      measures (
         private, corporate, government
       , cast(null as number) amer
       , cast(null as number) asoc
       , cast(null as number) emea
      )
      rules upsert all (
         amer[null, any, 'PRIVATE'   ] = private   ['AMER', cv(), null]
       , amer[null, any, 'CORPORATE' ] = corporate ['AMER', cv(), null]
       , amer[null, any, 'GOVERNMENT'] = government['AMER', cv(), null]
       , asoc[null, any, 'PRIVATE'   ] = private   ['ASOC', cv(), null]
       , asoc[null, any, 'CORPORATE' ] = corporate ['ASOC', cv(), null]
       , asoc[null, any, 'GOVERNMENT'] = government['ASOC', cv(), null]
       , emea[null, any, 'PRIVATE'   ] = private   ['EMEA', cv(), null]
       , emea[null, any, 'CORPORATE' ] = corporate ['EMEA', cv(), null]
       , emea[null, any, 'GOVERNMENT'] = government['EMEA', cv(), null]
      )
  )
 where cust_group is not null
 order by month, cust_group
/
