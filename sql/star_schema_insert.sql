-- create place dimention (bydel)
create table bydel(bydel_id serial primary key, bydel varchar);

       insert into bydel(bydel)
       select distinct(bydel) from public.barnevernsmeldinger 
       where bydel != 'Alle bydeler i Oslo' and bydel != 'Oslo kommune sektor overgripende'; 
      --and bydel != 'Sentrum' and bydel != 'Marka';
           
create table star_schema.time_year (year_id serial primary key, year int); 

insert into time_year (year)
       select distinct(�r) from sosialhjelp.antall_p�_up
        order by �r;   
  
--Inntekt:  

create table fakta_inntekt (inntekt_id serial primary key, year_id int4 references time_year(year_id), bydel_id int4 references bydel(bydel_id),  
             gjennomsnittsinntekt int);   
        
      
insert into star_schema.fakta_inntekt (year_id, bydel_id, gjennomsnittsinntekt) select ty.year_id, bd.bydel_id, cast(spb.gjennomsnittsinntekt as numeric)
                  from star_sosial.snittinntekt_per_bydel spb 
                  join star_schema.time_year ty on cast(spb.�r as int) = cast(ty."year" as int)
                  join star_schema.bydel bd on spb.bydel = bd.bydel; 
select * from star_schema.fakta_inntekt;
--Barnevern:
create table fakta_barnevern (barnevern_id serial primary key, year_id int4 references time_year(year_id), bydel_id int4 references bydel(bydel_id), 
               antall_barnevernsmeldinger int, antall_barnevernsunders�kelser int);  
        
insert into fakta_barnevern(year_id, bydel_id, antall_barnevernsmeldinger, antall_barnevernsunders�kelser) select ty.year_id, pb.bydel_id, bm."totalt antall", bu."totalt antall" 
                 from barnevernssaker.barnevernsmeldinger bm
                 join barnevernssaker.undersokelser_bydeler bu on bm.�r = bu.�r and bm.bydel = bu.bydel 
                 join star_schema.time_year ty on cast(bm.�r as int) = cast(ty."year" as int)
                 join star_schema.bydel pb on bm.bydel = pb.bydel; 
                
                
select * from fakta_barnevern;


 --Sosial
 create table fakta_sosialst�tte (sosialst�tte_id serial primary key, year_id int4 references time_year(year_id), bydel_id int4 references bydel(bydel_id), 
               antall_sosialhjelpsmottakere int, antall_uf�re int); 
       
 insert into fakta_sosialst�tte(year_id, bydel_id, antall_sosialhjelpsmottakere, antall_uf�re) 
                select ty.year_id, pb.bydel_id, aps.antall, cast(up.antall as int)
                 from star_sosial.antall_p�_sosialhjelp aps
                 join star_sosial.antall_p�_up up on aps.�r = up.�r and aps."?Bydel" = up."?Bydel" 
                 join star_schema.time_year ty on aps.�r = ty."year" 
                 join star_schema.bydel pb on aps."?Bydel" = pb.bydel ;
         select * from fakta_sosialst�tte;
                

--Innvandring 
create table innvandringskategori (id_innvandringskategori serial primary key, kategori varchar);
insert into innvandringskategori ( kategori) 
       select distinct(innvandringskategori) from innvandring.innvandring_per_bydel; 
      
create table innvandring_landbakgrunn (id_landbakgrunn serial primary key, landbakgrunn varchar);

insert into innvandring_landbakgrunn (landbakgrunn)
       select distinct(landbakgrunn) from innvandring.innvandring_per_bydel;

create table fakta_innvandring (innvandring_id serial primary key, year_id int4 references time_year(year_id), bydel_id int4 references bydel(bydel_id),
               id_innvandringskategori int4 references innvandringskategori(id_innvandringskategori), id_landbakgrunn int4 references innvandring_landbakgrunn (id_landbakgrunn),
               antall_innvandrere int);
          
insert into fakta_innvandring(year_id, bydel_id, id_innvandringskategori, id_landbakgrunn, antall_innvandrere)
                 select ty.year_id, pb.bydel_id, ik.id_innvandringskategori, lb.id_landbakgrunn, ipb.personer 
                 from innvandring.innvandring_per_bydel ipb
                 join innvandringskategori ik on ipb.innvandringskategori = ik.kategori 
                 join innvandring_landbakgrunn lb on ipb.landbakgrunn = lb.landbakgrunn 
                 join star_schema.time_year ty on cast(ipb.�r as int) = cast(ty."year" as int)
                 join star_schema.bydel pb on ipb.region = pb.bydel;
                
 -- update place dim
 
alter table star_schema.dim_lokasjon add column latitude_coordinates numeric; 
alter table star_schema.dim_lokasjon add column longitude_coordinates numeric; 
update star_schema.dim_lokasjon delete latitude_coordinates;


create table if not exists star_schema.koordinater (sted_id serial primary key, latitude_coordinates numeric, longitude_coordinates numeric); 



insert into star_schema.koordinater(latitude_coordinates, longitude_coordinates) values(0, 0), (59.948459, 10.660206), (59.961775, 10.922244), (59.934369, 10.817720), (59.912443, 10.741181), 
(59.877047, 10.789108), (59.909831, 10.785645), 
(59.957380, 10.765770), (59.923730, 10.775813), (59.833390, 10.824125), (0, 0),  
(59.928221, 10.663502), (59.916032, 10.708108), (59.936679, 10.759309), (59.954578, 10.873632), (59.890105, 10.834287), (59.938204, 10.875476), (59.924732, 10.740207);

select * from star_schema.dim_lokasjon;
select * from star_schema.koordinater;


select * from sosialhjelp.antall_p�_aap apa ;

create view public.lovbrudd_oslo as; select �.�r, dlo.lovbruddstype, flo."Lovbrudd etterforsket"  from star_schema.fakta_lovbrudd_oslo flo 
            join star_schema.dim_lovbruddstyper_oslo dlo using(lovbrudds_id)
            join star_schema.dim_�r � using(�r_id)     
            order by flo."Lovbrudd etterforsket" desc;
            �
            
 select d�.�r, dag.alder, ds.statistikkvariabel, fl.value from fakta_lovbrudd_2 fl 
       join dim_alder_grupper dag on fl.alder_id = fl.alder_id 
       join dim_�r d� on fl.�r_id = d�.�r_id 
       join dim_statistikkvariabel ds on fl.statistikkvariabel_id = ds.statistikkvariabel_id ;
       
      
      select * from dim_alder_grupper dag ;