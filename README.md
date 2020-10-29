
<p align="center">
  <img width="560" height="400" src="dash_visualization/assets/team_logo.PNG">
</p>

***Skrevet av Kaja, Martin og Salam
dato: 23.10.2020***

## Mappe struktur:

**DL** -> Deep learing kode <br>

**ML** -> Machine learing kode

**PowerBI** -> visualiseringer 

**Starschema_sosial** -> sql kode for star schema for sosiale veriabler 

**dash_visualization** -> dash visualisering

**database** -> volum for postgres i docker

**databaseconnection** -> kobler til og sende data fra api til databasen (gp_makasa)

**sql** -> sql koden for ETL delen

**google colab** -> koden vi brukte for ML og DL i colab

**text_documents** -> er beskrivelse av dataen vi hentet fra API

**main.py** -> programmet som gir deg mulighet til å laste ned dataen i CSV og legge til dataen til databasen.

**requirements.txt** -> er beskrivelse av alle pakkene og dens versjon vi har brukt i prosjektet. 

**presentasjon** -> er avsluttingspresentasjon vi hadde på fredag 23.10.2020


# Bruke programmet
For å bruke programmet må du installere requirements filen.

>>> pip install -r requirements.txt

## Starte med å hent dataen

For nedlasting av data start programmet main.py. 
>>> python main.py
Her får du alternativer får å hente dataen. Den første er å laste ned dataen fra SSB i CSV-filer. Det andre er å sende dataen til databasen. 
 
<p align="center">
  <img width="560" height="400" src="dash_visualization/assets/run_main_program.PNG">
</p>

### legge til data til databasen
For å legge inn dataen til databasen må du skrive inn i CMD "add to database
Her for du mulighet å velge en eller flere tabeller som du kan sende til databasen.
<p align="center">
  <img width="560" height="400" src="dash_visualization/assets/run_main_program1.PNG">
</p>


## Visualisering med dash

For å se på dataen i dash må du navigere til ***dash_visualization/VisualizationLovbrudd.py*** .
>>> python VisualizationLovbrudd.py

<p align="center">
  <img width="1000" height="400" src="dash_visualization/assets/dash_lovbrudd.PNG">
</p>

<p align="center">
  <img width="1000" height="400" src="dash_visualization/assets/dash_lovbrudd1.PNG">
</p>

<p align="center">
  <img width="1000" height="400" src="dash_visualization/assets/dash_lovbrudd2.PNG">
</p>


