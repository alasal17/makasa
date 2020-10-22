
                 
                           
--Inntekt:            
create table fakta_inntekt (inntekt_id serial primary key, year_id int4 references time_year(year_id), place_id int4 references place_bydel(place_id),  
             gjennomsnittsinntekt int);             
  
insert into fakta_inntekt(year_id, place_id, gjennomsnittsinntekt) select ty.year_id, pb.place_id, cast(spb.gjennomsnittsinntekt as numeric)
                 from star_sosial.snittinntekt_per_bydel spb 
                  join star_sosial.time_year ty on cast(spb.år as int) = cast(ty."year" as int)
                  join star_sosial.place_bydel pb on spb.bydel = pb.bydel; 

--Barnevern:
create table fakta_barnevern (barnevern_id serial primary key, year_id int4 references time_year(year_id), place_id int4 references place_bydel(place_id), 
               antall_barnevernsmeldinger int, antall_barnevernsundersøkelser int);  
        
insert into fakta_barnevern(year_id, place_id, antall_barnevernsmeldinger, antall_barnevernsundersøkelser) select ty.year_id, pb.place_id, bm."totalt antall", bu."totalt antall" 
                 from barnevernssaker.barnevernsmeldinger bm
                 join barnevernssaker.undersokelser_bydeler bu on bm.år = bu.år and bm.bydel = bu.bydel 
                 join star_sosial.time_year ty on cast(bm.år as int) = cast(ty."year" as int)
                 join star_sosial.place_bydel pb on bm .bydel = pb.bydel; 

 --Sosial
 create table fakta_sosialstøtte (sosialstøtte_id serial primary key, year_id int4 references time_year(year_id), place_id int4 references place_bydel(place_id), 
               antall_sosialhjelpsmottakere int, antall_uføre int); 
       
 insert into fakta_sosialstøtte(year_id, place_id, antall_sosialhjelpsmottakere, antall_uføre) 
                select ty.year_id, pb.place_id, aps.antall, cast(up.antall as int)
                 from star_sosial.antall_på_sosialhjelp aps
                 join star_sosial.antall_på_up up on aps.år = up.år and aps."?Bydel" = up."?Bydel" 
                 join star_sosial.time_year ty on aps.år = ty."year" 
                 join star_sosial.place_bydel pb on aps."?Bydel" = pb.bydel;
                 group by ty.year_id, pb.place_id, aps.antall, up.antall, ab.antall; 
                
select * from fakta_sosialstøtte;   

--Innvandring 
create table innvandringskategori (id_innvandringskategori serial primary key, kategori varchar);
insert into innvandringskategori ( kategori) 
       select distinct(innvandringskategori) from innvandring.innvandring_per_bydel; 
      
create table innvandring_landbakgrunn (id_landbakgrunn serial primary key, landbakgrunn varchar);

insert into innvandring_landbakgrunn (landbakgrunn)
       select distinct(landbakgrunn) from innvandring.innvandring_per_bydel;

create table fakta_innvandring (innvandring_id serial primary key, year_id int4 references time_year(year_id), place_id int4 references place_bydel(place_id),
               id_innvandringskategori int4 references innvandringskategori(id_innvandringskategori), id_landbakgrunn int4 references innvandring_landbakgrunn (id_landbakgrunn),
               antall_innvandrere int);
          
insert into fakta_innvandring(year_id, place_id, id_innvandringskategori, id_landbakgrunn, antall_innvandrere)
                 select ty.year_id, pb.place_id, ik.id_innvandringskategori, lb.id_landbakgrunn, ipb.personer 
                 from innvandring.innvandring_per_bydel ipb
                 join innvandringskategori ik on ipb.innvandringskategori = ik.kategori 
                 join innvandring_landbakgrunn lb on ipb.landbakgrunn = lb.landbakgrunn 
                 join star_sosial.time_year ty on cast(ipb.år as int) = cast(ty."year" as int)
                 join star_sosial.place_bydel pb on ipb.region = pb.bydel;
                
                select * from fakta_innvandring;
 


--Til etterpå:

select * from innvandring.innvandring_per_bydel ipb ;

select * from star_sosial.aap_bydel;


drop table fa
       
       
       