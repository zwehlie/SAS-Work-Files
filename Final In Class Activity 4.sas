/*************CHAPTER 6***********/

/* Chapter 6 Part 1 Datasets:
'admit' SAS file from cert data
'heart' SAS file from cert data
‘DCCT’ Excel file from D2L ( I name this ‘diabetes’ in the SAS code)
'insure' SAS file from cert data
'stress' SAS file from cert data
'therapy' SAS file from cert data
'laguardia' SAS file from cert data

*/

libname class "C:\Users\zwehl\OneDrive - Kennesaw State University\SAS Work Files\Week6 data";



/*   EXAMPLE 1: The VAR statement   */

/*   Basic print procedure   */
proc print data=class.admit;
run;

/*   Print selecting specific variables   */
proc print data=class.admit;
	var age height weight fee;
run;

proc print data=class.admit;
	var height weight fee age;
run;


/*   EXAMPLE 2: Removing the observation number   */
proc print data=class.admit noobs;
	var age height weight fee;
run;


/*   EXAMPLE 3: Assign new id   */
/*   no need to include noobs option */
proc print data=class.admit;
	var age height weight fee;
	id id name;
run;

/*   If id in var and id statement, will duplicate   */
proc print data=class.admit;
	var id age height weight fee;
	id id name;
run;

/*   EXAMPLE 4: Selecting observations with WHERE   */
proc print data=class.admit;
	var age height weight fee; /*#1*/
	where age>30; /*#2*/
run;
/*   1: The VAR statement selects the variables Age, Height, Weight,  */
/*      and Fee and displays them in the output in that order.        */
/*   2: The WHERE statement selects only the observations.            */


/*   Replace obs with new id   */
proc print data=class.admit;
	var age height weight fee;
	id id;
	where age>30; 
run;

*character variable values are case sensitive;
proc print data=class.admit;
	var age height weight fee sex;
	where age>30 and sex='F'; 
run;

proc print data=class.admit;
	var age height weight fee sex;
	where age>30 and sex='f'; 
run;



/*   REFRESHER EXAMPLES: OBS and FIRSTOBS   */

/*   How many observations are printed?      */
/*   11                                      */
options firstobs=10;
proc print data=class.heart;
run;

/*   How many observations are printed?      */
/*   10                                      */
options firstobs=1 obs=10;
proc print data=class.heart;
run;

/*   How many observations are printed?      */
/*   6                                       */
options firstobs=10 obs=15;
proc print data=class.heart;
run;

/*   How many observations are printed?      */
/*   error code                              */
options obs=3;
proc print data=class.heart;
run;

/*   Have to reset using obs=max and re-run   */
/*   How many observations are printed?       */
/*   all 20                                   */
options firstobs=1 obs=max;
proc print data=class.heart;
run;

/*   How many observations are printed?      */
/*   3                                       */
options obs=3;
proc print data=class.heart;
run;


/*   EXAMPLE 5: Selecting observations - contains   */ 
options firstobs=1 obs=max;
proc print data=class.heart;
	where shock ? 'NEU';
run;

proc print data=class.heart;
	where shock contains 'NEU';
run;

proc print data=class.heart;
	where shock contains 'N';
run;

/*   Case senstive in quotes and will pick up any part of the text string that contains 'O'   */
proc print data=class.heart;
	where shock contains 'O';
run;

/*   Can NOT use contians with numeric variables too   */
proc print data=class.heart;
	where heart contains 130;
run;



/*   EXAMPLE 6: Selecting observations - Compound statements   */

/*   AND statement   */
proc print data=class.admit;
	var age height weight fee;
	id id;
	where age<=55 and weight>175;
run;

/*   OR statement   */
proc print data=class.admit;
	var age height weight fee;
	id id;
	where age<=55 or weight>175;
run;

proc print data=class.admit;
	var age height weight fee actlevel;
	id id;
	where actlevel='LOW' or actlevel='MOD';
run;


