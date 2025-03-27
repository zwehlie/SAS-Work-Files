/***    CHAPTER 10 PART 1: COMBINING SAS DATASETS   ***/

libname class "C:\Users\zwehl\OneDrive - Kennesaw State University\SAS Work Files\Potential Projects\week11 data\week11 data";

/*   Example 1: Simple Data Set Merging   */
DATA A;
	input num vara $;
	datalines;
	1	A1
	3	A2
	5	A3
	;
RUN;

DATA B;
	input num varb $;
	datalines;
	2 B1
	4 B2
	;
RUN;

DATA one2one;
	set A;
	set B;
RUN;

PROC PRINT data = one2one;
RUN;

/*   Example 2: Concatenating (A & B)  */
DATA concat;
	set A B;
RUN;

PROC PRINT data = concat;
RUN;

/*   Example 3: Appending with PROC APPEND (similar to above)  */
DATA A_1;
	input num vara $;
	datalines;
	1	A1
	3	A2
	5	A3
	;
RUN;

DATA B_1;
	input num vara $;
	datalines;
	2 B1
	4 B2
	;
RUN;

data concat2;
   set A_1 B_1;
run;

proc print; run;

*consider running the proc append twice;
PROC APPEND	base = A_1
		    data = B_1;
RUN;

PROC PRINT data=A_1;
RUN;

/*   Example 4a: Appending – Different Lengths */
title;
DATA A_4;
length sex $1;
	input num sex $;
	datalines;
	1	M
	3	F
	5	M
	;
RUN;

/*
PROC PRINT data=A_4;
RUN;*/

DATA B_4;
length sex $6;
	input num sex $ State $;
	datalines;
	1 Female NY
	2 Female GA
	3 Female GA
	;
RUN;

/*
PROC PRINT data=B_4;
RUN;*/

PROC APPEND base = A_4
			data = B_4 ;
RUN;

PROC PRINT data=A_4;
RUN;

/* Example 4b: Must use FORCE Statement */
DATA A_4b;
length sex $1;
	input num sex $;
	datalines;
	1	M
	3	F
	5	M
	;
RUN;
/**/
/*PROC PRINT data=A_4b;*/
/*RUN;*/

DATA B_4b;
length sex $6;
	input num sex $ State $;
	datalines;
	1 Female NY
	2 Female GA
	3 Female GA
	;
RUN;
/*proc print data = b_4b;*/
/*run;*/

PROC APPEND base = A_4b
			data = B_4b force ;
RUN;

PROC PRINT data=A_4b;
RUN;

/* Example 4c: If number is character in one dataset and numeric in the other */
/*note there is no length specified in this dataset as well, so force, forces append to extend the sex length*/
data A_4c;
	input num $ sex $;
	datalines;
	1	M
	3	F
	5	M
	;
run;
proc print data=a_4c;
run;
/*proc contents data=a_4c;*/ /*Notice when creating data with cards the length defaults to 8 unlike in 4a and 4b*/
/*run;*/

data B_4c;
	input num sex $ State $; 
	datalines;
	1 Female NY
	2 Female GA
	3 Female GA
	;
run;
proc print data=b_4c;
run;

PROC APPEND base = A_4c
			data = B_4c force ;
RUN;

PROC PRINT data=A_4c;
RUN;

/* Example 5: Match Merging */
DATA A5;
	input num vara $;
	datalines;
	1	A1
	3	A2
	4	A3
	;
RUN;

DATA B5;
	input num varb $;
	datalines;
	2 B1
	4 B2
	;
RUN;

DATA mergeme;
	merge a5 b5;
	by num; /*no sort necessary as cards are ordered by num*/
RUN;
proc print data=mergeme; run;

/*example 5a without by statement*/
DATA mergeme5b;
	merge a5 b5;
RUN;
proc print data=mergeme5b; run; /*Q: difference with the data step SET a5; SET b5? */

/* Example 6: Match Merging with SORT */
/* This code overwrite the date that coverage started with the date of the visit */
DATA patients;
set class.patdat;
RUN;
proc print data=patients; run;

DATA visit;
set class.visit;
RUN;
proc print data=visit; run;

/*Patients dataset is organized by id, but let's just make sure*/
PROC SORT data = patients;
	by id;
RUN;

PROC SORT data = visit;
	by id;
RUN;

DATA merged;
	merge patients visit;
	by id;
RUN;

/*PROC PRINT data=patients;*/
/*RUN;*/
/**/
/*RUN;*/
/*PROC PRINT data=visit;*/
/*RUN;*/

*notice the date from the second dataset overwrites the first;
PROC PRINT data=merged;
RUN;

