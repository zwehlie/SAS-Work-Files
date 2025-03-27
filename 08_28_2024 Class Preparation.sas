*********************************************************;
*This is the code used in class as part of the lecturer *;
*on 08/28/2024, week 3 of the semester.                 *;                 
*                                                       *;
*Author: Sherry Ni                                      *;
*********************************************************;

*global options;
*clear out the log window and the output window;
DM "log; clear; output; clear";

*Create library reference.;
*Make sure to download datasets into onedrive;
*and then link the one drive folder with some libary reference.;

*In order to run this SAS file with minimum change,;
*it is recommended to update only the location of the library in the codes below.;
*Update the path to the onedrive folder where you have saved the downloaded data.;
libname STAT 'C:\Users\sni\OneDrive - Kennesaw State University\Fall24_STAT';
libname inclass C:\Users\zwehl\OneDrive - Kennesaw State University\SAS Work Files

*Move the CARS sas data set from the sashelp library to the inclass library;
data inclass.cars;
   set inclass.cars;
   run;

*Print the cars data set in the inclass library;
proc print data=car.cars;
run;

*Print the first 10 observations in the cars data set;
proc print data=inclass.cars (obs=10);
run;

*Print the 11 observations but start with observation number 10;
*Need to calculate the values for 
*firstobs=
*obs=
*carefully; 
proc print data=inclass.cars (firstobs=10 obs=20);
run;




****************************************************************;
*Global Options vs. Local Options                               ;
****************************************************************;
/* The following statement specify the global options. */
options firstobs=10 obs=18;

/* Uses the global OPTIONS. Since there is no local option*/
proc print data = inclass.cars; 
	title 'print 10th to 18th cases';
run;

/*Uses local option for Firstobs = 15, and use global option for obs=18 */
PROC PRINT data=inclass.cars (firstobs=15); 
	title 'prints cases 15 to 18'; 
run;

/*uses local option for Firstobs = 12, and obs=16.
Since local options overwrite global option for the specific procedure.*/
PROC PRINT data=inclass.cars (firstobs=12 OBS=16); 
	title 'prints cases 12 to 16 ';
run;
/*Uses local option for Firstobs = 5, and obs=20.
Since local options overwrite global option for the specific procedure.*/
PROC PRINT data=inclass.cars (firstobs=5 obs=20); 
	title 'prints 5 to 20 '; 
run;

*check other procedures under different options;
title ;'SAS Output';

proc means data=inclass.cars;
run;

proc means data=inclass.cars (firstobs=3 obs=4);
run;


********************************************************;
*IMPORTING & EXPORTING data set                         ;
********************************************************;
*redefine the obs options;
*PAY ATTENTION TO THIS!!!!!!!!!;
options firstobs=1 obs=max;

*Exporting data to Excel;
proc export data=inclass.cars
		outfile=C:\Users\zwehl\OneDrive - Kennesaw State University\SAS Work Files
		dbms=xls
		replace;
	sheet = "cars";
run;

*Exporting data to CSV;
proc export data=inclass.cars
		outfile="C:\Users\sni\OneDrive - Kennesaw State University\Fall24_STAT\08_28\cars.csv"
		dbms=csv
		replace;
run;

*Exporting data to pipe delimited file;
proc export
		data=inclass.cars
		outfile="C:\Users\sni\OneDrive - Kennesaw State University\Fall24_STAT\08_28\cars.txt"
		dbms=dlm
		replace;
	delimiter='|';
run;


*********************************************;
*exporting data with data set                ;
*list output                                 ;

data _null_;
	set inclass.cars;
	file "C:\Users\sni\OneDrive - Kennesaw State University\Fall24_STAT\08_28\cars2.txt";
	put make model type origin drivetrain MPG_City MPG_Highway;
run;


************************************;
* Import the Excel file stress.xls *;
* into the work directory. Call   *;
* the dataset tmp                 *;
***********************************;
proc import datafile = "C:\Users\sni\OneDrive - Kennesaw State University\Fall24_STAT\08_21\stress.xls"
		out = tmp 
		DBMS = EXCEL
		Replace;
	sheet = "stress";
run;

PROC PRINT DATA=tmp;
RUN;


**********************************;
*list input                       ;
*not required                     ;
**********************************;
data mycars;
	infile 'C:\Users\sni\OneDrive - Kennesaw State University\Fall24_STAT\08_28\cars_fix_width.prn';
	input make $ type $ origin $ drivetrain $ MPG_City MPG_Highway;
run;





