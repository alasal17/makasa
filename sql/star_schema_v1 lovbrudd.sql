
-- change the data type
alter table lovbrudd_09405
alter column value type float using (value::float);

alter table lovbrudd_09405 
alter column år type int using (år::int);

-- Add new id column to lovbrudd_09405
alter table lovbruddsdata.lovbrudd_09405 
add column lovbrudds_id serial unique;

-- Set the id column as primary key lovbrudd_09405
alter table lovbruddsdata.lovbrudd_09405 
add primary key (lovbrudds_id);

-- Add new id column to date
alter table lovbruddsdata.d_date 
add column time_id serial unique;

-- Set the id column as primary key date
alter table lovbruddsdata.d_date 
add primary key (time_id);

------------------------------------------------------------------------------------

-- Dim tables
create table lovbruddsdata.crime_dim as (select lovbrudds_id, lovbruddstype, "politiets avgjørelse", statistikkvariabel from lovbruddsdata.lovbrudd_09405);
create table lovbruddsdata.time_dim as (select år from lovbruddsdata.lovbrudd_09405);

alter table lovbruddsdata.time_dim
add column time_id serial unique;


-- set primary keys crime_dim
alter table lovbruddsdata.crime_dim 
add primary key (lovbrudds_id);

-- set primary keys time_dim
alter table lovbruddsdata.time_dim 
add primary key (time_id);

---------------------------------------------------------------------------------

-- fact table
create table lovbruddsdata._fact (fact_id serial primary key, time_id int, lovbrudds_id int, value float);
  

insert into lovbruddsdata._fact(lovbrudds_id, value) select td.lovbrudds_id, td.value from lovbruddsdata.crime_dim td;
insert into lovbruddsdata._fact(time_id) select td.time_id  from lovbruddsdata.time_dim td;
---------See data---------------------
select * from lovbruddsdata.crime_dim cd;
select * from lovbruddsdata.time_dim td;
select * from lovbruddsdata._fact;



select * from lovbruddsdata.crime_dim cd full join lovbruddsdata.d_date td on cd.lovbrudds_id =td.date_dim_id;

-- set relation between tables
alter table lovbruddsdata."_fact"
ADD foreign key (lovbrudds_id)
references lovbruddsdata.crime_dim(lovbrudds_id);

-- set relation between tables
alter table lovbruddsdata."_fact"
ADD foreign key (date_id)
references lovbruddsdata.time_dim(date_dim_id);



FOREIGN KEY (fk_columns) 
REFERENCES parent_table (parent_key_columns);



