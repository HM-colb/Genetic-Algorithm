classdef class_gen
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1
    end
    
    methods(Static)
    function [F,Fo]=f_val_final(electricity_cost,x,popsize)
            
            for i=1:popsize
                F(i,1)=sum(electricity_cost*x(i,:)');
                Fo(i,1)=sum(electricity_cost*x(i,:)');
                
            end
        end


    end
end