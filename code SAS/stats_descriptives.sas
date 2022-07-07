
		
 

/* Check des valeurs manquantes dans la base et suppression de ces dernières */

DATA data.table_finale;
SET data.table_finale;
IF (Country="") or (Score=.) or (Rank=.) or(Freedom=.) or(Trust=.) 
	or(Life_expectancy=.) or(PIB_HAB=.) or(year="") or(spirit_consumption=.) 
	or(beer_consumption=.) or(wine_consumption=.) or (Generosity=.) THEN DELETE;
RUN;

/* Contenu de la table finale*/
proc contents data = data.table_finale ; run ;


/* R�sum� des statistiques descriptives de la table */

proc means data = data.table_finale;
run;


%macro normalite(var=);
PROC UNIVARIATE DATA=data.table_finale NORMAL;
title &var.; 
VAR &var. ;
HISTOGRAM &var. /NORMAL;
QQPLOT &var.;
RUN;
%mend;

%normalite(var=Score);
%normalite(var=Freedom);
%normalite(var=Trust);
%normalite(var=Life_expectancy);
%normalite(var=PIB_HAB);
%normalite(var=Generosity);
%normalite(var=spirit_consumption);
%normalite(var=beer_consumption);
%normalite(var=wine_consumption);

%macro normalite(var=);
	PROC UNIVARIATE DATA=Base_projet NORMAL; 
	title &var.;
	VAR &var. ;
	HISTOGRAM &var. /NORMAL;
	QQPLOT &var.;
RUN;
%mend;

%normalite(var=Score);
%normalite(var=Freedom);
%normalite(var=Trust);
%normalite(var=Life_expectancy);
%normalite(var=PIB_HAB);
%normalite(var=Generosity);
%normalite(var=spirit_consumption);
%normalite(var=beer_consumption);
%normalite(var=wine_consumption);
%normalite(var=consumption);


/* Etude des corr�lations*/
/* Corr�lation entre les variables*/

proc corr data=data.table_finale;
run;
