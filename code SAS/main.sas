/*CHANGER LE CHEMIN DU PROJET POUR TOURNER LE CODE*/
%let path = /home/u61143811/M2_SAS_PROJET/;
libname data "&path./librairie";


%include "&path./programme/import.sas";
%include "&path./programme/cleaning.sas";
%include "&path./programme/regression.sas";



/*IMPORT DES DONNEES*/
%import_all_data(active=True, lib=data);

/* NETTOYAGE DES DONNEES ET CREATION TABLE FINALE*/
%table_generation(library=data);

%include "&path./programme/stats_descriptives.sas";


/*proc export data=DATA.table_finale
outfile="/home/u61143811/M2_SAS_PROJET/data_csv/table_finale.csv"
dbms = csv replace;
run;*/

/* Fig 1 */
%between(data=data.table_finale,
		cible=score,
		model=Freedom 
		Life_expectancy
		pib_hab 
		trust
		generosity
		beer_consumption 
		spirit_consumption
 		wine_consumption,
 		method=MCGQ);

/* Fig 2*/
%between(data=data.table_finale,
		cible=Life_expectancy,
		model=Freedom 
		pib_hab 
		trust
		generosity
		spirit_consumption
 		wine_consumption,
 		method=MCO);
 		
 		
 		
/* Fig 3 */ 		
%within(data=data.table_finale,
		cible=score,
		model=Freedom 
		Life_expectancy
		pib_hab 
		trust
		generosity
		beer_consumption 
		spirit_consumption
 		wine_consumption,
 		method=MCO);
 		

/* Fig 4 */
%within(data=data.table_finale,
		cible=pib_hab,
		model=Freedom 
		Life_expectancy
		generosity 
		trust 
		spirit_consumption
 		wine_consumption,
 		method=MCO);
 		
 		
 		
 