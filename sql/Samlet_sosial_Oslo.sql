-------------Oppdaterer bydelskolonnene til � kun inneholde navnet p� bydelen--------------------
update sosialhjelp.antall_p�_up 
set "Bydel" = replace ("Bydel", 'Bydel ','')


update sosialhjelp.antall_p�_sosialhjelp 
set "Bydel" = replace ("Bydel", 'Bydel ','')


update sosialhjelp.antall_per_arbeidssituasjon
set "Bydel" = replace ("Bydel", 'Bydel ','')


update sosialhjelp.antall_per_husholdningstype
set "Bydel" = replace ("Bydel", 'Bydel ','')


update sosialhjelp.antall_p�_aap
set "Bydel" = replace ("Bydel", 'Bydel ','')


update sosialhjelp.sosialutbetaling_snitt
set "Bydel" = replace ("Bydel", 'Bydel ','')




-------------Lager totaltabellene uten bydeler, kun Oslo totalt---------------
create table total_aap as select sosialhjelp.antall_p�_aap."Bydel", �r, antall from sosialhjelp.antall_p�_aap
where sosialhjelp.antall_p�_aap."Bydel" like '%Oslo i alt%' and alder like 'Alder i alt'
--where alder = 'Alder i alt' and �r > '2011' and �r < '2019'

create table total_p�_sosialhjelp as select �r, antall_p�_sosialhjelp from sosialhjelp.antall_p�_sosialhjelp
where alder = 'I alt' and �r > '2011' and sosialhjelp.antall_p�_sosialhjelp."Bydel" like '%Oslo i alt%'

create table total_up as select �r, antall from sosialhjelp.antall_p�_up
where alder = 'Alder i alt' and �r > '2011' and �r < '2019' and "Bydel" = 'Oslo i alt'

create table total_arbeidssituasjon as select �r, arbeidstype, antall from sosialhjelp.antall_per_arbeidssituasjon
where arbeidstype != 'Total' and �r > '2011' and "Bydel" = 'Oslo i alt'

create table total_snittutbetaling_sosial as select �r, snittutbetaling from sosialhjelp.sosialutbetaling_snitt
where �r > '2011' and "Bydel" = 'Oslo i alt'

create table total_husholdning as select �r, familietype, antall from sosialhjelp.antall_per_husholdningstype
where familietype != 'Alle' and �r > '2011' and sosialhjelp.antall_per_husholdningstype."Bydel" = 'Oslo i alt'




---------Lager samlet tabell for totale summer for Oslo per �r-----------------
create table total_sosial as select public.total_aap."Bydel", public.total_aap.�r, antall_p�_aap, antall_p�_sosialhjelp, antall_p�_up, snittutbetaling_sosialhjelp from total_aap
join total_sosialhjelp on public.total_aap.�r = total_sosialhjelp.�r 
join total_up on total_aap.�r = total_up.�r
join total_snittutbetaling_sosial on total_aap.�r = total_snittutbetaling_sosial.�r



