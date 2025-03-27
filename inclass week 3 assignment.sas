*Question 1:Download the Iris SAS data set from D2L into a folder you have access to;
libname STAT 'C:\Users\sni\OneDrive - Kennesaw State University\Fall24_STAT';
libname inclass C:\Users\zwehl\OneDrive - Kennesaw State University\SAS Work Files

*Question 2:Use Code to assign a SAS library called Class to
the above folder where you have the Iris SAS
data set;
libname Class C:\Users\zwehl\OneDrive - Kennesaw State University\SAS Work Files;

*Question 3:Create another permanent copy of the dataset Iris in the class library name
this new data set Iris2;
data Class.iris2;
   set Class.iris;
   run;

   *Question 4:Use a data step to create a temporary copy of
the Iris dataset;
   proc contents data = Class.iris;
run;
   *Question 5:Print the iris data set in the inclass library;
proc print data=Class.iris;
run;

*Question 6:Print the first 5 observations in the cars data set;
proc print data=Class.iris (obs=5);
run;

*Question 7:Print observations from 20 to 30 in the cars data set;
proc print data=CLass.iris (firstobs=20 obs=30);
run;
