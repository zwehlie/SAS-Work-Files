/*************   CHAPTER 6 PART 2   ***********/
libname class "E:\Users\sni\OneDrive - Kennesaw State University\Fall24_STAT\09_24\week7 data";
libname class6 "E:\Users\sni\OneDrive - Kennesaw State University\Fall24_STAT\09_18\week6 data";


/*   EXAMPLE 16: Double space with labels   */
proc print data = class6.admit label;
	var name age fee actlevel;
	label actlevel = "Activity Level";
run;

ods html close;
ods listing;

ods listing close;
ods html;


/*   EXAMPLE 17: Summarize data with PROC MEANS */
proc means data=class6.diabetes;* n mean median std min max;
	var age BMI00 SBP00;
run;

proc means data = class6.diabetes;
	var age BMI00 SBP00;
	class gender;
run;


/*   EXAMPLE 18: Summarize data with PROC SUMMARY   */
title1 "PROC SUMMARY ";

/*
proc summary data = class6.diabetes;
	var age BMI00 SBP00;
	class gender;
run;
*/

proc summary data = class6.diabetes;
	var age BMI00;
	class gender;
	output out = work.sum_gender
	mean = avgage avgBMI00;
run;

proc print data = sum_gender;
run;
title1;

*PROC SUMMARY with the print option;
title1 "PROC SUMMARY ";
proc summary data = class6.diabetes print ;
	var age BMI00;
	class gender;
	output out = work.sum_gender
	mean = avgage avgBMI00;
run;
title1;


/* EXAMPLE 17-2: Creating average score variables with PROC MEANS   */
title "Proc Means";
proc means data = class6.admit ;
	var age height weight;
	class sex;
	output out = work.sum_gender2
	mean = avgage avgheight avgweight;
run;
title;


/* EXAMPLE 19: Creating average score variables with PROC MEANS (no print)  */
title "Proc Means";
proc means data = class6.admit noprint;
	var age height weight;
	class sex;
	output out = work.sum_gender3
	mean = avgage avgheight avgweight;
run;
title;

/*   EXAMPLE 20: Summarize data with PROC SUMMARY with Labels  */
title1 "PROC SUMMARY ";
proc summary data = class6.diabetes;
	var age BMI00;
	class gender;
	output out = work.sum_gender
	mean = avgage avgBMI00;
run;
title1;

data sum_gender;
	set sum_gender;
	label avgage='Age at Follow-up' avgBMI00='BMI at Baseline';
run;

proc print data = sum_gender label;
run;

/*   EXAMPLE 21: Summarize data with PROC FREQ   */
proc freq data=class6.diabetes;
	table group*quartile;
run;

proc freq data=class6.diabetes;
	table age;
run;

/****************************** CHAPTER 6 IN CLASS WORK: PART B **************************/

/* #1                                                                                    */ 
/* Using the DCCT data set from D2L week 6 class (we have imported it as class6.diabetes */

/* Produce averages for baseline LDL cholesterol (LDL00), baseline HDL cholesterol (HDL00),*/
/* and baseline total cholesterol (CHOL00) for each treatment group (GROUP).               */

/* Do this using two different techniques we have learned to summarize data. Output this */
/* information to a new dataset.                                                         */



/* #2                                                                                    */ 
/* Create a frequency table that shows average systolic blood pressure at                */
/* baseline based on gender. Next create a new variable by dichotomizing sysolic blood   */
/* pressure at baseline into normal and elevated categories with values of 129 and below */
/* considered 'normal' and all other values considered elevated. Then create a           */
/* frequency table for systolic blood pressure at baseline for those categories by       */
/* gender.                                                                               */

/* What table do you prefer and why? What does this imply about the PROC FREQ prcedure?  */ 



