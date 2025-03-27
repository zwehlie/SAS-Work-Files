***********************************;
* Code chunk 1                    *;
* libname statement               *;
***********************************;
libname clinic "C:\Users\sni\Desktop\Fall24_STAT";


data admit4;
   set clinic.admit;
run;




***********************************;
* Code chunk 2                    *;
* make new dataset and print      *;
***********************************;
* libname clinic "C:\Users\sni\Desktop\Fall24_SAT";
data clinic.admit2;
	set clinic.admit;
run;

proc print data = clinic.admit2;
run;





***********************************;
* Code chunk 3                    *;
* libname statement               *;
* Proc contents                   *;
***********************************;
* libname clinic "C:\Users\sni\Desktop\Fall24_STAT";
proc contents data = clinic.admit;
run;

proc contents data = clinic.admit varnum;
run;


***********************************;
* Code chunk 4                    *;
* SAS Assignment Statements       *;
* Turn height into feet           *;
***********************************;
data admit; *note this admit is in the work library, a temporary library;
	set clinic.admit;
	
	height2 = height/12;
run;

proc print data = admit (keep = id height height2);
run;

proc print data = clinic.admit (keep = id height height2);
run;


***********************************;
* Code chunk 5                    *;
* Import the Excel file stress.xls *;
* into the work directory. Call   *;
* the dataset tmp                 *;
***********************************;

*DBMS = EXCEL may have ACCESS error due to some software missing or miss-match;
*between the 32-bit SAS and 64-bit Microsoft Excel;
*change DBMS to xls solves the problem;

proc import datafile = "C:\Users\sni\Desktop\Fall24_STAT\stress.xls"
out = tmp 
DBMS = xls 
Replace;
sheet = "stress";
run;

PROC PRINT DATA=tmp;
RUN;



*************************************;
* Code chunk 6                      *;
* Export the tmp sas dataset in     *;
* the work library as an Excel file *;
* with name “tmp.xls”.              *;
* Save the file into a folder in c: *;
***********************************;
proc export data = tmp
   outfile = 	"C:\Users\sni\Desktop\Fall24_STAT\tmp.xls"
   dbms = xls 
   replace;
   SHEET=NewSheet;
run;


***********************************;
* Code chunk 7                    *;
* Output file as fixed format     *;
* data separated by blanks        *;
***********************************;
data _null_;
	 set admit ;
  file 'C:\Users\sni\Desktop\Fall24_STAT\hgt1.txt';
  put id name sex age date height weight ActLevel fee height2;
run;
