
libname class 'C:\Users\zwehl\OneDrive - Kennesaw State University\SAS Work Files\Homework 4 Statistical Computing';

* a.	Import the files into three different data sets named Males, Females, 
and Additional that correspond with the names of the CSV file (For example the data set Females 
corresponds with the CSV file Student0405_Females.csv).  (10 pts).;
proc import datafile='C:\Users\zwehl\OneDrive - Kennesaw State University\SAS Work Files\Homework 4 Statistical Computing\Student0405_Females.csv'
out=class.Females
dbms=csv
replace;
getnames=yes;
run;
proc import datafile='C:\Users\zwehl\OneDrive - Kennesaw State University\SAS Work Files\Homework 4 Statistical Computing\Student0405_Males.csv'
out=class.Males
dbms=csv
replace;
getnames=yes;
run;
proc import datafile='C:\Users\zwehl\OneDrive - Kennesaw State University\SAS Work Files\Homework 4 Statistical Computing\Student0405_Additional.csv'
out=class.Additional
dbms=csv
replace;
getnames=yes;
run;
*b.	Concatenate (append) the Males and Females data 
into a new data set named Students (10 pts). ;
data class.Students;
set class.Males class.Females;
run;
proc sort data=class.Students; 
by ID; 
run;
*c.Merge the Additional information onto the Students data set using the
variable ID as the key. Only keep rows from the additional data set that
match the rows in the Students data set. (10 pts).;
/* Sort both datasets by ID */
proc sort data=class.Students out=class.Students_Sorted; 
by ID; 
run;
proc sort data=class.Additional out=class.Additional_Sorted; 
by ID; 
run;
data class.Final;
merge class.Students_Sorted (in=a) class.Additional_Sorted (in=b);
by ID;
if b; 
run;
*Create a new variable called AdjustedGPA that is the GPA reported in the 
file minus the average GPA for everyone (10 pts).; 
data class.Final;
set class.Final;
if not missing(GPA) then AdjustedGPA = GPA - &AvgGPA.;
run;
*e.	Create another variable called LetterGrade that reports an A if the GPA is 3.5 or higher, 
a B is the GPA is greater than or equal to 2.5 but less than 3.5, 
a C if the GPA is greater than or equal to 1.5 but less than 2.5, 
a D if it is greater than or equal 0.5 but less than 1.5, 
and an F if the GP is below 0.5 (10 pts).;
data class.Final;
set class.Final;
if not missing(GPA) then do;
if GPA >= 3.5 then LetterGrade = "A";
else if GPA >= 2.5 then LetterGrade = "B";
else if GPA >= 1.5 then LetterGrade = "C";
else if GPA >= 0.5 then LetterGrade = "D";
else LetterGrade = "F";
end;
else LetterGrade = " "; 
run;
*a.	Report the average and standard deviation of the variable AdjustedGPA. 
Round the results to two decimal places (10 pts). 
proc meansdata=class.Final mean stddev maxdec=2;
proc means data=class.Final mean stddev maxdec=2;
var AdjustedGPA;
run;
*b.	Calculate the percentage of students that responded to each level of the question ReligImp. What percentage of students 
feel religion is very important, fairly important, 
and not important (10 pts)? ;
/* Corrected counting logic */
/* Calculate counts and percentages for ReligImp */
data ReligPercentages;
set class.Final end=last;
retain Count_Very Count_Fairly Count_Not TotalCount;
if _N_ = 1 then do;
Count_Very = 0;
Count_Fairly = 0;
Count_Not = 0;
TotalCount = 0;
end;
if not missing(ReligImp) then do;
TotalCount + 1;
if strip(upcase(ReligImp)) = "VERY" then Count_Very + 1;
else if strip(upcase(ReligImp)) = "FAIRLY" then Count_Fairly + 1;
else if strip(upcase(ReligImp)) = "NOT" then Count_Not + 1;
end;
if last then do;
Percent_Very = (Count_Very / TotalCount) * 100;
Percent_Fairly = (Count_Fairly / TotalCount) * 100;
Percent_Not = (Count_Not / TotalCount) * 100;
output;
end;
keep Count_Very Percent_Very Count_Fairly Percent_Fairly Count_Not Percent_Not;
run;
proc print data=ReligPercentages noobs;
run;

