--create new schema: 
create schema star_sosial; 

--create time dimention (year)
create table time_year (year_id serial primary key, year int); 

insert into time_year (year)
       select distinct(år) from sosialhjelp.antall_på_up
        order by år;  
    
-- create place dimention (bydel)
create table place_bydel(place_id serial primary key, bydel varchar);


insert into bydel_dim (bydel)
       select distinct(bydel) from public.barnevernsmeldinger 
       where bydel != 'Alle bydeler i Oslo' and bydel != 'Oslo kommune sektor overgripende' and bydel != 'Sentrum' and bydel != 'Marka';

      
--create kjønn¸nn_dim
create table kjønnsdim(kjønn_id serial primary key, kjønn varchar);

insert into kjønnsdim(kjønn)
       select distinct (kjønn) from public.utdannelse_kjønn_per_bydel ;
       

                   
                   
                                
                   
-- Fiksing av ulike tabeller før de er klare til å settes inn i faktatabell:
                   
--Fix table om inntekt per bydel (fjerne ord Bydel):
create table star_sosial.snittinntekt_per_bydel as select si."﻿Bydel" as bydel, si.år , si.gjnsnittsinntekt as gjennomsnittsinntekt from inntekt.snittinntekt_per_bydel si ;
 update star_sosial.snittinntekt_per_bydel set bydel = replace(bydel, 'Bydel ', '');

select * from star_sosial.snittinntekt_per_bydel;

alter table star_sosial.snittinntekt_per_bydel  
      alter column år type int4
       using år::int4;

alter table star_sosial.snittinntekt_per_bydel  
      alter column gjennomsnittsinntekt type int
       using gjennomsnittsinntekt::int;
      

-- Fix table about innvandring i de ulike bydelene: 
alter table innvandring.innvandring_per_bydel 
      alter column personer type numeric
       using personer::numeric;
     
      
create table star_sosial.innvandring_bydel as select region, år, sum(personer)  from innvandring.innvandring_per_bydel
    group by region, år;
 
create table star_sosial.antall_pa_sosialhjelp as select * from sosialhjelp.antall_pÃ¥_sosialhjelp  
      where alder = 'I alt';
     
     
create table star_sosial.antall_pa_up as select * from sosialhjelp.antall_pÃ¥_up  
      where alder = 'Alder i alt';
   
  
     
     select * from sosialhjelp.antall_pa_up  
      where alder = 'Alder i alt';
     
     
     create table star_sosial.antall_arbeidsavklaring as select * from star_sosial.aap_bydel ab 
             where alder ='Alder i alt';
        



   
--Fix table about sosial 

  
   
 --Sjekke andre tabeller som skal inn i fakta: 
select * from barnevernssaker.barnevernsmeldinger b ;
select * from barnevernssaker.undersokelser_bydeler ub ;
select * from star_sosial.snittinntekt_per_bydel spb ;
select * from star_sosial.innvandring_bydel ib ;
select * from star_sosial.antall_på_sosialhjelp aps ; --num
select * from star_sosial.antall_på_up  ;
select * from star_sosial.antall_arbeidsavklaring ;



--Make year int 4 in all tables: 
alter table star_sosial.innvandring_bydel 
      alter column år type int4
       using år::int4;
      
 alter table barnevernssaker.barnevernsmeldinger  
       alter column år type int4
       using år::int4;
      
  alter table barnevernssaker.barnevernsmeldinger  
       alter column "totalt antall" type numeric
       using "totalt antall"::numeric;

 alter table barnevernssaker.undersokelser_bydeler  
       alter column år type int4
       using år::int4;
  alter table barnevernssaker.undersokelser_bydeler  
       alter column  "totalt antall" type numeric
       using "totalt antall"::numeric;
      
 alter table star_sosial.snittinntekt_per_bydel  
       alter column år type int4
       using Ã¥r::int4;
 
 alter table star_sosial.snittinntekt_per_bydel  
       alter column år type int4
       using år::int4;
      
 alter table star_sosial.aap_bydel
       alter column år type int4
       using år::int4;
      
 alter table star_sosial.antall_på_up   
       alter column antall type int
       using antall::int;
      
  alter table star_sosial.antall_arbeidsavklaring   
       alter column antall type int
       using antall::int;
      
      
      --jffh
      
 alter table star_sosial.snittinntekt_per_bydel
       alter column gjnsnittsinntekt type int
       using gjnsnittsinntekt::int;
      
      select * from star_sosial.snittinntekt_per_bydel;
      
 alter table star_sosial.antall_på_up
       alter column antall type int
       using antall::int;
      
 alter table star_sosial.antall_arbeidsavklaring
       alter column antall type int
       using antall::int;     

