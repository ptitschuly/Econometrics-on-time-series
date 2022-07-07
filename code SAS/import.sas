%macro import_csv(
				file=,
				name=,
				del="",
					);

%if del = "" %then %let delimiter=;
%else %let delimiter= delimiter=&del.;

					
proc import datafile="&path.data_csv/&file."
			out=&name.
			dbms=csv REPLACE;
			&delimiter.;
			run;
			
%mend import_csv;


%macro import_all_data(active=True, lib=);

%if &active. = True %then %do;

%import_csv(file=2015.csv, name=&lib..bonheur2015, del=",");
%import_csv(file=2016.csv, name=&lib..bonheur2016, del=",");
%import_csv(file=2017.csv, name=&lib..bonheur2017, del=",");
%import_csv(file=2018.csv, name=&lib..bonheur2018, del=",");
%import_csv(file=2019.csv, name=&lib..bonheur2019, del=",");
%import_csv(file=wine-consumption-per-person.csv, name=&lib..wine, del=",");
%import_csv(file=spirits-consumption-per-person.csv, name=&lib..spirits, del=";");
%import_csv(file=beer-consumption-per-person.csv, name=&lib..beer, del=",");
%end;


%mend import_all_data;





			