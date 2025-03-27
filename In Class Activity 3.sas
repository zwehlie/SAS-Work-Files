*Create a “class” library reference referring to the folder you
want to save all the future sas data sets into in this activity;
libname Class "C:\Users\zwehl\OneDrive - Kennesaw State University\SAS Work Files\Potential Projects";
*Import the boots.xlsx file into the class library, call it
“bootsales”;
Proc import datafile="C:\Users\zwehl\OneDrive - Kennesaw State University\SAS Work Files\data week4\data week4\boots.xlsx"
out=work.bootsales
dbms=xlsx
  replace;
 sheet=boot;
getnames=yes; 
run;
proc contents data= bootsales;
run;
proc print data=bootsales;
run;
*Import the boot.csv file into the class library;
proc import datafile ="C:\Users\zwehl\OneDrive - Kennesaw State University\SAS Work Files\data week4\data week4\boot.csv"
out=boot
 dbms=csv
 replace;
 getnames=no;
run;
proc contents data= boot;
run;
proc print data=boot;
run;
proc import datafile="C:\Users\zwehl\OneDrive - Kennesaw State University\SAS Work Files\data week4\data week4\delimiter.txt"
out=delimiter
dbms=dlm;
delimiter='%';
run;
proc import datafile="C:\Users\zwehl\OneDrive - Kennesaw State University\SAS Work Files\data week4\data week4\FlyRNAi_data_baseline.txt"
out=FlyRNAi_data_baseline
dbms=tab
;
run;


