%% DPM - WORKLOAD 2 - RUN/IDLE
% data extraction from file
DPM_data = dlmread('dpmres_wl2_run_idle.txt');
timeout = DPM_data(:,1);
energy = DPM_data(:,2);

% timeout vs consumed energy plot
figure(1)
plot(timeout, energy, 'r.', 'LineWidth', 4)
xlabel("timeout (ms)");
ylabel("energy (J)");
grid on;
title("DMP - RUN/IDLE - Workload 2")

% timeout vs normalized saved energy plot
TOTAL_ENERGY = 30.1388136000;   % energy for WL1 w/o DPM
saved_energy_normalized = zeros(size(energy));

for i = 1:size(energy)
    saved_energy_normalized(i) = ((TOTAL_ENERGY-energy(i))/TOTAL_ENERGY)*100;
end

figure(2)
plot(timeout, saved_energy_normalized, 'g.', 'LineWidth', 4)
xlabel("timeout (ms)");
ylabel("normalized saved energy (%)");
grid on;
title("DMP - RUN/IDLE - Workload 2")