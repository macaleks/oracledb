create sequence beer_seq;
create table beers
(
 id   number default beer_seq.nextval
,name varchar2(40)
,brewery varchar2(40)
,constraint beers_pk primary key (id)
)
/

drop table beers
/

create table beers
(id number generated always as identity
,name varchar2(40)
,brewery varchar2(40)
,constraint beers_pk primary key(id)
)
/

select column_name, data_default
from user_tab_columns
where table_name = 'BEERS'
order by column_id
/

SELECT *
from user_OBJECTS
ORDER BY CREATED DESC
/

--FAILED ACTION
RENAME ISEQ$$_74184 TO BEER_SEQ;

--POPULATE
INSERT INTO beers (name, brewery) VALUES ('Kirchlibr?u', 'Arosabr?u');
INSERT INTO beers (name, brewery) VALUES ('1800m IPA', 'Arosabr?u');
INSERT INTO beers (name, brewery) VALUES ('Schanfigger H?x', 'Arosabr?u');
COMMIT;

SELECT * FROM beers;

--expdp qz/qz dumpfile=beers.dmp tables=qz.beers
--impdp qz/qz dumpfile=beers.dmp remap_schema=qz:hr