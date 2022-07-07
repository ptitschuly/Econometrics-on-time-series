%macro append_year (beg=,end=,table=);
	
%do year=&beg. %to &end.;

data data.&table.&year.;
set data.&table.&year.;
year = &year.;
run;



%end;
%mend;


/* data cleaning */
%macro table_generation(library=DATA);

%append_year(beg=2015, end=2019, table=bonheur);

data bonheur2015;
set &library..bonheur2015;
rename 'Economy (Gdp per Capita)'n = PIB_HAB 
		'Health (Life Expectancy)'n = Life_expectancy
		'Trust (Government Corruption)'n = Trust
		'Happiness Score'n = Score
		'Happiness Rank'n = Rank
		'Dystopia Residual'n = Dystopia
		'Generosity'n = Generosity;

run;

data bonheur2016;
set &library..bonheur2016;
rename 'Economy (Gdp per Capita)'n = PIB_HAB 
		'Health (Life Expectancy)'n = Life_expectancy
		'Trust (Government Corruption)'n = Trust
		'Happiness Score'n = Score
		'Happiness Rank'n = Rank
		'Dystopia Residual'n = Dystopia
		'Generosity'n = Generosity;
run;

data bonheur2017;
set &library..bonheur2017;
rename 'Economy..GDP.per.Capita.'n = PIB_HAB 
		'Health..Life.Expectancy.'n = Life_expectancy
		'Trust..Government.Corruption.'n = Trust
		'Happiness.Score'n = Score
		'Happiness.Rank'n = Rank
		'Dystopia.Residual'n = Dystopia
		'Generosity'n = Generosity;
run;

data bonheur2018;
set &library..bonheur2018;
rename 'GDP per capita'n = PIB_HAB 
		'Healthy life expectancy'n = Life_expectancy
		'Perceptions of corruption'n = Trust
		'Overall Rank'n = Rank
		'Dystopia Residual'n = Dystopia
		'Freedom to make life choices'n = Freedom
		'Country or region'n = Country
		'Generosity'n = Generosity;
run;

data bonheur2019;
set &library..bonheur2019;
rename 'GDP per capita'n = PIB_HAB 
		'Healthy life expectancy'n = Life_expectancy
		'Perceptions of corruption'n = Trust
		'Overall Rank'n = Rank
		'Dystopia Residual'n = Dystopia
		'Freedom to make life choices'n = Freedom
		'Country or region'n = Country
		'Generosity'n = Generosity;
run;

data bonheur;
set bonheur2015 bonheur2016 bonheur2017 bonheur2018 bonheur2019;
run;

proc sql;
create table bonheur_sorted_out as select
Country,
Score,
Rank,
Freedom,
Trust,
Life_expectancy,
PIB_HAB,
year,
Generosity
from bonheur;
quit;

/* data cleaning - alcohol consumption */
proc sql;
create table consumption
as select
a.*,
a.'Indicator:Alcohol, recorded per'n as spirit_consumption,
b.'Indicator:Alcohol, recorded per'n as wine_consumption,
c.'Indicator:Alcohol, recorded per'n as beer_consumption
from data.spirits a 
inner join data.wine b on a.Code=b.Code and a.Year=b.Year
inner join data.beer c on a.Code=c.Code and a.Year=c.Year
where a.Year in (2015,2016,2017,2018,2019);
quit; 

proc means data=consumption NMISS N; run;
proc means data=bonheur_sorted_out NMISS N; run;
/* no NaN */

proc sql ;
	alter table Consumption
	modify Entity char(40);
quit;

data consumption;
set consumption;
Country = Entity;
if Entity = 'Bosnia and He' then Country='Bosnia and';
if Entity =  'Burkina Fas' then Country= 'Burkina Faso';
if Entity = 'Central Afr' then Country= 'Central Afric';
if Entity = 'Congo' then Country = 'Congo (Brazza';
if Entity = "Cote d'Ivoi" then Country= 'Ivory Coast';
if Entity = 'Czechia' then Country = 'Czech Republi';
if Entity = 'Democratic' then Country = 'Congo (Kinsha';
if Entity = 'Dominican R' then Country = 'Dominican Rep';
if Entity = 'North Maced' then Country = 'Macedonia';
if Entity =  'Saudi Arabi' then Country = 'Saudi Arabia';
if Entity = 'Sierra Leon' then Country = 'Sierra Leone';
if Entity = 'Turkmenista' then Country = 'Turkmenistan';
if Entity = 'South Afric' then Country = 'South Africa';
if Entity = 'United Arab' then Country = 'United Arab E';
if Entity = 'United King' then Country = 'United Kingdo';
if Entity = 'United Stat' then Country = 'United States';
if Entity = 'Democratic' then Country = 'RDC';
run;

data bonheur_sorted_out;
set bonheur_sorted_out;
Entity = Country;
if Entity = 'Bosnia and He' then Country='Bosnia and';
if Entity = 'Congo (Kinsha' then Country= 'RDC';
if Entity = 'Congo (Brazza' then Country = 'Congo';
if Entity = "Trinidad an" then Country = "Trinidad and Tobago";
run;

/* fusionner les tables */
proc sql;
create table &library..Table_Finale as select
b.*,
a.spirit_consumption,
a.beer_consumption,
a.wine_consumption
from consumption a
inner join bonheur_sorted_out b on b.Country=a.Country and b.Year=a.Year;
run; 
proc means data=data.Table_Finale NMISS N; run;

%mend table_generation;






