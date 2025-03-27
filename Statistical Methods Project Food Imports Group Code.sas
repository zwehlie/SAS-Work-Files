*Statistical Methods Project: Food Imports Group
Food Import of Tree and Ground Nuts;
libname class 'C:\Users\zwehl\OneDrive\Desktop\Stat Meth Project';

*Anova code;
proc import datafile="C:\Users\zwehl\OneDrive\Desktop\Stat Meth Project\FoodImports.xlsx" 
    out=import_data
    dbms=xlsx
    replace;
    sheet="Nuts"; 
run;

*Prepare the Data for Analysis;
data anova_data;
    set import_data;
    if not missing(E); 
    ImportValue_2023 = input(E, best12.);
run;

*Perform ANOVA;
proc anova data=anova_data;
    class C; 
    model ImportValue_2023 = C; 
    means C / tukey; 
run;
proc contents data=anova_data;
run;
proc datasets library=work;
run;

*Statistical Methods Project: Food Imports Group;
*T-Test with Simulated Data for Cashew Nuts and Ground Nuts;
libname class 'C:\Users\zwehl\OneDrive\Desktop\Stat Meth Project';
data simulated_data;
    /* Simulate 20 observations for Cashew Nuts */
    do i = 1 to 20;
        NutType = "Cashew Nuts";
        ImportValue = 722.7 + rannor(12345) * 50; /* Simulate with mean=722.7 and SD=50 */
        output;
    end;

    /* Simulate 20 observations for Ground Nuts */
    do i = 1 to 20;
        NutType = "Ground Nuts";
        ImportValue = 66.7 + rannor(12345) * 15; /* Simulate with mean=66.7 and SD=15 */
        output;
    end;
run;

* Perform the T-Test;
proc ttest data=simulated_data;
    class NutType; /* Grouping variable: Cashew Nuts vs Ground Nuts */
    var ImportValue; /* Test ImportValue between groups */
run;


*Statistical Methods Project: Food Imports Group;
*Linear Regression for Simulated Data from 1999-2023;

* Step 1: Expand Simulated Data to Include Years;
data regression_data;
    set simulated_data;
    length ImportYear 8;
    do year = 1999 to 2023;
        ImportYear = year; /* Assign years dynamically */
        output;
    end;
run;

* Step 2: Perform Linear Regression;
proc reg data=regression_data;
    by NutType; /* Separate analysis for Cashew Nuts and Ground Nuts */
    model ImportValue = ImportYear; /* Linear regression model */
    output out=reg_results p=Predicted r=Residual; /* Save predicted and residual values */
run;

* Step 3: Visualize Linear Regression Results;
ods graphics on;

proc sgplot data=reg_results;
    title "Linear Regression of Import Values Over Time (1999-2023)";
    scatter x=ImportYear y=ImportValue / group=NutType markerattrs=(symbol=circlefilled);
    series x=ImportYear y=Predicted / group=NutType lineattrs=(pattern=solid);
    xaxis label="Year";
    yaxis label="Import Value (Million Dollars)";
    keylegend / location=inside position=topright;
run;

* Residual Analysis;
proc sgplot data=reg_results;
    title "Residuals of Linear Regression (1999-2023)";
    scatter x=ImportYear y=Residual / group=NutType;
    refline 0 / axis=y lineattrs=(pattern=shortdash);
    xaxis label="Year";
    yaxis label="Residuals";
run;

ods graphics off;
