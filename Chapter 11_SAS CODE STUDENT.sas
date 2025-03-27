/***    CHAPTER 11 PART 1: DO Loops   ***/

libname class "E:\Users\sni\OneDrive - Kennesaw State University\Fall24_STAT\10_30";

/*   Example 1: Simple DO Loop Execution   */
proc print data=class.tests; 
run;

DATA stresstest;
	set class.tests;

	TotalTime=(timemin*60)+timesec;
	retain SumSec 5400;
	sumsec+totaltime;
	length TestLength $6 Message $20;

	if totaltime>800 then

	  do;
		TestLength='Long';
		message='Run blood panel';
	  end;

	else if 750<=totaltime<=800 then TestLength='Normal';
	else if totaltime<750 then TestLength='Short';
RUN;

PROC PRINT data=stresstest;
RUN;

/*   Example 2: Simple DO Loop cs. No DO Loop   */

/*  No DO Loop  */
proc print data=class.master; 
run;


DATA earn;
	set class.master;
	Earned=0;
	earned+(amount+earned)*(rate/12);
	earned+(amount+earned)*(rate/12);
	earned+(amount+earned)*(rate/12);
	earned+(amount+earned)*(rate/12);
	earned+(amount+earned)*(rate/12);
	earned+(amount+earned)*(rate/12);
	earned+(amount+earned)*(rate/12);
	earned+(amount+earned)*(rate/12);
    earned+(amount+earned)*(rate/12);
    earned+(amount+earned)*(rate/12);
    earned+(amount+earned)*(rate/12);
    earned+(amount+earned)*(rate/12);
RUN;
proc print; run;

/*  Versus a DO Loop  */

DATA earnings (drop=month);
	set class.master;
	Earned=0;

	do month=1 to 12;
		earned+(amount+earned)*(rate/12);
	end;

	Balance=Amount+Earned;
RUN;

PROC PRINT data=earnings;
RUN;

/*   Example 3: DO Loop Execution   */
DATA earnings2;
	* set earnings;
	Amount = 1000;
	Rate = 0.075/12;

	do month = 1 to 12;
		Earned + (amount+earned)*rate;
	end;

RUN;

/*   Example 4: Counting Iterations of Do Loops   */
DATA earn (/*drop = counter*/);
	
value = 2000;

	do counter = 1 to 20;
		Interest = value * 0.075;
		value + interest;
		year+1;
	end;

RUN;

/*   Example 5: Output Statement */
DATA earn;
value=2000;
	do year=1 to 20;
	   interest=value*.075;
       value+interest;
	output;
	end;
RUN;

PROC PRINT data=work.earn;
RUN;

/*  vs single output  */
DATA earnsingle;
value=2000;
	do year=1 to 20;
	   interest=value*.075;
       value+interest;
	end;
RUN;

PROC PRINT data=work.earnsingle;
RUN;

/*******************************  IN CLASS WORK  *******************************/

/* #1  */
/* On January 1st of each year, $5000 is deposited into an account. */
/* Create a data step to calculate the value of the account after 15*/
/* years assuming a constant rate of interest of 10%.               */



/* #2 */
/* Modify the data step created in step 1 so it outputs each individual year. */



/* #3 */
/* Add a variable called year, that increments by 1 starting with 2011.	*/



/* #4 */
/* Drop the iterator. */



/* #5 */
/* Modify the code so it performs the calculations for 20 years. */


/***************************** END IN-CLASS WORK *********************************/

/*   Example 6: Nested DO Loops */

/*  Non-nested  */
DATA earn;
	Capital = 2000;

	do month = 1 to 12;
		Interest = capital*(0.075/12);
		capital + interest;
		output;
	end;

RUN;

/*  vs. single output */
DATA earn5;
	Capital = 2000;

	do month = 1 to 12;
		Interest = capital*(0.075/12);
		capital + interest;
	end;

RUN;

/*  Nested  */
DATA earn;
	
  do year = 1 to 20;
  	capital + 2000;

		do month = 1 to 12;
			Interest = capital*(0.075/12);
			capital + interest;
			output;
		end;

  end;

RUN;

/*   Example 7: DO Loops on Data */
DATA cdrates;
	infile datalines dlm = ",";
	length institution $17.;
	input Institution $ rate year; 
	datalines; 
	MBNA America, 0.0817, 5
	Metropolitan Bank, 0.0814, 3
	Standard Pacific, 0.0806, 4
;
RUN;

DATA compare (drop = i);
	set cdrates;
	investment = 5000;

	do i = 1 to year;
		investment + rate*investment;
	end;

RUN;

/*   Example 8: DO Until */
DATA invest;
	do until(capital>=50000);
		capital + 2000;
		capital+capital*0.10;
		year + 1;
	end;
RUN;

/*   Example 9: DO While */
/* Does not work bc capital is not >= 50,000 */
DATA invest;
	
	do while(capital>=50000);
		capital + 2000;
		capital+capital*0.10;
		year + 1;
	end;
RUN;

/*   Example 10: DO While */
/* Same result as DO Until statement  */
DATA invest;
	do while(capital<50000);
		capital + 2000;
		capital+capital*0.10;
		year + 1;
	end;
RUN;

/*   Example 11: Conditional Clause with Iterative Do Loops  */
DATA invest (drop = i);
	do i = 1 to 10 until(capital >= 50000);
		capital + 2000;
		capital+capital*0.10;
		year + 1;
	end;
RUN;


/*  EXAMPLE 12: Conditional Clauses with Iterative Do Loops  */
DATA invest (drop = i);
	do i = 1 to 10 until(capital >= 50000);
		capital + 4000;
		capital+capital*0.10;
		year + 1;
	end;
RUN;






