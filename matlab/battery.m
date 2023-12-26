%battery.m Cubesat Power System
function [b] = battery(X,y)
%---------LEVEL 1 VARIABLES--------------
global P
b101 = P(7); %battery capacity (mAh)
b102 = P(11); %factor of safety
b103 = P(1); %mission duration (days)
b104 = 300; % com power consumption (mA)
b105 = .10; % com duty ratio (ratio)
b106 = y(3); % prop power consumption (W)
b107 = .025;% prop duty ratio (ratio)
b108 = 44.5; %weight per battery (g)
b109 = P(8); % power of 1 solar panel (W)
b110 = 45;  % mass of 1 solar panel (g)
b111 = X(4); % number of solar panels (#)
b112 = 3.6; %battery voltage, nominal (v)
b113 = 3.3; %main circuit voltage (v)
b114 = X(5); % number of batteries (#)
b115= P(3); %solar panel sunlight(ratio)
b116= 0.04; %ADS average power (W)
b117= 0.02; %Payload avg power (W)

%-------------LEVEL 2 VARIABLES------------
b201 =0; %total mAh drawn (mAh)
b202 =0; %batteries energy (Wh)
b203=0; % energy used in misison, raw (Wh)
b204=0; % average power of mission, raw (W)
b205=0; % power used by thrusters
b206=0; % power used by com
%-------------LEVEL 3 VARIABLES------------
b301=0; % energy used in misison with FOS (Wh)
b302=0; % mass of batteries (g)
b303=0; % mass of solar panels (g)
b304=0; % mass, total power unit (g)
b305=0; % panels energy (Wh)
%-------------CALCULATIONS-----------------
%current drawn = miliamps * duration (mAh)
b201=(b104*b105)*b103*24;
%energy drawn = mAh/1000*v +prop pwr*duration(Wh)
%               +ADSpwr*h +Payloadpwr*h
b203=b201/1000*b113+(b106*b107*b103*24)...
        +b116*b103*24 +b117*b103*24;
%thruster power=W*ratio
b205=b106*b107;
%com power = mA/1000 * ratio * V
b206=b104/1000*b105*b113;
%power level = Wh/h
b204=b203/(b103*24);
%energy drawn with FOS = energy drawn *FOS (Wh)
b301=b203*b102;
%batt energy = qty*mAh*v/1000 (Wh)
b202=b114*(b101/1000)*b112;
%batt mass = mass * qty (g)
b302=b114*b108;
%panel mass * quantity (g)
b303=b110*b111;
%panel energy qty*watts*hours*sun_ratio (Wh)
b305=b111*b109*b103*24*b115;
% mass summation (kg)
b304=(b302+b303)/1000;
%-------------transient variables--------
b=[b101 b102 b103 b104 b105 b106 b107 b108 b109...
      b110 b111 b112 b113 b114 b115 b116 b117 0.00;...
      b201 b202 b203 b204 b205 b206 0.00 0.00 0.00...
      0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00;...
      b301 b302 b303 b304 b305 0.00 0.00 0.00 0.00...
      0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00];
end