/* #3                                                                                    */ 
/* Create a summary table of all of the baseline biologic continuous variables in DCCT   */
/* dataset (class6.diabetes) including BMI, total cholesterol, triglycerides, ldl cholesterol,*/
/* hdl cholesterol, systolic blood pressure, diastolic blood pressure, insulin and       */
/* hbA1c. Make sure to examine summaries by treatment group. Print your summaries and    */
/* make sure to include an intuitive title. Make sure to output this dataset to a        */
/* permanent library. Make sure to print your results with intuitive titles.             */ 



/***************************** END CHAPTER 6 IN CLASS PART C ****************************/


/* EXAMPLE 22: sum statement (accumulator variable) */
data admit2;
	set class6.admit;
	total+fee;
run;

/* vs using sum statement in proc print */
proc print data = class6.admit;
	var fee;
	sum fee;
run;

/*   EXAMPLE 23: IF THEN ELSE   */
proc means data=class6.diabetes n nmiss mean std min max;
  var age;
run;

data cert1;
	set class6.diabetes;
	if 30 < age <= 35 then agegroup=1;
	else if 35 < age <= 45 then agegroup=2;
	else if age > 45 then agegroup=3;
run;

proc print data = cert1 (obs=30);
run;

proc freq data = cert1;
	table agegroup;
run;


/*   EXAMPLE 24: IF THEN ELSE with bounding   */

data cert2;
	set class6.diabetes;
	if 30 < age <= 35 then agegroup=1;
	if 35 < age <= 45 then agegroup=2;
	if age > 45 then agegroup=3;
run;
/*
proc print data = cert2 (obs=30);
run;
*/
proc freq data = cert2;
	table agegroup;
run;

/*   EXAMPLE 25: IF THEN ELSE without bounding   */
data cert3;
	set class6.diabetes;
	if age <=40 then agegroup=0;
	if age <=50 then agegroup=1;
	if age <=60 then agegroup=2;
	if age <=70 then agegroup=3;
run;

data cert4;
	set class6.diabetes;
	if age <=40 then agegroup=0;
	else if age <=50 then agegroup=1;
	else if age <=60 then agegroup=2;
	else agegroup=3;
run;

/***************************************************************/
/*   EXAMPLE 26: conditional statements with select  */
data cert5;
	set class6.diabetes;
	select (quartile);
		when (1 ) wght_gain = 'first quartile' ;
		when (2,3 )  wght_gain = 'middle half';
		otherwise wght_gain= 'top quartile' ;
	end;
run;

proc freq data=cert5;
   tables wght_gain;
run;


/***************************************************************/

/*   EXAMPLE 27: DO loops   */

proc contents data=class.mechanics varnum;
run;

data NYMechanics;
   set class.mechanics;
   if state = "NY" then do;
      if salary < 30000 and JobLevel in ('1' '2') then review = 1;
      else review  = 0;
      biweekly = salary/26;
      output NYMechanics;
   end;
run;

/*   EXAMPLE 28: subsetting IF, WHERE, DELETE statement*/
data admit3;
	set class6.admit;
	if sex = "M"; *happens in writing into the new data;
run;

data admit4;
	set class6.admit;
	where sex = "M"; *happens in reading in the data;
run;

data admit5;
	set class6.admit;
	if sex = "F" then delete;
run;

/*   EXAMPLE 29: subsetting KEEP and DROP statement*/
data NYMechanics;
	set class.mechanics;
	if state ne "NY" then delete;
	keep ID lastname firstname homephone salary;
run;

data NYMechanics;
	set class.mechanics;
	if state ne "NY" then delete;
	drop state gender;
run;

/*   EXAMPLE 30: Another way to use KEEP and DROP statements   */

/*  KEEP  */
data NYMechanics (keep = ID lastname firstname homephone salary) ;
	set class.mechanics;
	if state ne "NY" then delete;
run; 

 /*  vs.  */

data NYMechanics;
	set class.mechanics (keep = ID lastname firstname homephone salary);
	if state ne "NY" then delete;
