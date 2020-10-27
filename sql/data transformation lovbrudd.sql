
---- SELECT TABLES

-- ################################################################################# Data prep ################################################################################# --
select count(*) from lovbruddsdata.lovbrudd_09405_working;
select count(*) from lovbruddsdata.lovbrudd_11453_working;
----------------------------------------------------------------------- lovbrudd_09405 -----------------------------------------------------------------------

alter table lovbrudd_09405 
alter column �r type int4 using(�r::int4);
alter table lovbrudd_09405 
alter column value type float8 using(value::float8);




delete from lovbrudd_09405 
where value = 0;

create table lovbruddsdata.lovbrudd_09405_working as (
select * from lovbruddsdata.lovbrudd_09405 l
join lovbruddsdata.�r using (�r)
join lovbruddsdata.lovbruddstyper using(lovbruddstype)
join lovbruddsdata.statistikkvariabel s using(statistikkvariabel));

----------------------------------------------------------------------- lovbrudd_11453 -----------------------------------------------------------------------
alter table lovbrudd_11453 
alter column �r type int4 using(�r::int4);

alter table lovbrudd_11453 
alter column value type float8 using(value::float8);


create table lovbruddsdata.lovbrudd_11453_working as (
select * from lovbruddsdata.lovbrudd_11453 l
join lovbruddsdata.�r using (�r)
join lovbruddsdata.statistikkvariabel s using(statistikkvariabel)
join lovbruddsdata.kj�nn k using (kj�nn)
join lovbruddsdata.alder_grupper ag using(alder)
);



-- ################################################################################# Relations ################################################################################# --

----------------------------------------------------------------------- 09405 working -----------------------------------------------------------------------

alter table lovbruddsdata.lovbrudd_09405_working
add foreign key(statistikkvariabel_id)
references lovbruddsdata.statistikkvariabel(statistikkvariabel_id);


alter table lovbruddsdata.lovbrudd_09405_working
add foreign key(�r_id)
references lovbruddsdata.�r(�r_id);


alter table lovbruddsdata.lovbrudd_09405_working
add foreign key(lovbrudds_id)
references lovbruddsdata.lovbruddstyper(lovbrudds_id);

select * from lovbruddsdata.lovbrudd_09405_working lw ;

ALTER TABLE lovbruddsdata.lovbrudd_09405_working DROP COLUMN �r;
ALTER TABLE lovbruddsdata.lovbrudd_09405_working DROP COLUMN statistikkvariabel;
ALTER TABLE lovbruddsdata.lovbrudd_09405_working DROP COLUMN lovbruddstype;
----------------------------------------------------------------------- 11453 working -----------------------------------------------------------------------

--statistikkvariabel_id
alter table lovbruddsdata.lovbrudd_11453_working
add foreign key(statistikkvariabel_id)
references lovbruddsdata.statistikkvariabel(statistikkvariabel_id);

--�r_id
alter table lovbruddsdata.lovbrudd_11453_working
add foreign key(�r_id)
references lovbruddsdata.�r(�r_id);

--alder_id
alter table lovbruddsdata.lovbrudd_11453_working
add foreign key(alder_id)
references lovbruddsdata.alder_grupper(alder_id);

--kj�nn_id
alter table lovbruddsdata.lovbrudd_11453_working
add foreign key(kj�nn_id)
references lovbruddsdata.kj�nn(kj�nn_id);

ALTER TABLE lovbruddsdata.lovbrudd_11453_working DROP COLUMN �r;
ALTER TABLE lovbruddsdata.lovbrudd_11453_working DROP COLUMN statistikkvariabel;
ALTER TABLE lovbruddsdata.lovbrudd_11453_working DROP COLUMN kj�nn;
ALTER TABLE lovbruddsdata.lovbrudd_11453_working DROP COLUMN alder;

-- ################################################################################# fact table ################################################################################# --

create table lovbruddsdata.fact_v2 as (
select �.�r_id, s.statistikkvariabel_id, l.lovbrudds_id, k.kj�nn_id, ag.alder_id, (l5.value) as "value pr. lovbrudd" , (l53.value) as "value pr. kj�nn og alder"
from lovbruddsdata.statistikkvariabel s
join  lovbruddsdata.lovbrudd_09405_working  l5 using(statistikkvariabel_id)
left join lovbruddsdata.lovbruddstyper l using(lovbrudds_id) 
left join lovbruddsdata.�r � using(�r_id)
right join lovbruddsdata.lovbrudd_11453_working l53 using(�r_id)
left join lovbruddsdata.kj�nn k using (kj�nn_id)
left join lovbruddsdata.alder_grupper ag using(alder_id));


-- �.�r_id, s.statistikkvariabel_id, l.lovbrudds_id, k.kj�nn_id, ag.alder_id, (l5.value) as "value pr. lovbrudd" , (l53.value) as "value pr. kj�nn og alder"

alter table lovbruddsdata.fact_v2 
add column fact_id serial unique;

alter table lovbruddsdata.fact_v2 
add primary key (fact_id);


-- ################################################################################# conect fact table to dim's ################################################################################# --

select * from lovbruddsdata.fact_v2 fv;

-- alder_id
alter table lovbruddsdata.fact_v2 
add foreign key(alder_id)
references lovbruddsdata.alder_grupper(alder_id);

-- lovbrudds_id
alter table lovbruddsdata.fact_v2 
add foreign key(lovbrudds_id)
references lovbruddsdata.lovbruddstyper(lovbrudds_id);

--statistikkvariabel_id
alter table lovbruddsdata.fact_v2 
add foreign key(statistikkvariabel_id)
references lovbruddsdata.statistikkvariabel(statistikkvariabel_id);

--kj�nn_id
alter table lovbruddsdata.fact_v2 
add foreign key(kj�nn_id)
references lovbruddsdata.kj�nn(kj�nn_id);

--�r_id
alter table lovbruddsdata.fact_v2 
add foreign key(�r_id)
references lovbruddsdata.�r(�r_id);


-- ################################################################################# TEST FACT TABLE ################################################################################# --
select fv."value pr. lovbrudd", l.lovbrudds_id , l.lovbruddstype from lovbruddsdata.fact_v2 fv 
join lovbruddsdata.lovbruddstyper l using(lovbrudds_id);

select �.�r , �.�r_id, s.statistikkvariabel_id, f."value pr. kj�nn og alder", ag.alder from lovbruddsdata.fact_v2 f
left join lovbruddsdata.alder_grupper ag using (alder_id)
join lovbruddsdata.�r � using(�r_id)
join lovbruddsdata.statistikkvariabel s using(statistikkvariabel_id);

select count(distinct (s.statistikkvariabel))  from lovbruddsdata.fact_v2 fv 
join lovbruddsdata.statistikkvariabel s using(statistikkvariabel_id)
join lovbruddsdata.�r  � using(�r_id);