/*   AND vs OR in the WHERE statement   */
proc print data=class.admit;
	var age sex height weight fee actlevel;
	id id;
	where sex='F' and actlevel='MOD';
run;

proc print data=class.admit;
	var age sex height weight fee actlevel;
	id id;
	where sex='F' or actlevel='MOD';
run;


proc print data=class.admit;
	var age height weight fee;
	id id;
	where sex='F' or actlevel='MOD';
run;



/*   EXAMPLE 7: Selecting observations - Compound statements with parenthesis   */

/*   Parenthesis applied first - both AND OR */
proc print data = class.admit;
	where (age > 30 and actlevel = "HIGH") or sex = "M";
run;

/*   Can use IN operator alternatively for OR statements   */
proc print data=class.admit noobs;
	var age height weight fee actlevel;
	where actlevel in ('LOW','MOD');
run;
/****************************** CHAPTER 6: IN CLASS ACTIVITY: PART A **************************/
/* We will be using the DCCT dataset for these exercises */


options validvarname=v7;
PROC IMPORT datafile='C:\Users\zwehl\OneDrive - Kennesaw State University\SAS Work Files\Week6 data\DCCT.xlsx'
	dbms=xlsx
	out=class.diabetes
	replace;
  sheet=DCCT;
  getnames=yes;
RUN;

PROC CONTENTS data=class.diabetes;
run;
/*   #1                                                                                  */ 
/*   Using the DCCT data set from D2L, create a new variable for each patient that is    */ 
/*   the average Hemoglobin A1c (%) by taking the mean of HBA1C00, HBA1C04 AND HBA1C08.  */
/*   Create a new data set of only female patients who are undergoing standard diabetes  */
/*   treatement as indicated by (STD) and who have an average hbA1c level greater than   */
/*   7.8 OR a body mass index (BMI) at baseline 18.0 or less .                           */
data females_std;
    set class.diabetes; 
    avg_hba1c = mean(HBA1C00, HBA1C04, HBA1C08);           
    if GENDER = 'F' and GROUP = 'STD' and
       (avg_hba1c > 7.8 or BMI00 <= 18.0) then do;
       keep PID GROUP GENDER AGE avg_hba1c BMI00; 
       output;
    end;
run;
proc print data=females_std;
    title 'Female Treatment(std) avg HbA1c > 7.8 or BMI <= 18.0';
run;
title;
/*   Print out this newdataset with PID as the new ID and only print out the  */
/*   variables group, gender, age, average hbA1c and baseline BMI.            */
data females_std;
    set class.diabetes;
	 avg_hba1c = mean(HBA1C00, HBA1C04, HBA1C08);
	  if GENDER = 'F' and GROUP = 'STD' and
       (avg_hba1c > 7.8 or BMI00 <= 18.0) then do;
PID_new = _N_;
 keep PID_new GROUP GENDER AGE avg_hba1c BMI00;
 output;
    end;
run;
/*   How many patients are in this new data set?                              */

*185 patients

/*	 What are the average, standard deviation, minimum and maximum values for */ 
/*   BMI and hbA1c?                                                           */
/* Calculate summary statistics for BMI and avg_hba1c                         */*;
proc means data=females_std mean std min max;
    var BMI00 avg_hba1c;
    title 'Stats for BMI and average hbA1c in Female (STD)';
run;
title;
/*   #2                                                                       */ 
/*   Using the DCCT data set from D2L, answer the following questions:        */

/*   How many males are in the dataset who are in the intensive diabetes      */ 
/*   therapy program who are at least 40 years old and have elevated systolic */ 
/*   blood pressure as indicated by SBP00 greater than 129 or a baseline BMI  */
/*   greater than or equal to 30?                                             */
/* Step 1: Filter the dataset for males in the intensive diabetes therapy program */
data males_intensive;
    set class.diabetes; 
    if GENDER = 'M' and GROUP = 'EXP' and AGE >= 40 and
       (SBP00 > 129 or BMI00 >= 30) then do;
       keep PID GROUP GENDER AGE SBP00 BMI00;
       output;
    end;
