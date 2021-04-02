close all;
clear all;
clc;
Appliance_data;
Unscheduled_states;
% Initialization of paramters
Acc_Cost=0;
Acc_Load_hour=0;
T_Sch_Load_GA=0;
T_Sch_Cost_GA=0;
T_Sch_Load_HSA=0;
T_Sch_Cost_HSA=0;
T_Schedule_Cost=0;

% Appliances details, including power ratings, operation states, and

%---------------- operation states-------------%
Fixed_OS_app= [Ceilling_fan('Operation states')' Lamp('Operation states')' TV('Operation states')'... 
    Oven('Operation states')'];
Nonintrrpt_OS_app=[Washing_machine('Operation states')' Iron('Operation states')'];

Flexible_OS_app=[Air_condition('Operation states')' Water_heater('Operation states')'];

Appliances=[Fixed_OS_app Nonintrrpt_OS_app Flexible_OS_app];
Fetch_states= @(mtx, m, n) mtx(m,n);
C_Fan_St=Fetch_states(Ceilling_fan('Operation states'),1,':');
Lamp_St=Fetch_states( Lamp('Operation states'),1,':');
TV_St=Fetch_states(TV('Operation states'),1,':');
Oven_St=Fetch_states(Oven('Operation states'),1,':');
W_Machine_St=Fetch_states(Washing_machine('Operation states'),1,':');
Iron_St=Fetch_states(Iron('Operation states'),1,':');
Air_cond_St=Fetch_states(Air_condition('Operation states'),1,':');
Water_h_St=Fetch_states(Water_heater('Operation states'),1,':');


%----------- Power ratings(PR)--------------------%
Fixed_PR_app= [Ceilling_fan('Power') Lamp('Power') TV('Power')... 
    Oven('Power')];
Nonintrrpt_PR_app= [Washing_machine('Power') Iron('Power')];
Flex_PR_app=[Air_condition('Power') Water_heater('Power')];

PR=[Fixed_PR_app Nonintrrpt_PR_app Flex_PR_app];

%----------- Operational time interval---------------%
Fixed_TS_app= [Ceilling_fan('Time span') Lamp('Time span') TV('Time span')... 
    Oven('Time span')];

Nonintrrpt_TS_app=[Washing_machine('Time span') Iron('Time span')];

Flex_TS_app=[Air_condition('Time span') Water_heater('Time span')];

Time_OP=[Fixed_TS_app Nonintrrpt_TS_app Flex_TS_app];


%--------------Electricity Price Signal------------------------%

%Time of user pricing tariff for detials here:Lütkebohle,   “Smart   Meter   Upgrade   The   Customer-Led   Transi-tion  to  Time-of-Use,”  
%https://www.cru.ie/wp-content/uploads/2018/05/CRU19019-Customer-Led-Transition-to-Time-of-Use.pdf/, 2019
%Pricing data for the example mdoel is taken
Off_peak_price=[10.1 10.1 10.1 14.1 10.1 10.1 10.1];
ON_peak_price=[20.8 40.8 20.8 20.8];
Mid_peak_price=[14.4 14.4 14.4 14.4 14.4 14.4 14.4];
Pricing_Signal=[Off_peak_price ON_peak_price Mid_peak_price ON_peak_price(1:2) Off_peak_price(1:4)];
Total_hr=length(Pricing_Signal);
% Using the appliances power consumption, states, time space calculate the

% -------------Unschduled Scenario Case 1--------------------------

for hr=1:Total_hr
    
Price_Pwer=[Pricing_Signal(hr)*PR(1) Pricing_Signal(hr)*PR(2)... 
    Pricing_Signal(hr)*PR(3) Pricing_Signal(hr)*PR(4) Pricing_Signal(hr)*PR(5)...
    Pricing_Signal(hr)*PR(6) Pricing_Signal(hr)*PR(7) Pricing_Signal(hr)*PR(8)];
    S_Pwer=-[PR(1) PR(2) PR(3) PR(4) PR(5) PR(6) PR(7) PR(8)]; 
    d=-2500;
    Load_hour(hr)= Appliances(hr,:)*PR'; %Load usage in each hour
    PAr(hr)= Load_hour(hr);
    Load_peak= max(Load_hour);            %Max Load used in an hour      
    Load_mean= mean(Load_hour);           %Mean Load value 
    Cost(hr)=Appliances(hr,:)*Price_Pwer';%Cost of the Load in each hour
end

    Acc_Load=sum(Load_hour);              %Load usage in 24 hours
    Acc_Cost=sum(Cost);                   %Cost for 24 hours   
    PAR_Unsc=(Load_peak)^2./(Load_mean)^2;%Peak to average ration of the Total Load
    D_Pricing_Signal=round(mean(Pricing_Signal));		
    %Normalized Load
    Load_(1:length(Load_hour))=(Load_hour(1:length(Load_hour))-min(Load_hour))/(max(Load_hour)-min(Load_hour));
    N_load=sum(Load_);
    %Normalized Cost
    cost_(1:length(Load_hour))=(Cost(1:length(Cost))-min(Cost))/(max(Cost)-min(Cost));
    N_cost=sum(cost_);
disp('-------------------------------------------------------------');

%-------------- The GA Parameters------------------

popsize=3000; %Population Size
maxgen=100;  %Iterations for stochastic operators 
a=0;
tbits=8;
insite=2;   % Bitflipping rate
pc=0.9;     % Probability of crossover
pm=1-pc;    % Probability of mutation
count=0;
ss=zeros();
ind=popsize;
%gbest=inf;
%gbest_G=inf;
%best_G=inf;
pop=class_gen.init_gen_1(popsize,tbits);
popnew=pop;                    % Generated pop renamed as popnew
for hours=1:Total_hr
    Price_Pwer=[Pricing_Signal(hr)*PR(1) Pricing_Signal(hr)*PR(2)... 
    Pricing_Signal(hr)*PR(3) Pricing_Signal(hr)*PR(4) Pricing_Signal(hr)*PR(5)...
    Pricing_Signal(hr)*PR(6) Pricing_Signal(hr)*PR(7) Pricing_Signal(hr)*PR(8)];
lgen=25-hours;
%Line 97 to 111 checking the avaialble timeslots
for a=1:popsize                
    for b=1:tbits
        if Time_OP(1,b)==0
            popnew(a,b)=0;
        end
        if lgen<=Time_OP(1,b)
            popnew(a,b)=1;
        end
    end
    z=zeros(1,8);
    o=ones(1,8);
    if popnew(a,:)==z
        popnew(a,:)=o;
    end
end
%----- Line 112 to 141 setting up the operaton timeslots for ----------%
%----- "Nonintrruptable Load", Washing machine and Iron

for a=1:popsize
    for b=1:tbits
        if Time_OP(1,b)<=0
            popnew(a,b)=0;
        elseif (lgen<=Time_OP(1,b)&& Time_OP(1,b)>0)
            popnew(a,b)=1;
        end
    end
end


F=class_gen.f_val_final(Price_Pwer,popnew,popsize);
%F=f_val_final_V1(Price_Pwer,popnew,popsize);
T_C=(Price_Pwer*popnew');		
E_Cost=(Price_Pwer*popnew');				
T_Load=PR*popnew';		
gbest=inf;		
Lbest=inf;		
D11=inf;
if D11==inf
    for i = 1:popnew
        if (F(i,1)<D11) && T_Load(1,i)>min(Load_hour)
            D11 = F(i,1);
            Lbest = popnew(i,:); % gbest position achieved here.    ?
            Fbest=D11;
            best_G(1,:) = Lbest;
            ds= E_Cost(1,i);
        end
    end
end

if D11==inf
for i = 1:popnew
    if (F(i,1)<=D11)%+2*(min(Load_hour)))&&(T_Load(1,i)< mean(Load_hour)-min(Load_hour));
        D11 = F(i,1);
        best_G(1,:) = popnew(i,:); % best individual achieved here
    end
end
end

%gbest_G=Lbest(1,:);
%popnew(ij,:)=0;
gbest_G(hours,:)=best_G;
app_Sch_GA(hours,:)=best_G;
%appliance Scheme
Ceilling_fan_G(:,hours)=app_Sch_GA(hours,1);
Lamp_G(:,hours)=app_Sch_GA(hours,2);
TV_G(:,hours)=app_Sch_GA(hours,3);
Oven_G(:,hours)=app_Sch_GA(hours,4);
WM_G(:,hours)=app_Sch_GA(hours,5);
Iron_G(:,hours)=app_Sch_GA(hours,6);
AC_G(:,hours)=app_Sch_GA(hours,7);
WH_G(:,hours)=app_Sch_GA(hours,8);
%% Checking time span is completed or not
for f=1:tbits
    if best_G(1,f)==1
        Time_OP(1,f)=Time_OP(1,f)-1;
    end
    if Time_OP(1,f)<=0
        Time_OP(1,f)=0;
    end
end
ds=0;
%-------------- check in the entire search space -------------------------%

%         Cw(5,24)=zeros(1);
%         D(5,24)=zeros(1);

T_Sch_Load_GA (hours)=PR*best_G';
parG(hours)=T_Sch_Load_GA (hours);
parG2=max(T_Sch_Load_GA );
sum_scheduledload=sum(T_Sch_Load_GA );
T_Sch_Cost_GA (hours)=Price_Pwer*best_G';
PAR_scheduled_G2=(max(T_Sch_Load_GA )^2/(sum_scheduledload/24)^2); %%%% PAR after scheduling
T_Schedule_Cost=T_Schedule_Cost+T_Sch_Cost_GA (hours);
sch_cost=T_Schedule_Cost;
%----------------Genereate new population---------------------------------%

for j=1:maxgen
    %------- Select Crossover pair -------------%
    ii=floor(ind*rand); %floor(A)round off to the nearest integer less than or equal to A
    jj=floor(ind*rand); 
    if ii==0            
        ii=randi(ind,1,1);
    end 
    if jj==0 
        jj=randi(ind,1,1);
    end 
    %------- Crossover selection -----------%
    
    %------ Crossover -----------%
    if pc>rand
        [popnew(ii,:),popnew(jj,:)]= crossover(pop(ii,:),pop(jj,:));
        count=count+2;  
    end
    %-------- Crossover done -----%
    %-------------------------Do Mutation at n sites ------------%
    if pm>rand
        kk=floor(ind*rand);%rand return decimal i.e floating point value.
        kk=randi(ind,1,1);
        if kk==0
        kk=randi(ind,1,1);% randi return integer value.ind,1,1.
        end
        count=count+1; 
        popnew(kk,:)=mutate(popnew(kk,:),insite);
    end
    %------------------------- Mutation done ----------------------%
    
    %-------------------------- New population generated ---------------------%
    %-------------------------------------------------------------------------%
    popnew;
end  
for a=1:popsize
    for b=1:tbits
        if Time_OP(1,b)==0
            popnew(a,b)=0;
        end
        if lgen<=Time_OP(1,b)
            popnew(a,b)=1;
        end
    end
    z=zeros(1,8);
    o=ones(1,8);
    if popnew(a,:)==z
        popnew(a,:)=o;
    end
end


end
