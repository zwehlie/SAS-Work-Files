libname clinic "C:\Users\zwehl\OneDrive - Kennesaw State University\SAS Work Files";
data clinic.admit2;
set clinic.admit;
run;

proc contents Data= clinic.admit;
run;
*Question 1: The data set describes a lists of patient's names and information in a table.
Information about the variables are act level,age,date,fee,height,ID,name,sex,and weight.
There are four characters along with five numeric variables however there are nine variables total;


