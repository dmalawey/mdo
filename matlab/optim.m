%optim.m calls the objective function into the optimizer
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
P107=3600; %battery capacity (mAh)
P108=2.1; % power of 1 solar panel (W)
P109=0.5; %rate, disturbance per day (m/s/day)
P110=16.34; %prop tank volume (ml)
P111=2; % power factor of safety (FOS)
P112=0.1579; % min bending stiffness (m^4*GPa)
global P %create a global set of parameters
P=[P101 P102 P103 P104 P105 P106 P107 P108,...
    P109 P110 P111 P112];
clear P101 P102 P103 P104 P105 P106 P107 P108...
    P109 P110 P111 P112;
%%
%----------FMINCON APPROACH----------------------------------
% for fmincon the problem is reduced to X(4,5&6) as 
% %(1)#panels (2)#batteries (3) struct rail width
LB=[0,  1, .006];
UB=[4, 10, .020];
x0=[4,  2,.008];
% objective2.m and constraint2.m are modified to keep
% X1~3 as initial values and only vary the others.
% IMPORTANT STEPS: update objective2 and constraint2
tic
options= optimoptions(@fmincon,'Display','iter',...
    'MaxIter',150,'PlotFcns',@optimplotfval,...
    'Algorithm','sqp');
[X,FVAL, OUTPUT] = fmincon(@(X) objective(X),x0,...
    [],[],[],[],LB,UB,@(X) constraint(X),options);
%re-declare fixed parts of X to get full vector
time=toc;
fixed=[P(4:6)]; %populate fixed variables from global P
vari=[X];
X=[fixed,vari];
%%
%----------GENETIC ALGORITHM APPROACH------------------------
% LB=[1,  1,  1, 0,  1, .003];
% UB=[9, 3,  3, 4, 10, .020];
% x0=[1,  1,  1, 1,  1,.010];
% tic
% options= gaoptimset('Display','off','Generations',80,...
%     'Elitecount',6,'PopulationSize',30,'TolCon',0.01,...
%    'PlotFcns',@gaplotbestf);
% [X]=ga(@(X) objective(X),6,...
%     [],[],[],[],LB,UB,@(X) constraint(X),[1 2 3 4 5],options)
% time=toc;
% % "5" says that there are 5 design variables
% % [1 2 3 4 5] calls out that these are integer variables
%
% % %----------PARETO FRONT W/GENETIC ALGORITHM---------------------
% LB=[1,  1,  1, 0,  1, .003];
% UB=[9, 3,  3, 4, 10, .020];
% x0=[1,  1,  1, 1,  1,.010];
% options= gaoptimset('Display','off','Generations',60,...
%     'Elitecount',6,'PopulationSize',30,'TolCon',0.01);%,...
%    % 'PlotFcns',@gaplotbestf);
% N=10; % number of iterations
% tic
% for i=1:N;
%     lam=i*(1/N)
% clear X
%     [X]=ga(@(X) dual_obj(X,lam),6,...
%     [],[],[],[],LB,UB,@(X) constraint(X),[1 2 3 4 5],options);
% [j,s,p,b,y,c] = dual_obj(X,lam);
% cdata(i,1)=c(3,1); % cost (g)
% mdata(i,1)=c(3,2)*1000; %mass (g)
% solution(i,:)=X; %design vectors
% end
% time=toc
% % "5" says that there are 5 design variables
% % [1 2 3 4 5] calls out that these are integer variables
% figure
% plot(cdata,mdata,'o');
% xlabel('cost ($)');
% ylabel('mass (g)');
% title('pareto front');
%% 
%-------------recalculate all vars with final X--------------
[j,s,p,b,y,c] = objective(X);
%-------------tables entries---------------------------------
%propellant
ptable=... 
 {'Hydrogen','Helium','Neon','Nitrogen','Argon',...
 'Krypton','Xenon','Freon','Methane','ammonia'};
%thrusters
ttable={'moog','marotta','lee LHDB0542115H'};
%materials
mtable={'Al 6061 T6','titanium','A36 steel'};

%%
%---------------create output UI-----------------------------

fig1=figure('Name','Results'); %give the fig a name and variable
set(fig1,'Position',[50 300 700 400]); %bottom,left,width,height
piedata=[p(3,4),s(3,1),...
    b(3,4),P(2)]*1000;
labels = {'prop','structure','battery','accy'};
subplot(1,2,1);
pie(piedata,labels)
title('Total Cubesat Mass');

% Create the column and row names in cell arrays 
massdata=[int32(1000*(p(3,4)))...
    int32(1000*(s(3,1))),...
    int32(1000*(b(3,4))),...
    int32(1000*P(2))];
rownames = {'mass (g)'};
% Create lower UI table
t = uitable(...
            'Data',massdata,...
            'ColumnName',labels,... 
            'RowName',rownames,...
            'Position',[300 15 390 40]); %left,bottom,width,height
%create mid UI table
rowlabel = {'algorithm run time (s)','prop tanks (qty)',...
    'propellant mass (g)','pwr consumption (Wh)',...
    'solar pwr produced(Wh)'};
columnnames= {'Value'};
    xdata2={time;p(3,7);p(3,5)*1000;b(3,1);b(3,5)};
    % xdata(1,2)= {'ptable(X(1))'};
t = uitable(...
            'Data',xdata2,...
            'ColumnName',columnnames,... 
            'RowName',rowlabel,...
            'Position',[350 65 325 115]); %left,bottom,width,height
txt = uicontrol('Style','text',...
        'Position',[375 185 120 20],...
        'String','Table B: Relevant Data');
%create upper UI table
designvars = {'total mass (g)','propellant','thruster',...
    'material','solar panels','batteries',...
    'structure width(mm)'};
columnnames= {'Value'};
xdata={int16(c(3,2)*1000);ptable{X(1)};ttable{X(2)};...
    mtable{X(3)};X(4);X(5);X(6)*1000};
    % xdata(1,2)= {'ptable(X(1))'};
t = uitable(...
            'Data',xdata,...
            'ColumnName',columnnames,... 
            'RowName',designvars,...
            'Position',[350 210 290 165]); %left,bottom,width,height
txt = uicontrol('Style','text',...
        'Position',[375 370 120 20],...
        'String','Table A: Design Vector');
clear massdata mtable piedata ptable rowlabel rownames...
    ttable txt xdata xdata2 time columnnames designvars...
    options;
clear LB UB x0 OUTPUT fixed vari;
    
%%
%---------------cost output UI-----------------------------
fig2=figure('Name','Cost'); %give the fig a name and variable
set(fig2,'Position',[50 300 400 400]); %bottom,left,width,height
% batt+solar+prop+thruster+material+machining
piedata=[c(2,1),c(2,2),c(2,3),c(2,4),c(2,5),c(2,6)];
labels = {'batt','solar','propellant','thruster',...
    'material','machining'};
pie(piedata,labels)
clear piedata labels;
title('Total Cubesat Cost');