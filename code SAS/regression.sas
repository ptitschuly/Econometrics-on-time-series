/* data data.table_finale;
set data.table_finale;
if beer_consumption = 0 and spirit_consumption = 0 and wine_consumption = 0 then no_consumption = 1;
else no_consumption = 0;
Consumption = beer_consumption + spirit_consumption + wine_consumption;
run;*/


/*DATA check0;
SET data.table_finale;
IF (Country=0) or (Score=0) or (Rank=0) or(Freedom=0) or(Trust=.) 
	or(Life_expectancy=0) or(PIB_HAB=0) or(year=0) or(spirit_consumption=.) 
	or(beer_consumption=.) or(wine_consumption=.);
RUN;*/

/*
proc sql;
create table europe
as select
a.*
from data.table_finale a
where  country in ('Belgium', 'Netherlands', 'Norway', 'Portugual', 'Austria', 'Slovenia', 'Spain', 'Switzerland', 'United King'
				, 'France', 'Denmark','Germany','Greece','Hungary','Iceland','Ireland','Croatia','Cyprus','	Czech Repub','Estonia'
				, 'Finland','Georgia','Italy','Latvia','Luxembourg','Lithuania','Macedonia','Malta','Moldova','Poland');
run;
*/
/*Creation de la table en log*/
%macro log(name=,
				data=);

data &name.;
set &data.;
Freedom = log(Freedom);
Life_expectancy = log(Life_expectancy);
PIB_HAB = log(PIB_HAB);
Rank = log(Rank);
Score = log(Score);
Trust = log(Trust);
beer_consumption = log(beer_consumption);
spirit_consumption = log(spirit_consumption);
wine_consumption = log(wine_consumption);
run;
%mend log;



/* Regression linéaire simple */

%macro linreg(data=);
proc reg data= &data.;
model Score=Freedom 
		Life_expectancy
		pib_hab 
		rank 
		/*beer_consumption 
		spirit_consumption
 		wine_consumption*/
 		
 		/HCC SPEC;
 		title "regression "
run;
%mend linreg;


/* Regression linéaire simple */


/*proc reg data= data.logtab;
model Score=Freedom 
		Life_expectancy
		pib_hab 
		rank 
		trust 
		beer_consumption 
		spirit_consumption
 		wine_consumption;
run;*/


%macro MCQG(data=,
			cible=,
			model=,
			title=);
proc reg data=&data. ;
title "Regression &title. MCO";
model &cible. = &model./HCC SPEC TOL VIF;
output out=f r=res ;
quit ;run ;
data a ;set f ;res2=res*res ;run ;
proc reg data=a noprint;
model	res2=
		&model. ;
output out=sortie2 p=omega ;
quit ;run ;

data mt3 ;set sortie2 ;
is=1/sqrt(omega) ;
Freedom = Freedom/sqrt(omega);
Life_expectancy = Life_expectancy/sqrt(omega);
PIB_HAB = PIB_HAB/sqrt(omega);
Trust = Trust/sqrt(omega);
beer_consumption = beer_consumption/sqrt(omega);
spirit_consumption = spirit_consumption/sqrt(omega);
wine_consumption = wine_consumption/sqrt(omega);
score = score/sqrt(omega); 
Generosity=Generosity/sqrt(omega);
run ;

proc reg data=mt3 ;
title "Regression &title. Moindre Carré Quasi Généralisé";
model &cible. = &model. is /noint;
run ;
%mend MCQG;



/* Estimateur between */
%macro between(data=,
				cible=,
				model=,
				method=MCO);
proc sort data=&data.; by country;
proc means noprint data=&data.; by country;
var 	&cible.
		&model.;
output out=between mean=;
run;

%if &method. = MCO %then %do;

proc reg data=between ;
title "Regression Between";
model &cible. = &model./HCC SPEC;
run ;

%end;

%if &method = MCGQ %then %MCQG(data=between,cible=&cible.,model=&model.,title=between);

run;
%mend between;


/* Estimateur within */

%macro within(data=,
				cible=,
				model=,
				method=);
proc sort data=&data.; by country;
proc standard mean=0 data=&data. out=within; by country;
var &cible.
	&model.;

run;

%if &method. = MCO %then %do;

proc reg data=within;
title "Regression Within";
model &cible. = &model./noint HCC SPEC;
run ;

%end;

%if &method = MCGQ %then %MCQG(data=within,cible=&cible.,model=&model., title=within);

run;
 		
%mend within;








