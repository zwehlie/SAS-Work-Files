/* Sample1 FINAL PROJECT SYNTAX */

/* 1. IMPORT DATA */
libname csfinal "C:\Users\hello\Downloads\Stat Comp SP24\FINAL PROJECT";

PROC IMPORT OUT= csfinal.og_movie 
     DATAFILE= "C:\Users\hello\Downloads\Stat Comp SP24\FINAL PROJECT\Movie Data\movies.csv" 
     DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;

proc print data=csfinal.og_movie (firstobs=1 obs=10);
run;

ods pdf file='sample1_Report.pdf';
/* 2. DATA EXPLORATION */
title 'Data Exploration: Dataset Summary';
proc contents data=csfinal.og_movie;
run;
title;

title 'Data Exploration: Categorical Variables for Analysis';
proc freq data=csfinal.og_movie;
	tables country genre rating;
run;
title;


data og_movie;
	set csfinal.og_movie;
	label released = 'Date and Country Relesaed';
run;
/* DATA CLEANING */
/* 10. Functions */
/* fixing date released variable to remove the country*/
data og_movie;
    set og_movie;
    date_str = scan(released, 1, ','); /*function 1 -using scan to separate month and day*/
    date_str = trim(date_str); /*function 2- using trim to remove trailing space*/
run;

/* need to add year back in since it was also separated by a space */
data og_movie;
	set og_movie;
	release_date = catx (',' , date_str, year); /*function 3-using catx to add year after month and day using ',' as a delimiter*/
run;

data og_movie;
	set og_movie;
	label release_date='Date Released';
run;

title 'Release Date Variable Before and After Reformatting';
proc print data=og_movie (firstobs=1 obs=10);
	var released release_date;
run;
title;
/*removing movie rating Ap and X since they have less than 10 obs*/
data og_movie;
	set og_movie;
	if rating = 'Ap' then delete;
	else if rating = 'X' then delete;
/*combining Un and No in ratings*/
	if rating = 'No' then rating = 'Un';
/*removing movie genres History, Music, Musical, Sport, and Western since they have less than 10 obs*/
	if genre in ('History', 'Music', 'Musical', 'Sport', 'Western') then delete;
run;

/* 7. CREATE A NEW VARIABLE */
/* creating new variable "streaming_cat", 
	yes = the movie was released after netflix began movie stremaming, 
	no = the movie came out before*/
data og_movie;
	set og_movie;
	length streaming_cat $4;
	if year ge 2007 then streaming_cat = '1';
	else if year lt 2007 then streaming_cat = '0';
run;

/*proc freq data=og_movie;
	table streaming_cat;
run;*/ 

title 'Variable Creation';
proc print data=og_movie (firstobs=5024 obs=5044) label;
	var release_date streaming_cat;
	id name;
	label streaming_cat='Released After Movie Streaming' name='Title';
run;
title;

/* 6. SUBSETTING */
data movie;
	set og_movie;
	where country in ('Canada', 'France', 'Germany', 'United Kingdom', 'United States');
	keep budget country gross genre rating score runtime streaming_cat name release_date;
run;

title 'Subset of Original Dataset';
proc print data=movie (firstobs=1 obs=20);
id name;
run;
title;

/* 3. LABELS */
data movie;
	set movie;
	label budget = 'Production Budget' country='Country of Origin' 
			gross='Gross Revenue'  genre='Movie Genre' rating='Movie Rating' score='IMDb User Rating'
			runtime='Duration of Movie' streaming_cat='Released After Movie Streaming' name='Title' release_date='Date Released';
run;


/* 4. FORMATS */
proc format;
	value $ streaming
	0 = "No"
	1 = "Yes";

	value $ rate
	G = 'General Admission (all ages)'
	NC = 'Not for Children (16+)'
	PG = 'Parental Guidance'
	R = 'Restricted (18+)'
	TV = 'Suitable for Television'
	Un = 'Unrated';
run;

/* 5. PRINTING */
title 'Printing Dataset with Title as the ID';
proc print data=movie (obs=10) label;
	var release_date budget country gross genre rating score runtime streaming_cat;
	id name;
run;
title;

/* 8. CATEGORICAL ANALYSIS */
/*proc freq data=movie;
	table streaming_cat;
	format streaming_cat $streaming.;
run;*/

/* categorical variables: rating, genre, streaming, country */
title 'Frequency Table of Movie Ratings and Before and After Online Streaming';
footnote 'Data Source: Kaggle';
proc freq data=movie;
	tables streaming_cat*rating/ nocol;
	format rating  $rate. streaming_cat $streaming.;
run;
title;
footnote;
	
title 'Frequency Table of Country of Production and Movie Genre';
footnote 'Data Source: Kaggle';
proc freq data=movie;
	tables country* genre;
run;
title;
footnote;

title 'Frequency Table of Movie Genres and Before and After Online Streaming';
footnote 'Data Source: Kaggle';
proc freq data=movie;
	tables streaming_cat*genre /nocol;
	format streaming_cat $streaming.;
run;
title;
footnote;

/* 9. QUANTITATIVE ANALYSIS */
data movie;
	set movie;
	format gross budget dollar12.2;
run;

title 'Quantitative Summaries of Movies Before and After Online Movie Streaming';
footnote 'Data Source: Kaggle';
proc means data=movie n mean median stddev var min max maxdec=2;
	var budget gross runtime score;
	class streaming_cat;
	format streaming_cat $streaming. gross dollar12.2 budget dollar12.2;
run;
title;
footnote; 

ods pdf close;




