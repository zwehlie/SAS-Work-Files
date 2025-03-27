libname class 'C:\Users\zwehl\OneDrive - Kennesaw State University\SAS Work Files';
*1. Create dataset that stores your birthday;
data class.my_birthday;
my_name="Zachary W";
birth_date='22Feb1999'd;
format birth_date date9.;
run;
proc print data=class.my_birthday;
run;
*2.Calculates how many days old you are;
data age_days;
age_days= today()-'22Feb1999'd;
run;
proc print data=age_days;
run;

*3.Calculates how many weeks old you are;
data age_weeks;
age_weeks=(today()-'22Feb1999'd)/7;
run;
proc print data=age_weeks;
run;
*4. Calculates how many months old you are;
data age_months;
birth_date='22Feb1999'd;
format birth_date date9.;
age_months=(today()-birth_date)/30.44;
run;
proc print data=age_months;
run;

*5. Calculates how many years old you are;
data age_years;
birth_date='22Feb1999'd;
format birth_date date9.;
age_years= (today()-birth_date)/365;
run;
proc print data=age_years;
run;

*6. And prints how many days, weeks, months, and
years old you are to the log;
data age_all;
birth_date='22Feb1999'd;
format birth_date date9.;
age_days= today()-'22Feb1999'd;
age_weeks=(today()-'22Feb1999'd)/7;
age_months=(today()-birth_date)/30.44;
age_years= (today()-birth_date)/365;
run;
proc print data=age_all noobs;
run;

 

