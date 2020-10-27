alter table lovbruddsdata.lovbrudd_09405_ 
alter column value type float8 using (value::float8);

select l.lovbruddstype, l."politiets avgj�relse", l.statistikkvariabel, l2."Lovbrudd etterforsket", l2.lovbruddstype, l2.oppklaringsprosent, l.value from lovbruddsdata.lovbrudd_09405_ l 
join lovbruddsdata.lovbrudd_09406_ l2 using(�r_id);

create table lovbruddsdata.test_dataset_lovbrudd as (
select sum(l6."Lovbrudd etterforsket"), sum(l6.oppklaringsprosent)  
from lovbruddsdata.lovbrudd_09406_ l6 
join lovbruddsdata.lovbrudd_09408_ l8 using(�r_id)
join lovbruddsdata.lovbrudd_09410_ l10 using(�r_id)
join lovbruddsdata.lovbrudd_09411_ l11 using(�r_id)
where l6.�r between 2010 and 2014);

 
alter table lovbruddsdata.lovbrudd_11453_ 
alter column value type float8 using (value::float8);

--------------------------- group by --------------------------------------------

create table if not exists lovbrudd_09405_test as (
select l.�r_id ,l.�r, l.lovbruddstype,l.statistikkvariabel, sum(l.value) as value_sum_pr_�r 
from lovbruddsdata.lovbrudd_09405_ l
where l.�r between 2010 and 2014
group by l.lovbruddstype , l.�r_id ,l.�r,l.statistikkvariabel);

create table if not exists lovbrudd_09410_test as ( 
select l.�r_id, l.�r , l.alder ,l.lovbruddstype , l.statistikkvariabel, sum(l.value) as value_sum_pr_�r from lovbruddsdata.lovbrudd_09410_ l 
where l.alder != 'Alle aldre 5 �r og over' and l.�r between 2010 and 2014
group by l.�r,l.�r_id, l.alder ,l.lovbruddstype , l.statistikkvariabel);

create table if not exists lovbruddsdata.lovbrudd_11453_test  as (
select l.�r_id ,l.�r, l.alder, l.kj�nn, l.statistikkvariabel, sum(l.value) from lovbruddsdata.lovbrudd_11453_ l
where l.kj�nn != 'I alt'and l.�r between 2010 and 2014
group by l.�r_id, l.�r, l.alder, l.kj�nn, l.statistikkvariabel);

----------------------------- relations -------------------------------------------------
create table if not exists lovbruddsdata.�r as (select * from �r_ );

create table lovbruddsdata.�r as (select distinct(l.�r) as �r from lovbruddsdata.�r_ l);

alter table lovbruddsdata.�r
add column �r_id serial unique;


select * from lovbruddsdata.�r;

alter table lovbruddsdata.lovbruddsdata.�r
add primary key (�r, �r_id);


alter table lovbruddsdata.lovbrudd_09405_test 
add foreign key (�r_id)
references �r(�r_id);


alter table lovbruddsdata.lovbrudd_09410_test 
add foreign key (�r_id)
references �r(�r_id);

alter table lovbruddsdata.lovbrudd_11453_test 
add foreign key (�r_id)
references lovbruddsdata.�r(�r_id);

select * from lovbrudd_11453_test;
select * from lovbrudd_09405_test lt 
join lovbrudd_09410_test lt2 using (�r_id)
join lovbrudd_11453_test lt3 using (�r_id)
join �r using(�r_id);

select distinct (l.�r) from lovbrudd_09405_test l
where l.�r between 2010 and 2014;

select * from lovbrudd_09405_test lt;


select distinct from lovbruddsdata.lovbrudd_11453_test lt;

select * from lovbruddsdata.lovbrudd_09405_test l
join lovbruddsdata.lovbrudd_11453_test lt using(�r_id);

