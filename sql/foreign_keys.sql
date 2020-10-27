
alter table lovbrudd_09411 
add column lovbrudds_id serial not null;

alter table lovbrudd_09411 
add primary key (lovbrudds_id);



alter table lovbrudd_09412 
add column lovbrudds_id serial not null;

alter table lovbrudd_09412 
add primary key (lovbrudds_id);

alter table lovbrudd_09413 
add column lovbrudds_id serial not null;

alter table lovbrudd_09413 
add primary key (lovbrudds_id);


alter table lovbrudd_11453 
add column lovbrudds_id serial not null;

alter table lovbrudd_11453 
add primary key (lovbrudds_id);


create view lovbrudd_full_datasett as (select distinct(l."antall lovbrudd") as "antall lovbrudd", l.kjønn, l.value as kjønn_value, l2.value as alder_value, l2.alder,l.statistikkvariabel  from lovbrudd_09413 l 
join lovbrudd_09412 l2 using (år)
join 
group by l.kjønn, l."antall lovbrudd", l2.alder, l.statistikkvariabel , l.value, l2.value);

select * from lovbrudd_09405 l ;
select * from lovbrudd_09406 l2 ;

alter table lovbruddsdata.lovbrudd_09406 
add foreign key (lovbrudd_09406_id) 
references lovbruddsdata.lovbrudd_09405(lovbrudds_id);



select distinct(l.år), l."politiets avgjørelse", l.lovbrudds_id, l.lovbruddstype from lovbruddsdata.lovbrudd_09405 l
group by l.år , l.lovbrudds_id ,l.lovbruddstype , l."politiets avgjørelse";


alter table lovbruddsdata.lovbrudd_09407 
add foreign key (lovbrudd_09407_id) 
references lovbruddsdata.lovbrudd_09406(lovbrudd_id);


alter table lovbruddsdata.lovbrudd_09407 
add foreign key (lovbrudds_id) 
references lovbruddsdata.lovbrudd_09408(lovbrudds_id);

alter table lovbruddsdata.lovbrudd_09408 
add foreign key (lovbrudds_id) 
references lovbruddsdata.lovbrudd_09409(lovbrudds_id);


alter table lovbruddsdata.lovbrudd_09410 
add foreign key (lovbrudds_id) 
references lovbruddsdata.lovbrudd_09409(lovbrudds_id);


alter table lovbruddsdata.lovbrudd_09411 
add foreign key (lovbrudds_id) 
references lovbruddsdata.lovbrudd_09410(lovbrudds_id);


alter table lovbruddsdata.lovbrudd_09412 
add foreign key (lovbrudds_id) 
references lovbruddsdata.lovbrudd_09411(lovbrudds_id);


alter table lovbruddsdata.lovbrudd_09413 
add foreign key (lovbrudds_id) 
references lovbruddsdata.lovbrudd_09412(lovbrudds_id);

alter table lovbruddsdata.lovbrudd_09413 
add foreign key (lovbrudds_id) 
references lovbruddsdata.lovbrudd_11453(lovbrudds_id);