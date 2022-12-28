% this script is implemented in order to
%analyze results coming from the execution
%of the provided displayed_image() function
% for all images in the dataset


%mode variables for 'displaed_image()'
SATURATED = 1;
DISTORTED = 2;
%reference voltage
Vdd = 10; %Volts

%call 'power consumption_dvs' function
[I_cell, P_panel,P_original,dist_arr] = power_consumption_dvs_per_image(Vdd,'5');

for i =1:size(I_cell,4)
    %compute saturared and distorted image for each pair
    img_RGB_sat = displayed_image(I_cell(:,:,:,i), Vdd, SATURATED);
    img_RGB_dist = displayed_image(I_cell(:,:,:,i), Vdd, DISTORTED);
    figure(i)
    subplot(2,1,1)
    image(img_RGB_sat/255);       % display saturated RGB image
    subplot(2,1,2)
    image(img_RGB_dist/255);       % display distorted RGB image
end

%plot original power (it will be represented as a rect)
figure(i+1);
yline(P_original,'r');
hold on
%plot(dist_arr,P_mean,'-.b');
legend('Original image')
xlabel('Avg distortion');
ylabel('Avg power');
grid on
hold off

