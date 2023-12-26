% sensitivity.m

%---BEGIN COPY FROM OPTIM.M-------------
%----------DESIGN VECTOR------------------------------
%(1)propellant (2)thruster type (3)structure material
%(4)#panels (5)#batteries (6) struct rail width
%----------GLOBAL PARAMETERS--------------------------
P101=30; %mission duration, (days)
P102=0.33; %cubesat accy mass (kg)
P103=0.3; %solar panel sunlight(ratio)
P104=4; % default X1 (Nitrogen=4)
P105=3; % default X2 (Lee=3)
P106=1; % default X3 (6061=1)
global P %create a global set of parameters
P=[P101 P102 P103 P104 P105 P106];
clear P101 P102 P103 P104 P105 P106;
%-----END COPY FROM OPTIM.M--------------
%%
%----CALL THE OBJECTIVE FUNCTION FOR
%----CENTRAL DIFFERENCE EVALUATION
%loop to perturb each variable
x0=[4,  2,.008];

for i=1:6
    x(i)=
    x2()
    minus_delta=
    [j,s,p,b,y,c] = objective(X);
end


%% CENTRAL DIFFERENCE

%%
%----------------x^3-----------------------%
x=[];
y=[];
y2=[];
delta=logspace(-15,1); %vector of 50 length
x1=1;  %initial x point
for n=1:50
    x(n)=x1+delta(n);
    x2(n)=x1-delta(n);
    y(n)=3*x(n)^2;
    y2(n)=((x(n))^3-x2(n)^3)/(2*delta(n));
    end
y4=abs(y2-y);
