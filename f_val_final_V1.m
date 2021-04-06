function [F,Fo]=f_val_final(Price_Pwer,x,popsize)   %electricity_cost

for i=1:popsize
F(i,1)=sum(Price_Pwer*x(i,:)'); %electricity_cost
Fo(i,1)=sum(Price_Pwer*x(i,:)'); %electricity_cost

end