run;

/*  DROP  */
data NYMechanics (drop = state gender) ;
	set class.mechanics;
	if state ne "NY" then delete;
run; 

/*  vs.  */

data NYMechanics  ;
	set class.mechanics (drop = state gender);
	if state ne "NY" then delete;
run;

/*   EXAMPLE 31: Point option   */
data obs17  ;
	slice = 17;	*Output observation 17 ;
	set class.mechanics point = slice;
	output;
	stop;
run;

data admit7;
	obsum=6;
	set class6.admit point=obsnum;
	stop;
run;

/*   EXAMPLE 32: Formats   */
proc print data=class6.admit label;
	var name age fee actlevel date; *date is number of days after 1/1/1960;
	label actlevel="Activity Level"; 
run;

data admit8;
	set class6.admit;
	format fee dollar9.2 date mmddyy8.; *recall the YEARCUTOFF= option?;
run;

/*
proc options option=yearcutoff;
run;
*/

data admit9;
	set class6.admit;
	format fee dollar9. date mmddyy10.;
run;

data admit10;
	set class6.admit;
	format fee dollar7.2 date mmddyy10.;
run;

proc print data=class6.admit;
	format fee dollar7.2 date mmddyy10.; *tempory format, only effective within the procedure;
run;

proc print data=class6.admit label;
	var name age fee actlevel date; *date is number of days after 1/1/1960;
	label actlevel="Activity Level"; *tempory label; 
run;


data nymechanics;
	set class.mechanics;
	format salary dollar8. Birth mmddyy10.;
run;

proc print data = nymechanics;
run;



/*   EXAMPLE 33: Labels   */
data mech;
	set class.mechanics;
	format salary dollar8. Birth mmddyy10.;
	label lastname = "Last Name"
	  firstname = "First Name"
	  birth = "Birth Date"
	  salary = "Annual Salary";

run;

/*   ODS Examples   */
ods html;
proc print data = mech (obs = 10 keep = lastname firstname birth salary);
run;
ods html close;

/* output window */
ods listing;
proc print data = mech (obs = 10 keep = lastname firstname birth salary);
run;
ods listing close;

/*   PDF Example   */
ods pdf;
proc print data = mech (obs = 10 keep = lastname firstname birth salary);
run;

ods pdf close;


data cert1;
	set class6.diabetes;
	if 30 < age <= 35 then agegroup=1;
	else if 35 < age <= 45 then agegroup=2;
	else if age > 45 then agegroup=3;
run;

ods html;
proc freq data=cert1;
	table agegroup*gender / nocol norow;
	label	agegroup = ’Age Category’
 			gender = ’Gender’
			group = ’Treatment Group’;
run;


/*   RTF (Word) Example   */
ods rtf;

proc print data = mech (obs = 10 keep = lastname firstname birth salary);
run;
ods rtf close;

/*   Antoher Example: Outputting a pdf file   */
ods pdf;
options nodate;
proc print data = mech (obs = 10 keep = lastname firstname birth salary);
	ods pdf file="E:\Users\sni\OneDrive - Kennesaw State University\Fall24_STAT\09_24\Example.pdf";
run;
ods pdf close;

/*   EXAMPLE 34: proc sort   */
proc print data = mech;
run;

proc sort data =  mech;
	by salary;
	run;
proc print data = mech;
run;

proc sort data =  mech out = mech_salary;
	by descending salary;
	run;
proc print data = mech_salary;
run;

proc sort data =  mech nodupkey out = state;
	by state;
	run;
proc print data = state;
run;

proc sort data =  mech nodupkey out = state;
	by descending state;
	run;
proc print data = state;
run;

/*   Caution with this -- need to make sure to use 'out' keyword  */
/*   Without "nodupkey", the original data set will be overwitten with the sorted observatio */
proc sort data =  mech nodupkey;
	by descending state;
	run;
proc print data = mech;
run;


