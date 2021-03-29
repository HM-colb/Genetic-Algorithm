% ---------generation of initial population-----------------%
function [pop]=init_gen_1(popsize,tbits)
for j=1:popsize   % generating position matrix
        for i=1:tbits % total appliacnes
            if rand(1)>=0.1
                X=1;
            else
                X=0;
            end
            pop(j,i)=X;    
        end
         c=zeros(1,8);
    if pop(j,:)==c
     pop(j,:)=ones(1,8);
    end
        
end
%------Initial Population generated-----------%