run;
proc sql;
    select count(*) as Male_Count
    from males_intensive;
	title 'male intensive count';
quit;
title;
/*   What are the average, standard deviation, minimum and maximum values for */ 
/*   age, BMI00 and SBP00?                                                    */  
proc means data=males_intensive mean std min max;
    var AGE BMI00 SBP00;
	title 'Stats for Male Intensive age, BMI00 and SBP00';
	run;
	title;
/*   Print out this newdataset with PID as the new ID and only print out the  */
/*   variables group, gender, age, baseline BMI and systolic blood pressure.  */                                   
data males_intensive;
    set class.diabetes;
	 if GENDER = 'M' and GROUP = 'EXP' and AGE >= 40 and
       (SBP00 > 129 or BMI00 >= 30) then do;
	     PID_new = _N_;
		   keep PID_new GROUP GENDER AGE BMI00 SBP00;
		     output;
    end;
run;

proc print data=males_intensive noobs;
    var PID_new GROUP GENDER AGE BMI00 SBP00;
	title 'Stats for Male Age >= 40, with Elevated SBP or BMI';
run;

title;


/*   #3                                                                       */ 
/*   Using the DCCT data set from D2L, answer the following questions:        */

/*   How many females have a total cholesterol baseline of 200 or greater in  */
/*   in the intensive diabetes therapy program versus the standard program?   */
proc sql;
    select count(*) as Female_Intensive_Count
    from class.diabetes
    where GENDER = 'F' and GROUP = 'EXP' and CHOL00 >= 200;
	title 'female intensive count';
quit;
title;
proc sql;
    select count(*) as Female_Standard_Count
    from class.diabetes
    where GENDER = 'F' and GROUP = 'STD' and CHOL00 >= 200;
	title 'female standard count';
quit;
title;
/*   How many males have a total cholesterol baseline of 200 or greater in    */
/*   in the intensive diabetes therapy program versus the standard program?   */
proc sql;
select count(*) as male_intensive_count
from class.diabetes
where GENDER = 'M' and GROUP = 'EXP' and CHOL00 >= 200;
title 'male intensive count';
quit;
title;
proc sql;
select count(*) as male_standard_count
from class.diabetes
where GENDER = 'M' and GROUP = 'STD' and CHOL00 >= 200;
title 'male standard count';
quit;
title;
/*   Create a report by printing the first 10 observations for each group     */
/*   and only print gender, group and baseline cholesterol. Create a title    */
/*   for each group.                                                          */

proc print data=class.diabetes (obs=10);
    where GROUP = 'EXP';
    var GENDER GROUP CHOL00;
	 title 'First 10 Observations for each group in (EXP)';
	 run;
proc print data=class.diabetes (obs=10);
    where GROUP = 'STD';
    var GENDER GROUP CHOL00;
	title 'First 10 Observations for each group in (STD)';
	run;


/****************************** CHAPTER 6: END IN CLASS WORK: PART A **************************/


/*   EXAMPLE 8: Generating column totals   */

proc print data = class.admit;
	var name sex fee;
	sum fee;
run;

proc contents data=class.insure;
run;

proc print data=class.insure;
run;

proc print data=class.insure;
	var name policy balancedue;
	where pctinsured < 100;
	sum balancedue;
run;



/*   EXAMPLE 9: Requesting subtotals   */

proc sort data = class.admit out = activity;
	by actlevel;
run;

proc print data = activity;
	var age height weight fee;
	where age > 30;
	sum fee;
	by actlevel;
run;

/* sort with decending order */
proc sort data = class.admit out=activity2;
	by decending actlevel;
run;


/*  Example 10 With ID statement   */
proc print data = activity;
	var age height weight fee;
	where age>30;
	sum fee;
	by actlevel;
	id actlevel;
run;


/*   EXAMPLE 11: Requesting subtotals - Customizing the layout   */
/*   Pageby   */
proc sort data=sort.admit out=activity;
	by actlevel;
