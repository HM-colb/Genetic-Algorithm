# Heuristic-algorithm
% Basic Genetic Algorithm
%
%    gaDat=ga(gaDat)
%    gaDat : Data structure used by the algorithm.
%    
% Data structure:
% Parameters that have to be defined by user
% gaDat.FieldD=[lb; ub]; % lower (lb) and upper (up) bounds of the search space. 
%                        % each dimension of the search space requires bounds 
% gaDat.Objfun='costFunction'; % Name of the 0bjective function to be minimize
% 
% Parameters that could be defined by user, in other case, there is a default value
% gaDat.MAXGEN={gaDat.NVAR*20+10}; % Number of generation, gaDat.NVAR*20+10 by default
% gaDat.NIND={gaDat.NVAR*50} ;   % Size of the population, gaDat.NVAR*50 by default
% gaDat.alfa={0};                % Parameter for linear crossover, 0 by default
% gaDat.Pc={0.9};                % Crossover probability, 0.9 by default
% gaDat.Pm={0.1};                % Mutation probability, 0.1 by default
% gaDat.ObjfunPar={[]};          % Additional parameters of the objective function
%                                %  have to be packed in a structure, empty by default
% gaDat.indini={[]};             % Initialized members of the initial population, empty
%                                %  by default
%
% Grupo de Control Predictivo y Optimización - CPOH
% Universitat Politècnica de València.
% http://cpoh.upv.es
% (c) CPOH  1995 - 2018
