-------------------------------------------------------------- alder --------------------------------------------------------------

create table lovbruddsdata.alder_grupper as (
select distinct(lt.alder) from lovbrudd_11453_test lt
where lt.alder != 'Alle aldre 5 �r og over' and lt.alder != 'I alt' order by lt.alder asc);

alter table lovbruddsdata.alder_grupper 
add column alder_id serial unique;

alter table lovbruddsdata.alder_grupper 
add primary key (alder_id, alder);

alter table lovbruddsdata.alder_grupper 
alter column alder_id type int4 using (alder_id::int4);

alter table lovbruddsdata.lovbrudd_11453_test 
add column alder_id int4;

create table lovbruddsdata.lovbrudd_11453 as ( 
select * from lovbrudd_11453_test lt
left join alder_grupper ag using (alder));

alter table lovbrudd_11453 
add foreign key (alder_id)
references alder_grupper(alder_id);

-------------------------------------------------------------- kj�nn --------------------------------------------------------------

create table lovbruddsdata.kj�nn as (
select distinct(lt.kj�nn) from lovbrudd_11453_test lt);

alter table lovbruddsdata.kj�nn 
add column kj�nn_id serial unique;

alter table lovbruddsdata.kj�nn 
add primary key (kj�nn_id, kj�nn);

create table lovbruddsdata.lovbrudd_11453_alder as (
select *  
from lovbrudd_11453_test lt
left join lovbruddsdata.alder_grupper using (alder));

create table lovbruddsdata.lovbrudd_11453_ferdig as (
select * from lovbruddsdata.lovbrudd_11453_alder lt
left join lovbruddsdata.kj�nn k using (kj�nn));

------------------------------------ BIN kj�nn og alder-----------------------------------------------------------

alter table lovbruddsdata.lovbrudd_11453_ferdig 
add foreign key (alder_id)
references lovbruddsdata.alder_grupper(alder_id);

alter table lovbruddsdata.lovbrudd_11453_ferdig
add foreign key (kj�nn_id)
references lovbruddsdata.kj�nn(kj�nn_id);

alter table lovbruddsdata.lovbrudd_11453_ferdig
add foreign key (�r_id)
references lovbruddsdata.�r(�r_id);

select * from lovbruddsdata.lovbrudd_11453_ferdig lf;


-------------------------------------------------------------- Lovbrudd --------------------------------------------------------------

create table lovbruddsdata.lovbruddstyper as(
select distinct(lt.lovbruddstype) from lovbruddsdata.lovbrudd_09405_test lt);

alter table lovbruddsdata.lovbruddstyper
add column lovbrudds_id serial unique;

alter table lovbruddsdata.lovbruddstyper
add primary key (lovbruddstype, lovbrudds_id);

create table lovbruddsdata.lovbrudd_09405_lovbruddstype as(
select * from lovbruddsdata.lovbrudd_09405_test lt 
left join lovbruddsdata.lovbruddstyper l using (lovbruddstype));


alter table lovbruddsdata.lovbrudd_09405_lovbruddstype 
add foreign key (lovbrudds_id)
references lovbruddsdata.lovbruddstyper(lovbrudds_id);
-------------------------------------------------------------- statistikk variabel --------------------------------------------------------------
create table lovbruddsdata.statistikkvariabel as (
select distinct(lf.statistikkvariabel) from lovbruddsdata.lovbrudd_11453_ferdig lf);

create table lovbruddsdata.lovbrudd_09405_ferdig as (
select * from lovbruddsdata.lovbrudd_09405_lovbruddstype lt
left join lovbruddsdata.statistikkvariabel k using (statistikkvariabel));

alter table lovbruddsdata.statistikkvariabel
add column statistikkvariabel_id serial unique;



insert into lovbruddsdata.statistikkvariabel 
values('Lovbrudd etterforsket');

select * from lovbruddsdata.lovbrudd_11453_ferdig s;


alter table lovbruddsdata.lovbrudd_09405_ferdig 
add foreign key (statistikkvariabel_id)
references lovbruddsdata.statistikkvariabel(statistikkvariabel_id);


create table lovbruddsdata.lovbrudd_11453_ferdig as (
select * from lovbruddsdata.lovbrudd_11453_ferdig1 lf 
left join lovbruddsdata.statistikkvariabel s using(statistikkvariabel)
);

