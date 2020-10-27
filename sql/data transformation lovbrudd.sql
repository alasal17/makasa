
---- SELECT TABLES

-- ################################################################################# Data prep ################################################################################# --
select count(*) from lovbruddsdata.lovbrudd_09405_working;
select count(*) from lovbruddsdata.lovbrudd_11453_working;
----------------------------------------------------------------------- lovbrudd_09405 -----------------------------------------------------------------------

alter table lovbrudd_09405 
alter column år type int4 using(år::int4);
alter table lovbrudd_09405 
alter column value type float8 using(value::float8);




delete from lovbrudd_09405 
where value = 0;

create table lovbruddsdata.lovbrudd_09405_working as (
select * from lovbruddsdata.lovbrudd_09405 l
join lovbruddsdata.år using (år)
join lovbruddsdata.lovbruddstyper using(lovbruddstype)
join lovbruddsdata.statistikkvariabel s using(statistikkvariabel));

----------------------------------------------------------------------- lovbrudd_11453 -----------------------------------------------------------------------
alter table lovbrudd_11453 
alter column år type int4 using(år::int4);

alter table lovbrudd_11453 
alter column value type float8 using(value::float8);


create table lovbruddsdata.lovbrudd_11453_working as (
select * from lovbruddsdata.lovbrudd_11453 l
join lovbruddsdata.år using (år)
join lovbruddsdata.statistikkvariabel s using(statistikkvariabel)
join lovbruddsdata.kjønn k using (kjønn)
join lovbruddsdata.alder_grupper ag using(alder)
);



-- ################################################################################# Relations ################################################################################# --

----------------------------------------------------------------------- 09405 working -----------------------------------------------------------------------

alter table lovbruddsdata.lovbrudd_09405_working
add foreign key(statistikkvariabel_id)
references lovbruddsdata.statistikkvariabel(statistikkvariabel_id);


alter table lovbruddsdata.lovbrudd_09405_working
add foreign key(år_id)
references lovbruddsdata.år(år_id);


alter table lovbruddsdata.lovbrudd_09405_working
add foreign key(lovbrudds_id)
references lovbruddsdata.lovbruddstyper(lovbrudds_id);

select * from lovbruddsdata.lovbrudd_09405_working lw ;

ALTER TABLE lovbruddsdata.lovbrudd_09405_working DROP COLUMN år;
ALTER TABLE lovbruddsdata.lovbrudd_09405_working DROP COLUMN statistikkvariabel;
ALTER TABLE lovbruddsdata.lovbrudd_09405_working DROP COLUMN lovbruddstype;
----------------------------------------------------------------------- 11453 working -----------------------------------------------------------------------

--statistikkvariabel_id
alter table lovbruddsdata.lovbrudd_11453_working
add foreign key(statistikkvariabel_id)
references lovbruddsdata.statistikkvariabel(statistikkvariabel_id);

--år_id
alter table lovbruddsdata.lovbrudd_11453_working
add foreign key(år_id)
references lovbruddsdata.år(år_id);

--alder_id
alter table lovbruddsdata.lovbrudd_11453_working
add foreign key(alder_id)
references lovbruddsdata.alder_grupper(alder_id);

--kjønn_id
alter table lovbruddsdata.lovbrudd_11453_working
add foreign key(kjønn_id)
references lovbruddsdata.kjønn(kjønn_id);

ALTER TABLE lovbruddsdata.lovbrudd_11453_working DROP COLUMN år;
ALTER TABLE lovbruddsdata.lovbrudd_11453_working DROP COLUMN statistikkvariabel;
ALTER TABLE lovbruddsdata.lovbrudd_11453_working DROP COLUMN kjønn;
ALTER TABLE lovbruddsdata.lovbrudd_11453_working DROP COLUMN alder;

-- ################################################################################# fact table ################################################################################# --

create table lovbruddsdata.fact_v2 as (
select å.år_id, s.statistikkvariabel_id, l.lovbrudds_id, k.kjønn_id, ag.alder_id, (l5.value) as "value pr. lovbrudd" , (l53.value) as "value pr. kjønn og alder"
from lovbruddsdata.statistikkvariabel s
join  lovbruddsdata.lovbrudd_09405_working  l5 using(statistikkvariabel_id)
left join lovbruddsdata.lovbruddstyper l using(lovbrudds_id) 
left join lovbruddsdata.år å using(år_id)
right join lovbruddsdata.lovbrudd_11453_working l53 using(år_id)
left join lovbruddsdata.kjønn k using (kjønn_id)
left join lovbruddsdata.alder_grupper ag using(alder_id));


-- å.år_id, s.statistikkvariabel_id, l.lovbrudds_id, k.kjønn_id, ag.alder_id, (l5.value) as "value pr. lovbrudd" , (l53.value) as "value pr. kjønn og alder"

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

--kjønn_id
alter table lovbruddsdata.fact_v2 
add foreign key(kjønn_id)
references lovbruddsdata.kjønn(kjønn_id);

--år_id
alter table lovbruddsdata.fact_v2 
add foreign key(år_id)
references lovbruddsdata.år(år_id);


-- ################################################################################# TEST FACT TABLE ################################################################################# --
select fv."value pr. lovbrudd", l.lovbrudds_id , l.lovbruddstype from lovbruddsdata.fact_v2 fv 
join lovbruddsdata.lovbruddstyper l using(lovbrudds_id);

select å.år , å.år_id, s.statistikkvariabel_id, f."value pr. kjønn og alder", ag.alder from lovbruddsdata.fact_v2 f
left join lovbruddsdata.alder_grupper ag using (alder_id)
join lovbruddsdata.år å using(år_id)
join lovbruddsdata.statistikkvariabel s using(statistikkvariabel_id);

select count(distinct (s.statistikkvariabel))  from lovbruddsdata.fact_v2 fv 
join lovbruddsdata.statistikkvariabel s using(statistikkvariabel_id)
join lovbruddsdata.år  å using(år_id);


