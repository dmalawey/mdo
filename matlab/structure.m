% cubesat structure module
%------module info----------------------------
% base design has:
% t=2mm
% a=6.35mm
% starting from measured in solidworks
% base mass=149 (g)
% volume=42679 (mm^3)
% calculated mass= base structure mass*(A/baseA)
% constraint:
% modulus*cy >= base_modulus* base_cy
%--------begin function ------------------------
function [s] = structure(X,y)
%---------------assign variables----------------
s101 = X(3);         %material
s102 = 2.7;          %density, g/cc
s103 = 10*10*100/1000; %volume, l*w*h/100 = cc
s104=.002; % rail thickness, t (m)
s105=X(6); % rail width, a (m)
s201=0; % material density (kg/m^3)
s202=0; % machinability (%)
s203=0; % material cost ($/kg)
s204=0; % material modulus (GPa)
s205=0; % rail x-section area (m^2)
s301=0; % structure mass (m^2)
s302=0; % area moment of inertia (m^4)
s303=0; % moment*modulus (m^4*GPa)
%------------assign material data------------
%[density,machinability,cost/kg,modulus]
material=...
    [2700,360,18.08,68.9;...  %Al 6061 T6
     4500,22,141.11,113.8;...     %Titanium
     7850,72,5.47,200];  %A36 steel
for i=1:10;
    if s101==i;
s201   =  material(i,1);
s202   =  material(i,2);
s203   =  material(i,3);
s204   =  material(i,4);
    end 
end
%----------calculations-----------------------
%area=t*(2a-t) (m^2)
s205=s104*(2*s105-s104);
%area moment=(a^2+at-t^2)/(2*(2a-t)) (m^4)
s302=(s105^2+s104*s105-s104^2)/(2*(2*s105-s104));
%moment*modulus (m^4*GPa)
s303=s302*s204;
%mass=baseweight*area/basearea*density/basedensity (kg)
s301=0.149*(s205/2.14e-5)*(s201/2700);
%---------vectorize results-------------------
s=[s101 s102 s103 s104 s105;...
   s201 s202 s203 s204 s205;...
   s301 s302 s303 0.00 0.00];
end
