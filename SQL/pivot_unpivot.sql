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

select * from (
select * 
from plch_sales
unpivot
(sales_sum for corp_type in (private, corporate, government))
)
pivot (
  sum(sales_sum)
  for region in (
    'AMER' AS AMER,
    'ASOC' AS ASOC,
    'EMEA' AS EMEA
  )
)
/

select * from (
select * from plch_sales
pivot (
  sum(private) as private,
  sum(corporate) as corporate,
  sum(government) as government
  for region in ('AMER' AS AMER, 'ASOC' AS ASOC, 'EMEA' AS EMEA)
)
)
unpivot (
  (AMER, ASOC, EMEA)
  FOR CUST_GROP IN (
    (AMER_PRIVATE, EMEA_PRIVATE, ASOC_PRIVATE) AS 'PRIVATE',
    (AMER_GOVERNMENT, EMEA_GOVERNMENT, ASOC_GOVERNMENT) AS 'GOVERNMENT',
    (AMER_CORPORATE, EMEA_CORPORATE, ASOC_CORPORATE) AS 'CORPORATE'
)
)
/
alter session set nls_date_format='YYYY Mon'
/
