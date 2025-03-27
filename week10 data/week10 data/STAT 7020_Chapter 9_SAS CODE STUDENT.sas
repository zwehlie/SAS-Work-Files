/***    CHAPTER 9 PART 1: PROC TRANSPOSE & MACRO VARIABLES ***/

libname class "E:\Users\sni\OneDrive - Kennesaw State University\Fall24_STAT\10_16\week10 data";

/*   EXAMPLE 1: Subsetting to Only Calculate Observations with Specific Values   */
DATA stresstest1;
	set class.tests;
	if tolerance = 'D'; *only D responses are selected;
	TotalTime=(timemin*60)+timesec;
RUN;
PROC PRINT data=stresstest1 label;
RUN;

*keep in mind how = works with character values;
*either;
DATA stresstest1a;
	set class.tests;
	if tolerance in ('D' , 'I');
	TotalTime=(timemin*60)+timesec;
RUN;
PROC PRINT data=stresstest1a;
RUN;

*or this;
DATA stresstest1b;
	set class.tests;
	if tolerance ='D' or tolerance= 'I';
	TotalTime=(timemin*60)+timesec;
RUN;
PROC PRINT data=work.stresstest1b;
RUN;

*or use not statement;
/*
proc freq data=class.tests;
	tables tolerance;
run;
*/

DATA stresstest1c;
	set class.tests;
	if tolerance not in ('N','S');
	TotalTime=(timemin*60)+timesec;
RUN;
PROC PRINT data=stresstest1c;
RUN;

/*   Example 2: Re-evaluation variables*/
data stresstest3;
	set class.tests;
	resthr=resthr+(resthr*.10);
run;
proc print data=stresstest3;
run;

/*   Example 3: Assignment Statements and Date Values*/
data stresstest3;
	set class.tests;
	TotalTime=(timemin*60)+timesec;
	BaselineDate='01jan1960'd;
run;
proc print data=work.stresstest3;
run;

/*   EXAMPLE 4: Initialize and Retain Statements   */
data stresstest4;
	set class.tests;
	TotalTime=(timemin*60)+timesec;
	retain SumSec 5400;
	sumsec+totaltime;
run;
proc print data=stresstest4;
run;

*notice difference in assignment statement when not using retain;
data work.stresstest4b;
set cert.tests;
TotalTime=(timemin*60)+timesec;
SumSec = 5400; /*if = sign is removed, SAS let's you know there is a problem*/
sumsec+totaltime; /*logic is different here, it is not an accumulator, rather each observation will add 5400 to it*/
run;
proc print data=work.stresstest4b;
run;

/*   EXAMPLE 5: Length and Retain Statements   */

/* With Length Statement */
DATA stress_yes;
	set class.stress;
	TotalTime=(timemin*60)+timesec;
	retain SumSec 5400;
	sumsec+totaltime;
	length TestLength $ 6;
	if totaltime>800 then testlength='Long';
	else if 750<=totaltime<=800 then testlength='Normal';
	else if totaltime<750 then TestLength='Short';
RUN;
proc print data=stress_yes;
run;

/* No Length Statement */
DATA stress_no;
	set class.stress;
	TotalTime=(timemin*60)+timesec;
	retain SumSec 5400;
	sumsec+totaltime;
	if totaltime>800 then testlength='Long';
	else if 750<=totaltime<=800 then testlength='Normal';
	else if totaltime<750 then TestLength='Short';
RUN;
proc print data=stress_no;
run;

/* EXAMPLE 6: IF-THEN Statement False Condition  */
DATA stress_1;
	set class.stress;
	TotalTime=(timemin*60)+timesec;
	retain SumSec 5400;
	sumsec+totaltime;
	if totaltime>800 then testlength='Long';
RUN;
proc print data=stress_1;
run;

/* EXAMPLE 7: IF-THEN delete statement  */
DATA stresstest7;
	set class.tests;
	if tolerance ='D' then delete;
	TotalTime=(timemin*60)+timesec;
RUN;

PROC PRINT data=stresstest7;
RUN;

/*logical operators*/
DATA stresstest8;
	set class.tests;
	if (tolerance ^= 'D' | resthr <75) then delete; /*deletes all not Ds or restHR below 75*/
	TotalTime=(timemin*60)+timesec;
