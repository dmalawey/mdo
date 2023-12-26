% *BOLD TEXT* opticon.m constraints for the problem
function [C,Ceq]=constraint(X)
%--------Calculations------------------
%--------Instructions: copy "objective" calculations
%---------into this section so that s,b,p can be
%---------calculated
global P
%---this section for gradient method--------
%---make sure to update "fixed" variables---
if length(X)==3
fixed=[P(4:6)]; %populate fixed variables from global P
vari=[X];
X=[fixed,vari];
end
%--------calculate y vector first time -----------------
% [battmass,propmass,proppwr]
y0=[.010 .400 50 100];   %set initial y values
y=y0;                %declare y to be initial  
[s]=structure(X,y); %run structure
y(4)=s(3,1);
[p]= prop(X,y);     %run prop
y(2)=p(3,4);         %update y, prop
y(3)=p(3,2);
[b] = battery(X,y);%run battery
yprev=y(1);
yprev2=y(2);
yprev3=y(3);
y(1)=b(3,4);            %update y, batt
ydiff=abs(y(1)-yprev);  %calculate ydiff
ydiff2=abs(y(2)-yprev2);
ydiff3=abs(y(3)-yprev3);
i=1;
diffplot(i)=ydiff;
diffplot2(i)=ydiff2;
diffplot3(i)=ydiff3;
%--------iterate the y vector for convergence---------
while (ydiff>0.001 || ydiff2>0.001 || ydiff3>0.001)
    i=i+1;
    [p]= prop(X,y); %run prop
    y(2)=p(3,4);         %update y
    y(3)=p(3,2);
    [b] = battery(X,y);%run battery
    yprev=y(1);             %save y as "previous"
    yprev2=y(2);
    yprev3=y(3);
    y(1)=b(3,4);            %update y
    ydiff=abs(y(1)-yprev);  %update ydiff
    ydiff2=abs(y(2)-yprev2);
    ydiff3=abs(y(3)-yprev3);
    diffplot(i)=ydiff;      %save each ydiff for plotting
    diffplot2(i)=ydiff2;
    diffplot3(i)=ydiff3;
end
  
 %%
  %----------Constraints--------------
% 1) power requirements met by solar + batteries
% 2) moment*modulus > baseline
% ...propellant in tanks is enough to satisfy delta-V
C1= b(3,1)-(b(2,2)+b(3,5));
C2= P(12)*10-s(3,3)*10;
C=[C1 C2];
Ceq=[];  %Ceq must be empty while using integer vars
end 