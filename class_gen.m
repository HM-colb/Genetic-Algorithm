classdef class_gen
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1
    end
    
    methods(Static)
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
            
        end
        function [F,Fo]=f_val_final(electricity_cost,x,popsize)
            
            for i=1:popsize
                F(i,1)=sum(electricity_cost*x(i,:)');
                Fo(i,1)=sum(electricity_cost*x(i,:)');
                
            end
        end


    end
end