--create new schema: 
create schema star_sosial; 


--create time dimention (year)
create table time_year (year_id serial primary key, year int); 

insert into time_year (year)
       select distinct(�r) from sosialhjelp.antall_p�_up
        order by �r;  
    
-- create place dimention (bydel)
create table place_bydel(place_id serial primary key, bydel varchar);


insert into place_bydel (bydel)
       select distinct(bydel) from public.barnevernsmeldinger 
       where bydel != 'Alle bydeler i Oslo' and bydel != 'Oslo kommune sektor overgripende' and bydel != 'Sentrum' and bydel != 'Marka';

      
--create kj�nnsdim
create table kj�nnsdim(kj�nn_id serial primary key, kj�nn varchar);

insert into kj�nnsdim(kj�nn)
       select distinct (kj�nn) from public.utdannelse_kj�nn_per_bydel ;
       
-- create and populate fact table
create table fact_sosial (id serial primary key, year_id int references time_year(year_id)); 

   CONSTRAINT FK_PersonOrder FOREIGN KEY (PersonID)
    REFERENCES Persons(PersonID)

             place_id int, )

select * from kj�nnsdim;
select * from  place_bydel; 
select * from place_bydel pb ;
select * from time_year ty ;
       
       
 select * from public.barnevernsmeldinger b ;