alter table lovbruddsdata.lovbrudd_11453_ferdig
add foreign key (�r_id)
references lovbruddsdata.�r(�r_id);


alter table lovbruddsdata.lovbrudd_11453_ferdig
add foreign key (statistikkvariabel_id)
references lovbruddsdata.statistikkvariabel(statistikkvariabel_id);

select * from lovbruddsdata.f ;
------------------------------------------- fact table ------------------------------------------------------------
select * from lovbruddsdata.statistikkvariabel s ;

create table lovbruddsdata.fact_v2 as (
select  from lovbruddsdata.lovbrudd_09405_ferdig lf
join lovbruddsdata.lovbrudd_11453_ferdig lf2 using (�r_id)
join lovbruddsdata.alder_grupper ag using(alder_id));


create table lovbruddsdata.fakta_lovbrudd as(


select lf2.statistikkvariabel_id ,ag.alder_id , k.kj�nn_id , �.�r_id , l.lovbrudds_id , l.value_sum_pr_�r ,lf2.sum 
from lovbruddsdata.lovbrudd_11453_ferdig lf2 
left join lovbruddsdata.lovbrudd_09405_ferdig l using(�r_id)
left join lovbruddsdata.statistikkvariabel s using(statistikkvariabel_id)
left join lovbruddsdata.�r � on �.�r_id = s.�r_id 
left join lovbruddsdata.lovbruddstyper l using(lovbrudds_id)
left join lovbruddsdata.kj�nn k using(kj�nn_id)
left join lovbruddsdata.alder_grupper ag using(alder_id)

);

select count(*) from lovbruddsdata.fakta_lovbrudd;

create table lovbruddsdata.all_data as (
select lf.statistikkvariabel_id ,lf2.alder_id , lf2.kj�nn_id , lf2.�r_id , s.lovbrudds_id , s.value_sum_pr_�r ,lf2.sum ,�.�r from lovbruddsdata.statistikkvariabel lf 
left join lovbruddsdata.lovbrudd_11453_ferdig lf2 on  lf2.statistikkvariabel_id = lf.statistikkvariabel_id 
left join lovbruddsdata.lovbrudd_09405_ferdig s on s.statistikkvariabel_id = lf.statistikkvariabel_id
left join lovbruddsdata.�r � on �.�r_id = s.�r 
);


select distinct (a) from lovbruddsdata.all_data al;






select �.�r_id , ag.alder_id , k.kj�nn_id ,  s.statistikkvariabel_id, l.lovbrudds_id, l5.value_sum_pr_�r , l53.sum
from lovbruddsdata.lovbrudd_11453_ferdig l53
join lovbruddsdata.lovbrudd_09405_ferdig l5 using (�r_id)
join lovbruddsdata.statistikkvariabel s using (statistikkvariabel_id)
join lovbruddsdata.�r � using (�r_id)
join lovbruddsdata.alder_grupper ag using(alder_id)
join lovbruddsdata.kj�nn k using(kj�nn_id)
join lovbruddsdata.lovbruddstyper l using(lovbrudds_id);



select distinct (statistikkvariabel_id) from lovbruddsdata.fact_test;


alter table lovbruddsdata.fakta_lovbrudd
add column fakta_id serial unique;

alter table lovbruddsdata.fakta_lovbrudd
add primary key(fakta_id);

alter table lovbruddsdata.fakta_lovbrudd
add foreign key (alder_id)
references lovbruddsdata.alder_grupper(alder_id);

alter table lovbruddsdata.fakta_lovbrudd 
add foreign key (�r_id )
references lovbruddsdata.�r(�r_id);

alter table lovbruddsdata.fakta_lovbrudd 
add foreign key (kj�nn_id )
references lovbruddsdata.kj�nn(kj�nn_id);

alter table lovbruddsdata.fakta_lovbrudd
add foreign key (statistikkvariabel_id)
references lovbruddsdata.statistikkvariabel(statistikkvariabel_id);

alter table lovbruddsdata.fakta_lovbrudd 
add foreign key (lovbrudds_id)
references lovbruddsdata.lovbruddstyper(lovbrudds_id);














------------------------------------------------------------------------------------------TEST STAR------------------------------------------------------------------------------------------


select * from lovbruddsdata.fakta_lovbrudd fl
join lovbruddsdata.lovbruddstyper l using (lovbrudds_id);

select * from lovbruddsdata.fakta_lovbrudd fl ;




