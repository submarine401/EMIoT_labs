% DPM - RUN/IDLE - Workload 1 - red
DPM_data = dlmread('dpmres_wl1_run_idle.txt');
timeout = DPM_data(:,1);
energy = DPM_data(:,2);
figure(1)
plot(timeout, energy, 'r.', 'LineWidth', 4)
xlabel("timeout (ms)");
ylabel("energy (J)");
grid on;
hold on;
title("DMP - Workload 1 - Global Overview")

% DPM - RUN/IDLE - Workload 1 - blue
DPM_data = dlmread('dpmres_wl1_run_sleep.txt');
timeout = DPM_data(:,1);
energy = DPM_data(:,2);
plot(timeout, energy, 'b.', 'LineWidth', 4)

legend ('DPM RUN/IDLE', 'DPM RUN/SLEEP', 'Location', 'northwest')

% DPM - RUN/IDLE - Workload 2 - red
DPM_data = dlmread('dpmres_wl2_run_idle.txt');
timeout = DPM_data(:,1);
energy = DPM_data(:,2);
figure(2)
plot(timeout, energy, 'r.', 'LineWidth', 4)
xlabel("timeout (ms)");
ylabel("energy (J)");
grid on;
hold on
title("DMP - Workload 2 - Global Overview")

% DPM - RUN/IDLE - Workload 2 - blue
DPM_data = dlmread('dpmres_wl2_run_sleep.txt');
timeout = DPM_data(:,1);
energy = DPM_data(:,2);
plot(timeout, energy, 'b.', 'LineWidth', 4)

legend ('DPM RUN/IDLE', 'DPM RUN/SLEEP', 'Location', 'northwest')