DATA X;
input x;
    cards;
    1
    3
    5
    7 
    9 
    ;
RUN;

data means;
set X end=lastobs;
cumulative_sum+x;
avg = cumulative_sum/_N_;
if lastobs then output;
run;