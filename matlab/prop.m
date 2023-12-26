%prop.m Cubesat Propulsion System (rev2)
%----------------------------------------------
function [p] = prop(X,y)
global P 
p101=[5]; %initial disturbance (m/s)
p102=P(9); %disturbance per day (m/s/day)
p103=P(1); %mission duration (days)
p104=[4]; %thruster qty (#)
p105=[]; %cubesat mass (kg)
p106=X(1); %propellant type
p107=X(2); %thruster type
p108=P(10); %prop tank volume (ml)
p109=y(4); %structure mass (kg)
p110=[33e-3]; %propellant tank mass (kg)
p201=[]; % delta-V required (m/s)
%p202=[]; % impulse density of the fuel (N*s/kg)
p203=[]; % density of fuel (g/ml)
p204=[]; % specific impulse (s)
p205=[];% thruster mass (kg)
p206=[]; % thruster power (W)
p301=[]; % impulse required(N*s)
p302=[]; % total power draw (W)
p304=[]; % thruster system mass (kg)
p305=[]; % mass of propellant required (kg)
p306=[]; % volume of propellant required (ml)
p307=[]; % number of prop tanks (#)
% propellant
%[density(g/ml), ISP(s)]
propellant=... 
 [0.02,296;... % Hydrogen
 0.04,179;... % Helium
 0.19,82;...% Neon
 0.28,80;...% Nitrogen
 0.44,57;...% Argon
 1.08,39;...% Krypton
 2.74,31;...% Xenon
 0.96,55;...% Freon 14
 0.19,114;...% Methane
 0.88,105];  %ammonia
%thrusters
%[mass(kg) power(W)]
thruster=...
[  .009,  1.000;... %Moog    (10W actually)
   .050,  0.090;... %Marotta (1W actually)
   .017,  0.890;... %Busek PFCV 
   .035,  0.040];   %Lee LHDB0542115H
%assign propellant and thruster data
for i=1:10;
    if p106==i;
p203   =  propellant(i,1); %(density)
p204   =  propellant(i,2); %(ISP)
    end 
    if p107==i;
p205  =  thruster(i,1); %(mass)
p206  =  thruster(i,2); %(power)
    end
end
%----------transient variables-------------
%total mass = accy mass + struct mass + batt mass + prop mass
p105=P(2)+y(4)+y(2)+y(1);
%----------calculations--------------------
%deltaV=initial+days*rate (m/s)
p201=p101+p102*p103;
%impulse req=deltaV*mass (N*s)
p301=p201*p105;
%propellant mass= I_required/(I_sp*gravity) (kg)
p305=p301/(p204*9.81);
%propvolume=mass/density (ml)
p306=p305*1000/p203;
%tanks required= volume/tankvolume (round up integer)
p307=ceil(p306/p108);
%mass=thruster qty*mass + proptank*mass 
%     + fuelmass + structuremass(kg)
p304=p104*p205+p307*p110+p305+p109;
%power=thruster qty * thruster power (W)
p302=p104*p206;
%---------vectorize results---------------------
p=[p101, p102, p103, p104, p105, p106, p107, p108;...
   p201, 0.00, p203, p204, p205, p206, 0.00, 0.00;...
   p301, p302, 0.00, p304, p305, p306, p307, 0.00];
end

