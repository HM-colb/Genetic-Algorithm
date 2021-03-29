 %----------- Crossover operator ---------------%
        function [c,d]=crossover(a,b)
         nn=length(a);
         %generating random crossover point%
         cpoint=floor(nn*rand);% cpoint is randomly selected num it generate an integer in the range of nn here nn = 11
         if cpoint==0 
            cpoint=randi(6,1,1); %it will generate random num and place it in 1st row and column in the range 11, floor give nearest integer as rand give values in decimanls
         end
         c=[a(1:cpoint) b(cpoint+1:end)];%cpoint is value represent 1st bits which are selected for crossover in both patterns
         d=[b(1:cpoint) a(cpoint+1:end)];
        %------------ Crossover ends ------------------%