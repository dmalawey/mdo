% cost.m calculates the cost of the design

function [c] = cost(X,s,p,b)
%---------NAME VARIABLES--------------
global P
c101 = 10; % battery price ($)
c102 = 1500; % solar panel price ($)
c103 = []; % propellant price ($/kg)
c104 = []; % thruster price ($)
c105 = []; % material price ($/kg)
c106 = []; % material machinability (%)
c107 = 960; %cost to machine 6061, as base cost ($)
c201 =[]; %battery cost ($)
c202 =[]; %solar panel cost ($)
c203 =[]; %propellant cost ($)
c204 =[]; %thruster cost($)
c205 =[]; %material cost ($)
c206 =[]; %machining cost ($)
c301=[]; %total cost ($)
c302=[]; %total mass (kg)
%--------translate variables---------
% propellant cost ($/kg)
propellant=[120,52,330,4,5,330,1200,10,10,10];
    % Hydrogen, Helium, Neon, Nitrogen
    % Argon, Krypton, Xenon, Freon 14*
    % Methane*, ammonia* (* means guess)
%thrusters cost
thruster=[111,222,66,700];
% Moog 58X125A, marotta, Busek, Lee
% assign propellant and thruster data
% material cost ($/kg,machinability)
material=[18.08,360;... 
          141.11,22;...
          5.47,72];
for i=1:10;
    if X(1)==i;
c103   =  propellant(i);
    end 
    if X(2)==i;
c104  =  thruster(i);
    end
    if X(3)==i;
c105= material(i,1);
c106= material(1,2);
    end
end
%-------------CALCULATIONS-----------------
% batt cost = price * number of batteries
c201=c101*X(5);
% panel cost = price * number of solar panels
c202=c102*X(4);
% propellant cost = price * mass of propellant(kg)
c203=c103*p(3,5);
% thruster cost = price * number of thrusters
c204=c104*p(1,4);
% mass of material (kg)
c205=c105*1;
%machine cost = base cost % base_mch'ty/mch'ty
c206=c107*360/c106;
%total cost =batt+solar+prop+thruster+material+machining
c301=  c201+c202 +c203 +c204   +c205     +c206;
%total mass = 
c302=b(3,4)+p(3,4)+s(3,1)+P(2);
%-------------vectorize results------------
c=[c101 c102 c103 c104 c105 c106 c107;...
   c201 c202 c203 c204 c205 c206 0.00;...
   c301 c302 0.00 0.00 0.00 0.00 0.00];
end