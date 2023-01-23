%% script for plotting data coming from the "parallel" simulation

plot(time1,soc1,'.-')
hold on
xlabel("Time(s)");
ylabel("Battery SOC")
title("time vs SOC - time vs V_batt")

yyaxis right
plot(time1,v_batt,'.-')
ylabel("Battery voltage (V)");
legend("SOC","V_batt");

hold off

figure(2)
plot(time1,v_batt,'.-')
hold on
xlabel("Time(s)");
ylabel("Battery voltage (V)")
title("time vs SOC - time vs V_batt")

yyaxis right
plot(time1,v_pv,'.-')
ylabel("PV panel voltage (V)");
legend("V_{batt}","V_{PV}");

hold off

figure(3)
plot(time1,i_pv,'.-g')
hold on
plot(time1,real_i_pv,'.-b')
% plot(time1,i_mcu,'.-k')
% plot(time1,i_pv,'.-c')
% plot(time1,i_rf,'.-y')
% plot(time1,i_air_quality_sensor,'Color',"#EDB120")
% plot(time1,i_methane_sensor,'Color','#A2142F')
% plot(time1,i_temperature_sensor,'Color','#D81DBF')
title('PV panel current vs real PV panel current')
xlabel('Time')
ylabel('Current(mA)')
legend('I_{pv}','Real I_{pv}')