/* Example 7: Match Merging with SORT */
/* This code does NOT overwrite the date that coverage started with the date of the visit */
PROC SORT data = patients;
	by id;
RUN;

PROC SORT data = visit;
	by id;
RUN;

DATA merged2;
	merge patients (rename = (date = covdate)) 
	visit (rename = (date = visitdate));
	by id; 
	format covdate visitdate mmddyy10.;
RUN;

PROC PRINT data=merged2;
RUN;

/* Example 8: Match Merging with IN option */
DATA merged8;
	merge patients (in = a rename = (date = covdate)) 
	      visit (in = b rename = (date = visitdate));
	by id; 
	format covdate visitdate mmddyy10.;
RUN;

PROC PRINT data=merged8;
RUN;

*subsetting;
DATA merged8a;
	merge patients (in = a rename = (date = covdate)) 
	      visit (in = b rename = (date = visitdate));
	by id; 
	format covdate visitdate mmddyy10.;
	if a = 1 and b = 0;
RUN;

PROC PRINT data=merged8a;
RUN;

*can use subsetting IF statement slightly differently to get the same outcome and change to 2 digit year format;
DATA merged8c;
	merge patients (in = a rename = (date = covdate)) 
	      visit (in = b rename = (date = visitdate));
	by id; 
	format covdate visitdate mmddyy8.;
	if a and b;
RUN;

PROC PRINT data=merged8c;
RUN;

/* Example 9: Match-Merging with Drops and Keeps */
DATA merged9;
	merge patients (in = a rename = (date = covdate)) visit (in = b drop = weight rename = (date = visitdate) );
	by id; 
	format covdate visitdate mmddyy10.;
	if a and b;
RUN;

PROC PRINT data=merged9;
RUN;

/* Example 10: Match-Merging with Drops and Keeps after merge*/
DATA merged10;
	merge patients (in = a rename = (date = covdate)) visit (in = b  rename = (date = visitdate) );
	by id; 
	format covdate visitdate mmddyy10.;
	if a and b;	
	drop  weight;
RUN;

PROC PRINT data=merged10;
RUN;

/* Example 11: Match-Merging with Drops and Keeps */
DATA merged11 (drop=id);
	merge patients (in = a rename = (date = covdate)) 	visit (in = b  rename = (date = visitdate) );
	by id; 
	format covdate visitdate mmddyy10.;
	if a and b;	
	drop  weight;
RUN;

PROC PRINT data=merged11;
RUN;

*drop ID at a different place;
DATA merged11b;
	merge patients (in = a rename = (date = covdate)) 	visit (in = b  rename = (date = visitdate) );
	by id; 
	format covdate visitdate mmddyy10.;
	if a and b;	
	drop  weight id;
RUN;

PROC PRINT data=merged11b;
RUN;

/*Example 12: match-merging with 3 datasets*/
DATA admit;
set class.admit;
RUN;
proc print data=admit; run;

DATA insure;
set class.insure;
RUN;
proc print data=insure; run;

DATA stress;
set class.stress;
RUN;
proc print data=stress; run;

*sort all datasets by id;
PROC SORT data = admit;
	by id;
RUN;

PROC SORT data = insure;
	by id;
RUN;

PROC SORT data = stress;
	by id;
RUN;

*merge all 3 datesets;
data merged_3sets;
	merge admit insure stress;
	by id;
	run;
proc print data=merged_3sets; run;

/* IN CLASS WORK */

/* 1. Match viable donors from the 'Donors1' dataset to their current health data in the 'Diabetes' dataset */
/*    in the 'class' library.' Print a list of the donors with their matching health data. Do not include    */
/*    the variable 'units'. Make sure there is only one record per patient id (can do it during sorting)    */
/*    with the option nodupkey.                                                                             */

data class.Donors1
input ID Type $;
datalines;
2304 O
1129 A
2486 B
;
run;
proc sort data= Donors1
by ID;
run;
proc sort data= Diabetes
by ID;
run;
data merged;
merge Donors1 Diabetes;
by ID;
run;
data class.Diabetes
input Sex Age Height Weight Pulse Fastgluc Postgluc $;


/* 2. Merge the datasets class.set1 and class.set2. Make sure to keep all of the records from each dataset, */
/*    since we want to be able to identify individuals with missing information. How many records are in  */
/*    the final dataset? How many records are missing data? How many records are in set2 but not set1? */
proc sort data=class.set1;
by ID;
run;
proc sort data=class.set2;
by ID;
run;
data merged;
merge class.set1 (in=a) class.set2 (in=b)
by ID;
missing_set1= if(sex,age);
missing_set2= if (height,weight)

