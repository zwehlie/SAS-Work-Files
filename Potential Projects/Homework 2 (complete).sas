libname class 'C:\Users\zwehl\OneDrive - Kennesaw State University\SAS Work Files';
data class.soldbooks_with_profit;
set class.soldbooks;
profit=saleprice-cost;
run;
*Print the first 10 observations of the dataset. Include the title “Book Shop”, remove the
observation numbers from the report, and label Cost as Cost of Book.;
proc print data=class.soldbooks_with_profit (obs=10) 
noobs label;
title "Book Shop";
label cost= 'Cost of Book';
run;
*Remove the title. Print observations 11 to 20. Sum the cost variable in the report. 
Then, break this total sum up by store (online or in store);
proc sort data=class.soldbooks_with_profit;
by store;
run;
proc print data= class.soldbooks_with_profit(firstobs=11 obs=20)
noobs label;
label cost= 'Cost of Book';
var section booktitle author cost store;
sum cost;
by store;
run;
*6.	Create an accumulator variable that determines the total amount the store spent on the inventory;
data class.soldbooks_with_inventory;
set class.soldbooks;
retain total_inventory_cost 0;
total_inventory_cost + cost;
run;
*7.	Create another accumulator variable that determines the total amount made by the store in profit;
data class.soldbooks_with_total_profit;
set class.soldbooks;
retain total_profit 0;
profit=saleprice-cost;
total_profit+profit;
run;
*8.The variable store is not standardized. 
Create a new variable called storetype that contains a 1 if the 
item was sold in the store and 0 if it was not;
data class.soldbooks_with_storetype;
set class.soldbooks;
if store='Yes' then storetype=1;
else storetype=0;
run;
*9.	Create another dataset that contains information on all of the internet orders. 
Do this in one step and calculate the total amount paid for each book as the saleprice plus mail. 
Also accumulate the amount made from the internet orders (profit);
/* Create dataset for internet orders with total amount paid and accumulated profit */
data class.internet_orders_summary;
set class.soldbooks_with_storetype;
if storetype = 0 then do;
total_amount_paid = saleprice + mail;
profit = saleprice - cost;
retain total_internet_profit 0;
total_internet_profit + profit;
output;
end;
run;
*11.Create a new dataset with total cost and 
total profit by different selling channel (in store or online;
data class.soldbooks_with_profit;
set class.soldbooks_with_storetype;
 profit = saleprice - cost; 
run;
proc summary data=class.soldbooks_with_profit nway;
class storetype;
var cost profit;
output out=class.sales_summary_by_channel
sum(cost)=total_cost
sum(profit)=total_profit;
run;
*13.Examine the total amount of profit per day. Are there specific days that make more money;
proc sql;
create table class.profit_per_day as
select date,sum(profit) as total_profit
from class.soldbooks_with_profit
group by date
order by total_profit desc;
quit;