run;

proc print data=activity;
	var age height weight fee;
	where age>30;
	sum fee;
	by actlevel;
	id actlevel;
	pageby actlevel;
run;

/*   EXAMPLE 12: Titles and footnotes   */
title1 "Admits for people over 30";
proc print data = class.admit;
	var name age fee;
	id id;
run;


/*   EXAMPLE 13: Can have multiple titles and lines   */
/*
title1 'Heart Rates for Patients with:';
title3 'Increased Stress Tolerance Levels';
proc print data=class.stress;
	var resthr maxhr rechr;
	where tolerance='I';
run;
*/

title1 "Admits for people over 30";
title3 "Data source: sasusers.admits";
proc print data = class.admit;
var name age fee;
id id;
run;

title1;
title3;
proc print data = class.admit noobs;
var name age fee;
run;

/*   EXAMPLE 14: Footnotes   */
title1 "This is my title";
footnote1 "This a footnote";
proc print data = class.admit noobs;
	var name age fee;
run;


/*   Modifying and canceling titles and footnotes   */
/* changing the data set */
proc print data=class.therapy;
	var swim walkjogrun aerclass;
run;

/*   Title 2 cancels Title 3 due to placement   */
title1 'Heart Rates for Patients with';
title3 'Participation in Exercise Therapy';
footnote1 'Data from Treadmill Tests';
footnote3 '1st Quarter Admissions';
proc print data=class.therapy;
	var swim walkjogrun aerclass;
run;

title2 'Report for March';
proc print data=class.therapy;
run; 

/*   Cancel title and footnote   */
title1;
proc print data=class.therapy;
	var swim walkjogrun aerclass;
run;
footnote1;
footnote3;

proc print data=class.therapy;
	var swim walkjogrun aerclass;
run;

/*   Can also cancel title and footnote this way   */
title;
footnote;

/*   Test that title and footnote are canceled   */
proc print data = class.admit noobs;
	var name age fee;
run;


/*   EXAMPLE 15: Assigning descriptive labels - temporary   */

/*   Without labels   */
proc print data=class.admit;
run;

/*   With labels   */
proc print data = class.admit label;
	var name age fee actlevel;
	label actlevel = "Activity Level";
run;

* if no lable keyword, then doesn't print the label as variable name;
proc print data = class.admit;
	var name age fee actlevel;
	label actlevel = "Activity Level";
run;

/*   Another example   */

proc print data=class.admit;
	var age height;
run;

proc print data=class.admit label;
	var age height;
	label age='Age of Patient';
	label height='Height in Inches';
run;

/*   Multiple labels under one statement   */
proc print data=class.admit label;
	var actlevel height weight;
	label actlevel='Activity Level'
	  	  height='Height in Inches'
	  	  weight='Weight in Pounds';
run;

/*   EXAMPLE: Assigning descriptive labels - permanent   */
proc print data=class.laguardia;
run;

data class.paris;
	set class.laguardia;
	where dest='PAR' and (boarded=155 or boarded=146);
	label date='Departure Date';
run;

proc print data=class.paris label;
	var date dest boarded;
run;


/****************************** CHAPTER 6: IN CLASS WORK: PART B **************************/

/*   #4                                                                                   */ 
/*   Using the DCCT data set from D2L, generate a report with subtotals for insulin dose  */
/*   at baseline, insulin dose at 1 year, and insulin dose at 2 years for individuals in  */
/*   the intensive diabetes therapy group. Make a second, similar report for the standard */
/*   diabetes therapy group. Be sure to replace the observation number with the id number */
/*   and only print include the variables group, gender, age and insulin levels           */
/*   (baseline, year 1 and year 2). Change the label of the insulin level variables       */
/*   to temporary, more descriptive names and be sure to include a title that indicates   */
/*   treatement group for each therapy and a footnote that indicates that this is for the */
/*   Diabetes Control and Complications Trial.                                            */





