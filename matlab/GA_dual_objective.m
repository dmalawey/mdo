%GA Dual Objective
%Purpose: run the GA with combined mass and cost objective
%in order to debug the dual_objective code
clear all
%----------------------------------------------------------
%----------DESIGN VECTOR------------------------------------
%(1)propellant (2)thruster type (3)structure material
%(4)#panels (5)#batteries (6) struct rail width

%----------GLOBAL PARAMETERS--------------------------------
P101=30; %mission duration, (days)
P102=0.33; %cubesat accy mass (kg)
P103=0.1; %solar panel sunlight(ratio)
P104=4; % default X1 (Nitrogen=4)
P105=3; % default X2 (Lee=3)
P106=1; % default X3 (6061=1)
P107=3400; %4000 %battery capacity (mAh)
P108=2.1; % power of 1 solar panel (W)
P109=0.5; %rate, disturbance per day (m/s/day)
P110=16.34; %prop tank volume (ml)
P111=3; % power factor of safety (FOS)
P112=0.1579; % min bending stiffness (m^4*GPa)
global P %create a global set of parameters
P=[P101 P102 P103 P104 P105 P106 P107 P108,...
    P109 P110 P111 P112];
clear P101 P102 P103 P104 P105 P106 P107 P108...
    P109 P110 P111 P112;
%%
% ---------------Set up the problem---------------
lam=1;

%%
% %----------GENETIC ALGORITHM APPROACH------------------------
LB=[1,  1,  1, 0,  1, .003];
UB=[9,  4,  3, 4, 10, .020];
x0=[1,  1,  1, 1,  1, .010];
tic
options= gaoptimset('Display','off','Generations',160,...
    'Elitecount',4,'PopulationSize',20,'TolCon',0.01,...
   'PlotFcns',@gaplotbestf);
[X]=ga(@(X) dual_obj(X,lam),6,...
    [],[],[],[],LB,UB,@(X) constraint(X),[1 2 3 4 5],options)
% "6" says that there are 6 design variables
% [1 2 3 4 5] calls out that these are integer variables
P(4)=X(1);
P(5)=X(2);
P(6)=X(3);
clear LB UB x0 time
%% 
%-------------recalculate all vars with final X--------------
[j,s,p,b,y,c] = objective(X);
%-------------tables entries---------------------------------
%propellant
ptable=... 
 {'Hydrogen','Helium','Neon','Nitrogen','Argon',...
 'Krypton','Xenon','Freon','Methane','ammonia'};
%thrusters
ttable={'Moog','Marotta','Busek','lee LHDB', };
%materials
mtable={'Al 6061 T6','titanium','A36 steel'};
cost=c(3,1)
mass=c(3,2)