*c.	Calculate the percentage of female students who sit in the front row and compare 
it with the percentage of male students who sit in the front row (10 pts);
/* Calculate percentages of males and females sitting in the front row */
data GenderSeatAnalysis;
set class.Final end=last;
retain MaleFront FemaFront MaleTotal FemaTotal;
if Sex = "Male" then do;
MaleTotal + 1;
if Seat = "Front" then MaleFront + 1;
end;
else if Sex = "Fema" then do;
FemaTotal + 1;
if Seat = "Front" then FemaFront + 1;
end;
if last then do;
PercentMaleFront = (MaleFront / MaleTotal) * 100;
PercentFemaFront = (FemaFront / FemaTotal) * 100;
output;
end;
keep PercentMaleFront PercentFemaFront;
run;
proc print data=GenderSeatAnalysis noobs;
run;
*d.	Calculate the percentage 
of students that miss 0 classes, 1 to 3 classes, or more than 3 classes. (10 pts);
data MissClassAnalysis;
set class.Final end=last;
retain Miss0 Miss1to3 MissMore3 TotalCount;
if _N_ = 1 then do;
Miss0 = 0;
Miss1to3 = 0;
MissMore3 = 0;
TotalCount = 0;
end;
TotalCount + 1;
if MissClass = 0 then Miss0 + 1;
else if 1 <= MissClass <= 3 then Miss1to3 + 1;
else if MissClass > 3 then MissMore3 + 1;
if last then do;
PercentMiss0 = (Miss0 / TotalCount) * 100;
PercentMiss1to3 = (Miss1to3 / TotalCount) * 100;
PercentMissMore3 = (MissMore3 / TotalCount) * 100;
output;
end;
keep PercentMiss0 PercentMiss1to3 PercentMissMore3;
run;
proc print data=MissClassAnalysis noobs;
run;
*e.	Examine the classes missed as defined in part d for each of the seat locations. (10 pts).;
data SeatMissAnalysis;
    set class.Final end=last;
    retain FrontMiss0 FrontMiss1to3 FrontMissMore3 FrontTotal 
           MiddleMiss0 MiddleMiss1to3 MiddleMissMore3 MiddleTotal
           BackMiss0 BackMiss1to3 BackMissMore3 BackTotal;
 if _N_ = 1 then do;
        FrontMiss0 = 0; FrontMiss1to3 = 0; FrontMissMore3 = 0; FrontTotal = 0;
        MiddleMiss0 = 0; MiddleMiss1to3 = 0; MiddleMissMore3 = 0; MiddleTotal = 0;
        BackMiss0 = 0; BackMiss1to3 = 0; BackMissMore3 = 0; BackTotal = 0;
    end;
 if Seat = "Front" then do;
        FrontTotal + 1;
        if MissClass = 0 then FrontMiss0 + 1;
        else if 1 <= MissClass <= 3 then FrontMiss1to3 + 1;
        else if MissClass > 3 then FrontMissMore3 + 1;
    end;
    else if Seat = "Middle" then do;
        MiddleTotal + 1;
        if MissClass = 0 then MiddleMiss0 + 1;
        else if 1 <= MissClass <= 3 then MiddleMiss1to3 + 1;
        else if MissClass > 3 then MiddleMissMore3 + 1;
    end;
    else if Seat = "Back" then do;
        BackTotal + 1;
        if MissClass = 0 then BackMiss0 + 1;
        else if 1 <= MissClass <= 3 then BackMiss1to3 + 1;
        else if MissClass > 3 then BackMissMore3 + 1;
    end;
if last then do;
        PercentFrontMiss0 = (FrontMiss0 / FrontTotal) * 100;
        PercentFrontMiss1to3 = (FrontMiss1to3 / FrontTotal) * 100;
        PercentFrontMissMore3 = (FrontMissMore3 / FrontTotal) * 100;

        PercentMiddleMiss0 = (MiddleMiss0 / MiddleTotal) * 100;
        PercentMiddleMiss1to3 = (MiddleMiss1to3 / MiddleTotal) * 100;
        PercentMiddleMissMore3 = (MiddleMissMore3 / MiddleTotal) * 100;

        PercentBackMiss0 = (BackMiss0 / BackTotal) * 100;
        PercentBackMiss1to3 = (BackMiss1to3 / BackTotal) * 100;
        PercentBackMissMore3 = (BackMissMore3 / BackTotal) * 100;
output;
end;
keep PercentFrontMiss0 PercentFrontMiss1to3 PercentFrontMissMore3
         PercentMiddleMiss0 PercentMiddleMiss1to3 PercentMiddleMissMore3
         PercentBackMiss0 PercentBackMiss1to3 PercentBackMissMore3;
run;
proc print data=SeatMissAnalysis noobs;
run;
*f.	Calculate the Average GPA for the three seat locations (5 pts).  ;
data SeatGPAAnalysis;
set class.Final end=last;
retain FrontGPA MiddleGPA BackGPA FrontCount MiddleCount BackCount;
if _N_ = 1 then do;
 FrontGPA = 0; MiddleGPA = 0; BackGPA = 0;
 FrontCount = 0; MiddleCount = 0; BackCount = 0;
end;
if Seat = "Front" then do;
FrontGPA + GPA;
FrontCount + 1;
end;
else if Seat = "Middle" then do;
MiddleGPA + GPA;
MiddleCount + 1;
end;
else if Seat = "Back" then do;
BackGPA + GPA;
BackCount + 1;
end;
if last then do;
if FrontCount > 0 then AvgFrontGPA = FrontGPA / FrontCount;
else AvgFrontGPA = .;
if MiddleCount > 0 then AvgMiddleGPA = MiddleGPA / MiddleCount;
else AvgMiddleGPA = .;
if BackCount > 0 then AvgBackGPA = BackGPA / BackCount;
else AvgBackGPA = .;
output;
end;
keep AvgFrontGPA AvgMiddleGPA AvgBackGPA;
run;
proc print data=SeatGPAAnalysis noobs;
run;

