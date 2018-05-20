create table plch_regions (
   id          varchar2(4) primary key
 , name        varchar2(30)
)
/

create table plch_countries (
   id          varchar2(3) primary key
 , name        varchar2(30)
 , region_id   varchar2(4) not null references plch_regions
)
/

create table plch_players (
   id          integer     primary key
 , name        varchar2(30)
 , country_id  varchar2(3) not null references plch_countries
 , score       number
)
/

insert into plch_regions values ('AMER', 'North-/South America')
/
insert into plch_regions values ('ASOC', 'Asia/Oceania')
/
insert into plch_regions values ('EMEA', 'Europe/Middle East/Africa')
/

insert into plch_countries values ('CHL', 'Chile'      , 'AMER')
/
insert into plch_countries values ('USA', 'USA'        , 'AMER')
/
insert into plch_countries values ('IDN', 'Indonesia'  , 'ASOC')
/
insert into plch_countries values ('NZL', 'New Zealand', 'ASOC')
/
insert into plch_countries values ('DNK', 'Denmark'    , 'EMEA')
/
insert into plch_countries values ('TCD', 'Chad'       , 'EMEA')
/

insert into plch_players values (11, 'Noelle Barahona', 'CHL', 440)
/
insert into plch_players values (12, 'Michael Phelps' , 'USA', 440)
/
insert into plch_players values (13, 'Liliyana Natsir', 'IDN', 450)
/
insert into plch_players values (14, 'Hamish Bond'    , 'NZL', 410)
/
insert into plch_players values (15, 'Joachim Olsen'  , 'DNK', 460)
/
insert into plch_players values (16, 'Paul Ngadjadoum', 'TCD', 420)
/

commit
/

select r.name region
     , sum(p.score) over (
          partition by r.id
       ) region_score
     , (
         select r2.region_rank
           from (
            select r3.id
                 , rank() over (
                      order by sum(p.score) desc
                   ) region_rank
              from plch_players p
              join plch_countries c
                  on c.id = p.country_id
              join plch_regions r3
                  on r3.id = c.region_id
             group by r3.id
           ) r2
          where r2.id = r.id
       ) region_rank
     , p.name player
     , p.score
     , rank() over (
          partition by r.id
          order by p.score desc
       ) rank_in_region
  from plch_players p
  join plch_countries c
      on c.id = p.country_id
  join plch_regions r
      on r.id = c.region_id
 order by region_rank
        , r.id
        , rank_in_region
        , p.id
/

with region_scores as (
   select r.id
        , max(r.name) region
        , sum(p.score) region_score
        , rank() over (
             order by sum(p.score) desc
          ) region_rank
     from plch_players p
     join plch_countries c
         on c.id = p.country_id
     join plch_regions r
         on r.id = c.region_id
    group by r.id
)
select rs.region
     , rs.region_score
     , rs.region_rank
     , p.name player
     , p.score
     , rank() over (
          partition by rs.id
          order by p.score desc
       ) rank_in_region
  from plch_players p
  join plch_countries c
      on c.id = p.country_id
  join region_scores rs
      on rs.id = c.region_id
 order by rs.region_rank
        , rs.id
        , rank_in_region
        , p.id
/

select region
     , region_score
     , first_value(region_rank ignore nulls) over (
          partition by region_id
          order by rn
       ) region_rank
     , player
     , score
     , rank_in_region
  from (
   select region
        , region_score
        , rn
        , case rn
             when 1 then
                rank() over (
                   partition by rn
                   order by region_score desc
                )
          end region_rank
        , player
        , score
        , rank_in_region
        , region_id
        , player_id
     from (
      select r.name region
           , sum(p.score) over (
                partition by r.id
             ) region_score
           , row_number() over (
                partition by r.id
                order by p.score desc
             ) rn
           , p.name player
           , p.score
           , rank() over (
                partition by r.id
                order by p.score desc
             ) rank_in_region
           , r.id region_id
           , p.id player_id
        from plch_players p
        join plch_countries c
            on c.id = p.country_id
        join plch_regions r
            on r.id = c.region_id
     )
  )
 order by region_rank
        , region_id
        , rank_in_region
        , player_id
/