alter table lovbruddsdata.lovbrudd_09405_ 
alter column value type float8 using (value::float8);

select l.lovbruddstype, l."politiets avgjørelse", l.statistikkvariabel, l2."Lovbrudd etterforsket", l2.lovbruddstype, l2.oppklaringsprosent, l.value from lovbruddsdata.lovbrudd_09405_ l 
join lovbruddsdata.lovbrudd_09406_ l2 using(år_id);

create table lovbruddsdata.test_dataset_lovbrudd as (
select sum(l6."Lovbrudd etterforsket"), sum(l6.oppklaringsprosent)  
from lovbruddsdata.lovbrudd_09406_ l6 
join lovbruddsdata.lovbrudd_09408_ l8 using(år_id)
join lovbruddsdata.lovbrudd_09410_ l10 using(år_id)
join lovbruddsdata.lovbrudd_09411_ l11 using(år_id)
where l6.år between 2010 and 2014);

 
alter table lovbruddsdata.lovbrudd_11453_ 
alter column value type float8 using (value::float8);

--------------------------- group by --------------------------------------------

create table if not exists lovbrudd_09405_test as (
select l.år_id ,l.år, l.lovbruddstype,l.statistikkvariabel, sum(l.value) as value_sum_pr_år 
from lovbruddsdata.lovbrudd_09405_ l
where l.år between 2010 and 2014
group by l.lovbruddstype , l.år_id ,l.år,l.statistikkvariabel);

create table if not exists lovbrudd_09410_test as ( 
select l.år_id, l.år , l.alder ,l.lovbruddstype , l.statistikkvariabel, sum(l.value) as value_sum_pr_år from lovbruddsdata.lovbrudd_09410_ l 
where l.alder != 'Alle aldre 5 år og over' and l.år between 2010 and 2014
group by l.år,l.år_id, l.alder ,l.lovbruddstype , l.statistikkvariabel);

create table if not exists lovbruddsdata.lovbrudd_11453_test  as (
select l.år_id ,l.år, l.alder, l.kjønn, l.statistikkvariabel, sum(l.value) from lovbruddsdata.lovbrudd_11453_ l
where l.kjønn != 'I alt'and l.år between 2010 and 2014
group by l.år_id, l.år, l.alder, l.kjønn, l.statistikkvariabel);

----------------------------- relations -------------------------------------------------
create table if not exists lovbruddsdata.år as (select * from år_ );

create table lovbruddsdata.år as (select distinct(l.år) as år from lovbruddsdata.år_ l);

alter table lovbruddsdata.år
add column år_id serial unique;


select * from lovbruddsdata.år;

alter table lovbruddsdata.lovbruddsdata.år
add primary key (år, år_id);


alter table lovbruddsdata.lovbrudd_09405_test 
add foreign key (år_id)
references år(år_id);


alter table lovbruddsdata.lovbrudd_09410_test 
add foreign key (år_id)
references år(år_id);

alter table lovbruddsdata.lovbrudd_11453_test 
add foreign key (år_id)
references lovbruddsdata.år(år_id);

select * from lovbrudd_11453_test;
select * from lovbrudd_09405_test lt 
join lovbrudd_09410_test lt2 using (år_id)
join lovbrudd_11453_test lt3 using (år_id)
join år using(år_id);

select distinct (l.år) from lovbrudd_09405_test l
where l.år between 2010 and 2014;

select * from lovbrudd_09405_test lt;


select distinct from lovbruddsdata.lovbrudd_11453_test lt;

select * from lovbruddsdata.lovbrudd_09405_test l
join lovbruddsdata.lovbrudd_11453_test lt using(år_id);

