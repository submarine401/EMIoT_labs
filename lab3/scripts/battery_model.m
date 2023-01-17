%% Battery model script
%Define open-circuit voltage and resistance 
% (SOC-dependant)
clear all
%import data
filename1='datasheet/Battery/1C_discharge_curve.txt';
filename2='datasheet/Battery/05C_discharge_curve.txt';
C1_data=importdata(filename1,',');
C05_data=importdata(filename2,',');
%matrices containing SOC vs battery voltage
C1_curve = C1_data.data;
C05_curve = C05_data.data;

%discharge currents (as defined in the datasheet)
% currents are in mA
C02_curr = 680;
C05_curr = 1650;
C1_curr = 3300;
C2_curr = 6600;

%vector of linearly spaced elements (for interpolation only)
SOC=0.05:0.05:0.95;

%NOTE: to compute R and V_OC we need two curves
%to this purpose we use the 1C and the 0.5C curves

%interpolation of digitized curves
C1_interp = interp1(C1_curve(:,1),C1_curve(:,2),SOC,'spline');
C05_interp = interp1(C05_curve(:,1),C05_curve(:,2),SOC,'spline');

 plot(C1_curve(:,1), C1_curve(:,2),'.-g')
 %figure(2)
 hold on
 grid on
 plot(SOC, C1_interp,'.-r')

%extract voltage and resistance for the two curves
for i = 1:size(C1_interp,2)
    R(i) = (C05_interp(i)- C1_interp(i))/((C1_curr - C05_curr)*1e-03);
    V_OC(i) =  C1_interp(i) + R(i)*C1_curr*1e-03;
end
%we must express V_OC and R as a FUNCTION OF THE SOC