
%----- Mutatation operator ------%
function  anew=mutate(a,insite) %insite=2%
    nn=length(a); 
    for i=1:insite %insite means how many bits you change if insite 1 means single crossover if 2 two bits change for loop run two times means double mutate 
    j=floor(rand*nn);
        if j==0 
            j=randi(nn,1,1);
        end
    k=a(j); %means which bit change in this pattern k is selected that bit in pattern will change
    if k==1
        a(j)=0;
    else
       if k==0
        a(j)=1;
       end
    end
    anew=a;
   end
%-------****************-------%