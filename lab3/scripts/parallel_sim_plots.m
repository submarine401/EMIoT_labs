%% script for plotting data coming from the "parallel" simulation

plot(time1,soc1,'.-')
hold on
xlabel("Time(s)");
ylabel("Battery SOC")
title("time vs SOC - time vs V_{batt}")

yyaxis right
plot(time1,v_batt1,'.-')
ylabel("Battery voltage (V)");
legend("SOC","V_{batt}");

hold off

figure(2)
plot(time1,v_batt1,'.-')
hold on
xlabel("Time(s)");
ylabel("Battery voltage (V)")
title("time vs V_{batt} - time vs V_{PV}")

yyaxis right
plot(time1,v_pv1,'.-')
ylabel("PV panel voltage (V)");
legend("V_{batt}","V_{PV}");

hold off

figure(3)
plot(time1,i_pv1,'.-g')
hold on
title('PV panel current vs real PV panel current')
xlabel('Time')
ylabel('Current(mA)')
axes('Position',[.7 .7 .2 .2])
box on
plot(time1,real_i_pv1,'.-b')

figure(4)
plot(time1(1:length(v_batt)),v_batt,'.-g')
hold on
title("V_{batt} with 1 panel and 2 panels in parallel")
xlabel("Time(s)")
ylabel("Voltage(V)")
plot(time1,v_batt1,'.-b')
legend("1 Panel","2 Panels")

figure(5)
plot(time1(1:length(v_batt)),soc,'.-g')
hold on
title("SOC with 1 panel and 2 panels in parallel")
xlabel("Time(s)")
ylabel("SOC")
plot(time1,soc1,'.-b')
legend("1 Panel","2 Panels")


%for standard
%parallel sim
%plot(time,real_i_pv,'.-b')