--Make sure all tables has column bydel
 alter table barnevernssaker.undersokelser_bydeler 
       rename column region to bydel; 

 alter table star_sosial.innvandring_bydel
       rename column region to bydel;
      
--disse to fungerer ikke: 
 alter table sosialhjelp.antall_på_sosialhjelp
       rename column Bydel to bydel;
       
 alter table star_sosial.snittinntekt_per_bydel 
       rename column Bydel to bydel; 
      
     
      
-- create and populate fact table
create table fakta_sosial (id serial primary key, year_id int4 references time_year(year_id), place_id int4 references place_bydel(place_id),
              kjønn_id int4 references kjønnsdim(kjønn_id), gjennomsnittsinntekt int, barnevernsmeldinger int, barnevernsundersøkelser int, 
               innvandrere int, sosialhjelpsmottakere int, uførepensjonister int, "mottakere av arbeidsavklaringspenger" int);          

insert into star_sosial.fakta_sosial (year_id, place_id, gjennomsnittsinntekt, barnevernsmeldinger, barnevernsundersøkelser, innvandrere, sosialhjelpsmottakere, uførepensjonister, "mottakere av arbeidsavklaringspenger")
with tall as (select spb.år, spb.bydel, cast(spb.gjennomsnittsinntekt as numeric), b."totalt antall" as barnevernsmeldinger, ub."totalt antall" as barnevernsundersøkelser, ib.sum as "antall innvandrere",
aps.antall as "antall på sosialhjelp", apu.antall as "antall på uføretrygd", ab.antall as "antall på arbeidsavklaringspenger"
      from star_sosial.snittinntekt_per_bydel spb 
        left join barnevernssaker.barnevernsmeldinger b on spb.bydel = b.bydel and cast(spb.år as int) = cast(b.år as int) 
        left join barnevernssaker.undersokelser_bydeler ub on spb.bydel = ub.bydel and cast(spb.år as int) = cast(ub.år as int)  
        left join star_sosial.innvandring_bydel ib on spb.bydel = ib.bydel and cast(spb.år as int) = cast(ib.år as int)  
        left join star_sosial.antall_på_sosialhjelp aps on spb.bydel = aps."﻿Bydel" and cast(spb.år as int) = cast(aps.år as int) 
        left join star_sosial.antall_på_up apu on spb.bydel = apu."﻿Bydel" and cast(spb.år as int) = cast(apu.år as int) 
        left join star_sosial.aap_bydel ab on spb.bydel = ab."﻿Bydel" and cast(spb.år as int) = cast(ab.år as int) 
        order by år, bydel)
                 select ty.year_id, pb.place_id, cast(t.gjennomsnittsinntekt as int), t.barnevernsmeldinger, t.barnevernsundersøkelser, t."antall innvandrere", t."antall på sosialhjelp", 
                 cast(t."antall på uføretrygd" as int), cast(t."antall på arbeidsavklaringspenger" as int)
                  from tall t 
                  left join star_sosial.time_year ty on cast(t.år as int) = cast(ty."year" as int) 
                  left join star_sosial.place_bydel pb on t.bydel = pb.bydel;
                 
                 
                 
  

                 
select * from star_sosial.snittinntekt_per_bydel spb2 ;
select spb.år, spb.bydel, cast(spb.gjennomsnittsinntekt as numeric), b."totalt antall" as barnevernsmeldinger, ub."totalt antall" as barnevernsundersøkelser, ib.sum as "antall innvandrere",
aps.antall as "antall på sosialhjelp", apu.antall as "antall på uføretrygd", ab.antall as "antall på arbeidsavklaringspenger"
      from star_sosial.snittinntekt_per_bydel spb 
        left join barnevernssaker.barnevernsmeldinger b on spb.bydel = b.bydel and cast(spb.år as int) = cast(b.år as int) 
        left join barnevernssaker.undersokelser_bydeler ub on spb.bydel = ub.bydel and cast(spb.år as int) = cast(ub.år as int)  
        left join star_sosial.innvandring_bydel ib on spb.bydel = ib.bydel and cast(spb.år as int) = cast(ib.år as int)  
        left join star_sosial.antall_på_sosialhjelp aps on spb.bydel = aps."﻿Bydel" and cast(spb.år as int) = cast(aps.år as int) 
        left join star_sosial.antall_på_up apu on spb.bydel = apu."﻿Bydel" and cast(spb.år as int) = cast(apu.år as int) 
        left join star_sosial.aap_bydel ab on spb.bydel = ab."﻿Bydel" and cast(spb.år as int) = cast(ab.år as int) 
        order by år, bydel; 