RUN;
PROC PRINT data=stresstest8;
RUN;

DATA stresstest8b;
	set class.tests;
	if tolerance not in  ('S', 'N', 'I') then delete; /*deletes all Ds*/
	TotalTime=(timemin*60)+timesec;
RUN;
PROC PRINT data=work.stresstest8b;
RUN;


/***    CHAPTER 9 PART 2: PROC TRANSPOSE & MACRO VARIABLES ***/

/* Example 1: Default Transposition */
*original class data;
proc print data=class.class;
title 'not transposed dataset';
run;
title;

*now lets transpose;
*no optionts;
PROC TRANSPOSE data=class.class out=score_transposed1; /*#1*/
RUN;

PROC PRINT data=score_transposed1 noobs label; /*#2*/
title 'Scores for the Year';
RUN;
title;

*specify the name variable and the other variable prefix in the transposed data;
PROC TRANSPOSE data=class.class out=score_transposed /*#1*/
	name = VariableName
	prefix =targetColName;
RUN;

PROC PRINT data=score_transposed noobs /*label*/; /*#2*/
title 'Scores for the Year';
RUN;
title;

/* Example 2: Transposing Specific Variables */
proc print data = class.cltrials;
run;

PROC TRANSPOSE data=class.cltrials out=transtrials1; /*#1*/
	var testdate Cholesterol Triglyc Uric; /*#2*/
RUN;

PROC PRINT data=transtrials1; /*#3*/
RUN;
title;

/* Example 3: Naming Transposed Variables */
PROC TRANSPOSE data=class.cltrials out=transtrials2; /*#1*/
	var cholesterol triglyc uric; /*#2*/
	id name testdate; /*#3*/
RUN;

PROC PRINT data=transtrials2; /*#4*/
RUN;

/* Example 4: Transposing BY Groups */
PROC SORT data=class.cltrials out=ex4;
	by testdate;
RUN;

PROC TRANSPOSE data=ex4 out=transtrials3; /*#1*/
	var cholesterol triglyc uric; /*#2*/
	id name; /*#3*/
	by testdate; /*#4*/
RUN;

PROC PRINT data=transtrials3; /*#5*/
RUN;


/* Example 5.1: Default  */
*original dataset;
proc print data= sashelp.class;
run;
proc contents data=sashelp.class;
run;

*transpose all numeric variables;
PROC TRANSPOSE data = sashelp.class
	out = work.class_1;
RUN;
proc print data= work.class_1;
run;

*notice that all transposed variables are numeric if default only numeric are transposed;
proc contents data= work.class_1;
run;

/* Example 5.2: Variable  */
PROC TRANSPOSE data = sashelp.class out = work.class_2;
	var sex;
RUN;
proc print data= work.class_2;
run;
proc contents data=work.class_2;run;

/* Example 5.3: Numeric Variables Converted to Character Variables */
PROC TRANSPOSE data = sashelp.class out = work.class_3;
	var age height weight sex;
RUN;
proc print data= work.class_3;
run;

*notice the inclusion of 1 character variable, now all variables are character;
proc contents data= work.class_3;
run;

/* Example 5.4: Name */
proc print data=sashelp.class;
run;

PROC TRANSPOSE data = sashelp.class 
	out = work.class_4
	name = health;
 var age height weight;
RUN;
proc print data= work.class_4;
run;
/*need to view variable attribute to see the health name*/

/* Example 5.4a: Name with prefix */
PROC TRANSPOSE data = sashelp.class
	out = work.class_4a
	name = health
	prefix = PatientHealth;
var age height weight;
RUN;
proc print data= work.class_4a;
run;

/* Example 5.5: ID to Rename Columns*/
PROC TRANSPOSE data = sashelp.class
	out = work.class_5
	name = health;
	var age height weight sex;
	ID name; /*the original variable name from the not transposed file*/
RUN;
proc print data= work.class_5 label; /*notice the default label name*/
run;

*change default label for name variable from "name of former variable using label;
proc print data= work.class_5 label;
	label health = "health indicators";
run;

*can also use more than one variable name for id, it will be concatenated;
PROC TRANSPOSE data = sashelp.class
	out = work.class_5a
	name = health;
	var age height weight sex;
	ID name age; /*the original variable name from the not transposed file and their age*/
RUN;
proc print data= work.class_5a;
run;

