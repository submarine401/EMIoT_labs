% this script plots the P-V curves for the PV cell at different
% irradiance values
%preliminary step: import digitized data from the PV cell datasheet
PW_250 = zeros(size(PVcell250Wm2,1),1);
PW_500 = zeros(size(PVcell500Wm2,1),1);
PW_750 = zeros(size(PVcell750Wm2,1),1);
PW_1000 = zeros(size(PVcell1000Wm2,1),1);

%array of voltages
V_250 = PVcell250Wm2(:,1);
V_250 = V_250.';
V_500 = PVcell500Wm2(:,1);
V_500 = V_500.';
V_750 = PVcell750Wm2(:,1);
V_750 = V_750.';
V_1000 = PVcell1000Wm2(:,1);
V_1000 = V_1000.';

%array of currents
I_250 = PVcell250Wm2(:,2);
I_250 = I_250.';
I_500 = PVcell500Wm2(:,2);
I_500 = I_500.';
I_750 = PVcell750Wm2(:,2);
I_750 = I_750.';
I_1000 = PVcell1000Wm2(:,2);
I_1000 = I_1000.';

%compute power for each point of each VI curve
for i = 1:size(PVcell250Wm2,1)
    PW_250(i) = PVcell250Wm2(i,1).*PVcell250Wm2(i,2); 
end
for i = 1:size(PVcell500Wm2,1)
    PW_500(i) = PVcell500Wm2(i,1)*PVcell500Wm2(i,2); 
end

for i = 1:size(PVcell750Wm2,1)
    PW_750(i) = PVcell750Wm2(i,1)*PVcell750Wm2(i,2); 
end
for i = 1:size(PVcell1000Wm2,1)
    PW_1000(i) = PVcell1000Wm2(i,1)*PVcell1000Wm2(i,2); 
end

%extract max power from the computed power arrays
maxPW_250=max(PW_250);
maxPW_500=max(PW_500);
maxPW_750=max(PW_750);
maxPW_1000=max(PW_1000);

%plot P-V curves
figure(1)
plot(I_250,PW_250,'.-r')
hold on
plot(I_500,PW_500,'.-k')
plot(I_750,PW_750,'.-c')
plot(I_1000,PW_1000,'.-g')
legend('250 W/m^2','500 W/m^2','750 W/m^2','1000 W/m^2','Location','northwest');