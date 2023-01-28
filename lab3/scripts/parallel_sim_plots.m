%% script for plotting data coming from the "parallel" simulation

plot(time,soc,'.-')
hold on
xlabel("Time(s)");
ylabel("Battery SOC")
title("time vs SOC - time vs V_{batt}")

yyaxis right
plot(time,v_batt,'.-')
ylabel("Battery voltage (V)");
legend("SOC","V_{batt}");

hold off

figure(2)
plot(time,v_batt,'.-')
hold on
xlabel("Time(s)");
ylabel("Battery voltage (V)")
title("time vs V_{batt} - time vs V_{PV}")

yyaxis right
plot(time,v_pv,'.-')
ylabel("PV panel voltage (V)");
legend("V_{batt}","V_{PV}");

hold off

figure(3)
plot(time,i_pv,'.-g')
hold on
title('PV panel current vs real PV panel current')
xlabel('Time')
ylabel('Current(mA)')
axes('Position',[.7 .7 .2 .2])
box on
plot(time,real_i_pv,'.-b') %for standard
%parallel sim
%plot(time,real_i_pv,'.-b')