*can add label to change the default variable label as well;
PROC TRANSPOSE data = sashelp.class
	out = work.class_5b
	name = health;
var age height weight sex;
label health = 'all the data in col now'; /*the original variable name from the not transposed file*/
RUN;
proc print data= work.class_5b label;
run;

*can add prefix with the ID statement;
PROC TRANSPOSE data = sashelp.class
	out = work.class_5c
	name = health
	prefix=PatientName_;
var age height weight sex;
ID name; /*the original variable name from the not transposed file*/
RUN;
proc print data= work.class_5c;
run;

/* Example 5.6: BY Statement */
*Do not need to sort because file is already sorted by name;
PROC TRANSPOSE data = sashelp.class
	out = work.class_6
	name = health;
var age height weight sex;
By name;
RUN;
proc print data= work.class_6;
run;

/* Example 5.7: Label to Override Default Label  */
title "Proc Transpose Results";
PROC PRINT data = work.class_6 label noobs;
	label health = "Health";
	label COL1 = "HealthStats";
RUN;
title;

/*   IN-CLASS ACTIVITY: CHAPTER 9 PART 2 */
/*   Using the chick data file from D2L, import the data file into the SAS environment.   */
/*	 The four variables are weight, time, chickID and diet.                               */s
/*   Transpose the long data file into a wide format file keeping only weight and ID as   */
/*   variables. Make sure to include the word 'time' as a prefix for the new columns.     */
/*   Then, convert the wide format chick dataset back to long format. Print both datasets */ 




/*   CHAPTER 9 PART 3: MACRO VARIABLES   */

/* Example 6: Using SAS Macro Variables with Numeric Values */
%let Cyl_Count=6; /*#1*/

*could change to 6 cylinders;
*%let Cyl_Count=6;

PROC PRINT data=sashelp.cars;
	where Cylinders=&Cyl_Count; /*#2*/
	var Type Make Model Cylinders MSRP;
RUN;

PROC FREQ data=sashelp.cars;
	where Cylinders=&Cyl_Count;
	tables Type;
RUN;

/* Example 7: Using SAS Macro Variables with Character Values */
%let CarType=SUV; /*#1*/
%let TitleX=PROC PRINT Of Only &CarType Cylinder Vehicles;/*notice macro variable inside this macro*/ 

title "&TitleX";
PROC PRINT data=sashelp.cars;
	where Type="&CarType"; /*#2*/
	var Type Make Model MSRP;
RUN;

PROC MEANS data=sashelp.cars;
	where Type="&CarType";
	var MSRP MPG_Highway;
RUN;

PROC FREQ data=sashelp.cars;
	where Type="&CarType";
	tables Origin Make;
RUN;

/*   IN-CLASS ACTIVITY: BASE SAS QUIZ */
/* #2 Consider the IF-THEN statement shown below. When the statement is executed, which expression is evaluated first?

/* #9 Which of the following programs correctly reads the data set Orders and creates the data set FastOrdr? */


/*****************************************************************************************************/
/*   IN-CLASS ACTIVITY: CHAPTER 9 PART 3                                                             */
/*                                                                                                   */
/*   Q1: Create a macro variable to replace the dataset name snacks in the sashelp library.          */
/*   Include a title that prints out the name of the dataset. Print the first 5 observations in      */
/*   the dataset using the macro variable.                                                           */



/*   Q2: using the macro variable, sort the data by date of sale. Then  within a datastep, then       */
/*   subset the data for only sales after October 1 2004 create a new variable that is called         */
/*   totaled product sales based on the quantity sold times (1=yes) then the retail price             */
/*   of the product. If the product was sold on advertisement give the  totaled sales value a 10%     */
/*   increase. Create an running total for all daily sales sold after October 1, 2004 but start the   */
/*   running total with negative $1000 as the starting value (this was the budgeted advertising       */
/*   expense for the month for all products). Make sure the total daily product sales and             */
/*   the running total sales are formatted correct for dollars and cents. Create a new variable       */
/*   that categorized sales into either 'normal sales' for sales less than $30 or 'huge daily sales   */
/*   winner' for sales larger than $30.  Make sure the entire category name prints out.               */

/*    1.) Print the first 5 observations of the new dataset.                                          */
/*    2.) What day did the running total reach the break even price compared to advertising costs?    */

