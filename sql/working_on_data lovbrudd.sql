

delete from lovbrudd_09405_working_on 
where "value pr. lovbrudd " = 0;


select å.år_id, s.statistikkvariabel_id, lwo.value from  statistikkvariabel s 
left join lovbrudd_09405_working_on l using(statistikkvariabel_id)
left join lovbrudd_11453_working_on  lwo using(statistikkvariabel_id, år_id)
left join år å using(år_id);

select å.år_id, lwo.value, s.statistikkvariabel_id, l."value pr. lovbrudd "
right join lovbrudd_09405_working_on l using(år_id,statistikkvariabel_id)
from lovbrudd_11453_working_on lwo
left join år å using(år_id)
left join kjønn k using(kjønn_id)
join statistikkvariabel s using(statistikkvariabel_id);


--------------------------------- lovbrudd_09405_working_on ---------------------------------
alter table lovbrudd_09405_working_on 
add foreign key(år_id)
references år(år_id);

alter table lovbrudd_09405_working_on 
add foreign key(lovbrudds_id)
references lovbruddstyper(lovbrudds_id);

alter table lovbrudd_09405_working_on 
add foreign key(statistikkvariabel_id)
references statistikkvariabel(statistikkvariabel_id);

--------------------------------- lovbrudd_11453_working_on ---------------------------------

alter table lovbrudd_11453_working_on 
add foreign key(år_id)
references år(år_id);

alter table lovbrudd_11453_working_on 
add foreign key(kjønn_id)
references kjønn(kjønn_id);

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

create table fact_v2 (id serial primary key not null, statistikkvariabel_id int, lovbrudds_id int, år_id int, kjønn_id int, alder_id int, value float, value_lovbrudd float);


insert into fact_v2 (value_lovbrudd ,statistikkvariabel_id, lovbrudds_id, år_id)  select * from lovbrudd_09405_working_on;

insert into fact_v2(år_id, kjønn_id, alder_id, statistikkvariabel_id, value ) select * from lovbrudd_11453_working_on;

select * from fact_v2

-------------------- relations ------------------------------------------
alter table lovbruddsdata.fact_v2
add foreign key (alder_id)
references lovbruddsdata.alder_grupper(alder_id);

alter table lovbruddsdata.fact_v2 
add foreign key (år_id )
references lovbruddsdata.år(år_id);

alter table lovbruddsdata.fact_v2 
add foreign key (kjønn_id )
references lovbruddsdata.kjønn(kjønn_id);

alter table lovbruddsdata.fact_v2
add foreign key (statistikkvariabel_id)
references lovbruddsdata.statistikkvariabel(statistikkvariabel_id);

alter table lovbruddsdata.fact_v2 
add foreign key (lovbrudds_id)
references lovbruddsdata.lovbruddstyper(lovbrudds_id);









--------------------------------------- TEST FACT table-------------------------------------------------

select l.lovbruddstype ,f2.value_lovbrudd, å.år from fact_v2 f2
join lovbruddstyper l using(lovbrudds_id)
join år å using (år_id);


select f2.value, k.kjønn , ag.alder from fact_v2 f2
join kjønn k using (kjønn_id)
join alder_grupper ag using(alder_id);














------------------------ transform the star schema --------------------------------



select * from lovbruddsdata.fact_v2;

select * from år;
select * from lovbruddstyper l;
select * from kjønn k;
select * from alder_grupper ag;
select * from statistikkvariabel s;

create table star_lovbrudd.fakta_v2 as (
select * from lovbruddsdata.fact_v2);

create table star_lovbrudd.år as (
select * from lovbruddsdata.år);

create table star_lovbrudd.lovbruddstyper as (
select * from lovbruddsdata.lovbruddstyper);

create table star_lovbrudd.kjønn as (
select * from lovbruddsdata.kjønn);

create table star_lovbrudd.alder_grupper as (
select * from lovbruddsdata.alder_grupper);

create table star_lovbrudd.statistikkvariabel as (
select * from lovbruddsdata.statistikkvariabel);



alter table star_lovbrudd.fakta_v2
add primary key(id);


alter table star_lovbrudd.år
add primary key(år, år_id);

----
alter table star_lovbrudd.lovbruddstyper
add primary key(lovbrudds_id, lovbruddstype);

alter table star_lovbrudd.kjønn
add primary key(kjønn, kjønn_id);

alter table star_lovbrudd.alder_grupper
add primary key(alder, alder_id);

alter table star_lovbrudd.statistikkvariabel
add primary key(statistikkvariabel, statistikkvariabel_id);

-------------- relations-------------------

alter table star_lovbrudd.fakta_v2
add foreign key (alder_id)
references star_lovbrudd.alder_grupper(alder_id);

alter table star_lovbrudd.fakta_v2 
add foreign key(år_id)
references star_lovbrudd.år(år_id);

alter table star_lovbrudd.fakta_v2 
add foreign key (kjønn_id )
references star_lovbrudd.kjønn(kjønn_id);

alter table star_lovbrudd.fakta_v2
add foreign key (statistikkvariabel_id)
references star_lovbrudd.statistikkvariabel(statistikkvariabel_id);

alter table star_lovbrudd.fakta_v2 
add foreign key (lovbrudds_id)
references star_lovbrudd.lovbruddstyper(lovbrudds_id);
