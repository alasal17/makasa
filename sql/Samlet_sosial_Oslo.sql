-------------Oppdaterer bydelskolonnene til å kun inneholde navnet på bydelen--------------------
update sosialhjelp.antall_på_up 
set "Bydel" = replace ("Bydel", 'Bydel ','')


update sosialhjelp.antall_på_sosialhjelp 
set "Bydel" = replace ("Bydel", 'Bydel ','')


update sosialhjelp.antall_per_arbeidssituasjon
set "Bydel" = replace ("Bydel", 'Bydel ','')


update sosialhjelp.antall_per_husholdningstype
set "Bydel" = replace ("Bydel", 'Bydel ','')


update sosialhjelp.antall_på_aap
set "Bydel" = replace ("Bydel", 'Bydel ','')


update sosialhjelp.sosialutbetaling_snitt
set "Bydel" = replace ("Bydel", 'Bydel ','')




-------------Lager totaltabellene uten bydeler, kun Oslo totalt---------------
create table total_aap as select sosialhjelp.antall_på_aap."Bydel", år, antall from sosialhjelp.antall_på_aap
where sosialhjelp.antall_på_aap."Bydel" like '%Oslo i alt%' and alder like 'Alder i alt'
--where alder = 'Alder i alt' and år > '2011' and år < '2019'

create table total_på_sosialhjelp as select år, antall_på_sosialhjelp from sosialhjelp.antall_på_sosialhjelp
where alder = 'I alt' and år > '2011' and sosialhjelp.antall_på_sosialhjelp."Bydel" like '%Oslo i alt%'

create table total_up as select år, antall from sosialhjelp.antall_på_up
where alder = 'Alder i alt' and år > '2011' and år < '2019' and "Bydel" = 'Oslo i alt'

create table total_arbeidssituasjon as select år, arbeidstype, antall from sosialhjelp.antall_per_arbeidssituasjon
where arbeidstype != 'Total' and år > '2011' and "Bydel" = 'Oslo i alt'

create table total_snittutbetaling_sosial as select år, snittutbetaling from sosialhjelp.sosialutbetaling_snitt
where år > '2011' and "Bydel" = 'Oslo i alt'

create table total_husholdning as select år, familietype, antall from sosialhjelp.antall_per_husholdningstype
where familietype != 'Alle' and år > '2011' and sosialhjelp.antall_per_husholdningstype."Bydel" = 'Oslo i alt'




---------Lager samlet tabell for totale summer for Oslo per år-----------------
create table total_sosial as select public.total_aap."Bydel", public.total_aap.år, antall_på_aap, antall_på_sosialhjelp, antall_på_up, snittutbetaling_sosialhjelp from total_aap
join total_sosialhjelp on public.total_aap.år = total_sosialhjelp.år 
join total_up on total_aap.år = total_up.år
join total_snittutbetaling_sosial on total_aap.år = total_snittutbetaling_sosial.år



