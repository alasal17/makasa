---------------------------lovbrudd---------------------------------------------
create table lovbrudd as (select distinct(l.lovbruddstype) as lovbruddstype from lovbruddsdata.lovbrudd_09409 l);

select * from lovbrudd;

alter table lovbrudd
add column lovbrudd_id serial unique;

alter table lovbrudd
add primary key (lovbrudd_id, lovbruddstype);

--------------------------------- ?r---------------------------------------------

create table lovbruddsdata.?r_ as (select distinct(l.?r) as ?r from lovbruddsdata.lovbrudd_09405 l);

alter table lovbruddsdata.?r_
add column ?r_id serial unique;


select * from lovbruddsdata.?r_;

alter table lovbruddsdata.?r_
add primary key (?r, ?r_id);


---------------------------------------- Create new tables with foreign keys ---------------------------------------- 

--------------- lovbrudd_09405 ---------------------------

create table lovbruddsdata.lovbrudd_09405_ as (select * from lovbruddsdata.lovbrudd_09405 l 
left join lovbruddsdata.?r_ l2 using(?r));

alter table lovbruddsdata.lovbrudd_09405_ 
add foreign key(?r_id)
references lovbruddsdata.?r_(?r_id);

--------------- lovbrudd_09406 ---------------------------

create table lovbruddsdata.lovbrudd_09406_ as (select * from lovbruddsdata.lovbrudd_09406 l 
left join lovbruddsdata.?r_ l2 using(?r));

alter table lovbruddsdata.lovbrudd_09406_ 
add foreign key(?r_id)
references lovbruddsdata.?r_(?r_id);



--------------- lovbrudd_09407 ---------------------------

create table lovbruddsdata.lovbrudd_09407_ as (select * from lovbruddsdata.lovbrudd_09407 l 
left join lovbruddsdata.?r_ l2 using(?r));

alter table lovbruddsdata.lovbrudd_09407_ 
add foreign key(?r_id)
references lovbruddsdata.?r_(?r_id);




--------------- lovbrudd_09408 ---------------------------

create table lovbruddsdata.lovbrudd_09408_ as (select * from lovbruddsdata.lovbrudd_09408 l 
left join lovbruddsdata.?r_ l2 using(?r));

alter table lovbruddsdata.lovbrudd_09408_ 
add foreign key(?r_id)
references lovbruddsdata.?r_(?r_id);


--------------- lovbrudd_09409 ---------------------------
create table lovbruddsdata.lovbrudd_09409_ as (select * from lovbruddsdata.lovbrudd_09409 l 
left join lovbruddsdata.?r_ l2 using(?r));

alter table lovbruddsdata.lovbrudd_09409_ 
add foreign key(?r_id)
references lovbruddsdata.?r_(?r_id);


--------------- lovbrudd_09410 ---------------------------

create table lovbruddsdata.lovbrudd_09410_ as (select * from lovbruddsdata.lovbrudd_09410 l 
left join lovbruddsdata.?r_ l2 using(?r));

alter table lovbruddsdata.lovbrudd_09410_ 
add foreign key(?r_id)
references lovbruddsdata.?r_(?r_id);



--------------- lovbrudd_09411 ---------------------------

create table lovbruddsdata.lovbrudd_09411_ as (select * from lovbruddsdata.lovbrudd_09411 l 
left join lovbruddsdata.?r_ l2 using(?r));

alter table lovbruddsdata.lovbrudd_09411_ 
add foreign key(?r_id)
references lovbruddsdata.?r_(?r_id);



--------------- lovbrudd_09412 ---------------------------

alter table lovbruddsdata.lovbrudd_09412 
alter column ?r type int4 using(?r::int4);

create table lovbruddsdata.lovbrudd_09412_ as (select * from lovbruddsdata.lovbrudd_09412 l 
left join lovbruddsdata.?r_ l2 using(?r));

alter table lovbruddsdata.lovbrudd_09412_ 
add foreign key(?r_id)
references lovbruddsdata.?r_(?r_id);



--------------- lovbrudd_09413 ---------------------------

alter table lovbruddsdata.lovbrudd_09413 
alter column ?r type int4 using(?r::int4);

create table lovbruddsdata.lovbrudd_09413_ as (select * from lovbruddsdata.lovbrudd_09413 l 
left join lovbruddsdata.?r_ l2 using(?r));

alter table lovbruddsdata.lovbrudd_09413_ 
add foreign key(?r_id)
references lovbruddsdata.?r_(?r_id);

--------------- lovbrudd_11453 ---------------------------

alter table lovbruddsdata.lovbrudd_11453 
alter column ?r type int4 using(?r::int4);

create table lovbruddsdata.lovbrudd_11453_ as (select * from lovbruddsdata.lovbrudd_11453 l 
left join lovbruddsdata.?r_ l2 using(?r));

alter table lovbruddsdata.lovbrudd_11453_ 
add foreign key(?r_id)
references lovbruddsdata.?r_(?r_id);


-------------drop columns ------------------
alter table lovbrudd_09405 
drop column lovbrudd_id;

alter table ?r_
add primary key (?r);


