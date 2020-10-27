

delete from lovbrudd_09405_working_on 
where "value pr. lovbrudd " = 0;


select �.�r_id, s.statistikkvariabel_id, lwo.value from  statistikkvariabel s 
left join lovbrudd_09405_working_on l using(statistikkvariabel_id)
left join lovbrudd_11453_working_on  lwo using(statistikkvariabel_id, �r_id)
left join �r � using(�r_id);

select �.�r_id, lwo.value, s.statistikkvariabel_id, l."value pr. lovbrudd "
right join lovbrudd_09405_working_on l using(�r_id,statistikkvariabel_id)
from lovbrudd_11453_working_on lwo
left join �r � using(�r_id)
left join kj�nn k using(kj�nn_id)
join statistikkvariabel s using(statistikkvariabel_id);


--------------------------------- lovbrudd_09405_working_on ---------------------------------
alter table lovbrudd_09405_working_on 
add foreign key(�r_id)
references �r(�r_id);

alter table lovbrudd_09405_working_on 
add foreign key(lovbrudds_id)
references lovbruddstyper(lovbrudds_id);

alter table lovbrudd_09405_working_on 
add foreign key(statistikkvariabel_id)
references statistikkvariabel(statistikkvariabel_id);

--------------------------------- lovbrudd_11453_working_on ---------------------------------

alter table lovbrudd_11453_working_on 
add foreign key(�r_id)
references �r(�r_id);

alter table lovbrudd_11453_working_on 
add foreign key(kj�nn_id)
references kj�nn(kj�nn_id);

alter table lovbrudd_11453_working_on 
add foreign key(alder_id)
references alder_grupper(alder_id);

alter table lovbrudd_11453_working_on 
add foreign key(statistikkvariabel_id)
references statistikkvariabel(statistikkvariabel_id);









---------------------------------------------------------------------------------------------------------------
create table fact_v2 as (
select * from lovbrudd_11453_working_on lwo2 lwo
);
select * from lovbrudd_09405_working_on lwo;
select * from lovbrudd_11453_working_on lwo;

create table fact_v2 (id serial primary key not null, statistikkvariabel_id int, lovbrudds_id int, �r_id int, kj�nn_id int, alder_id int, value float, value_lovbrudd float);


insert into fact_v2 (value_lovbrudd ,statistikkvariabel_id, lovbrudds_id, �r_id)  select * from lovbrudd_09405_working_on;

insert into fact_v2(�r_id, kj�nn_id, alder_id, statistikkvariabel_id, value ) select * from lovbrudd_11453_working_on;

select * from fact_v2

-------------------- relations ------------------------------------------
alter table lovbruddsdata.fact_v2
add foreign key (alder_id)
references lovbruddsdata.alder_grupper(alder_id);

alter table lovbruddsdata.fact_v2 
add foreign key (�r_id )
references lovbruddsdata.�r(�r_id);

alter table lovbruddsdata.fact_v2 
add foreign key (kj�nn_id )
references lovbruddsdata.kj�nn(kj�nn_id);

alter table lovbruddsdata.fact_v2
add foreign key (statistikkvariabel_id)
references lovbruddsdata.statistikkvariabel(statistikkvariabel_id);

alter table lovbruddsdata.fact_v2 
add foreign key (lovbrudds_id)
references lovbruddsdata.lovbruddstyper(lovbrudds_id);









--------------------------------------- TEST FACT table-------------------------------------------------

select l.lovbruddstype ,f2.value_lovbrudd, �.�r from fact_v2 f2
join lovbruddstyper l using(lovbrudds_id)
join �r � using (�r_id);


select f2.value, k.kj�nn , ag.alder from fact_v2 f2
join kj�nn k using (kj�nn_id)
join alder_grupper ag using(alder_id);














------------------------ transform the star schema --------------------------------



select * from lovbruddsdata.fact_v2;

select * from �r;
select * from lovbruddstyper l;
select * from kj�nn k;
select * from alder_grupper ag;
select * from statistikkvariabel s;

create table star_lovbrudd.fakta_v2 as (
select * from lovbruddsdata.fact_v2);

create table star_lovbrudd.�r as (
select * from lovbruddsdata.�r);

create table star_lovbrudd.lovbruddstyper as (
select * from lovbruddsdata.lovbruddstyper);

create table star_lovbrudd.kj�nn as (
select * from lovbruddsdata.kj�nn);

create table star_lovbrudd.alder_grupper as (
select * from lovbruddsdata.alder_grupper);

create table star_lovbrudd.statistikkvariabel as (
select * from lovbruddsdata.statistikkvariabel);



alter table star_lovbrudd.fakta_v2
add primary key(id);


alter table star_lovbrudd.�r
add primary key(�r, �r_id);

----
alter table star_lovbrudd.lovbruddstyper
add primary key(lovbrudds_id, lovbruddstype);

alter table star_lovbrudd.kj�nn
add primary key(kj�nn, kj�nn_id);

alter table star_lovbrudd.alder_grupper
add primary key(alder, alder_id);

alter table star_lovbrudd.statistikkvariabel
add primary key(statistikkvariabel, statistikkvariabel_id);

-------------- relations-------------------

alter table star_lovbrudd.fakta_v2
add foreign key (alder_id)
references star_lovbrudd.alder_grupper(alder_id);

alter table star_lovbrudd.fakta_v2 
add foreign key(�r_id)
references star_lovbrudd.�r(�r_id);

alter table star_lovbrudd.fakta_v2 
add foreign key (kj�nn_id )
references star_lovbrudd.kj�nn(kj�nn_id);

alter table star_lovbrudd.fakta_v2
add foreign key (statistikkvariabel_id)
references star_lovbrudd.statistikkvariabel(statistikkvariabel_id);

alter table star_lovbrudd.fakta_v2 
add foreign key (lovbrudds_id)
references star_lovbrudd.lovbruddstyper(lovbrudds_id);
