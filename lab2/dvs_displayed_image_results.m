% this script is implemented in order to
%analyze results coming from the execution
%of the provided displayed_image() function
% for all images in the dataset

%load the image_current matrices (output of
% the "power_consumption_dvs.m" script)
%load("image_current_matrix.mat");

%mode variables for 'displaed_image()'
SATURATED = 1;
DISTORTED = 2;
%reference voltage
Vdd = 10; %Volts
%I_cell = zeros(256,256,3,7);
%call 'power consumption_dvs' function
I_cell = power_consumption_dvs(Vdd);

for i =1:7
    %compute saturared and distorted image for each pair
    img_RGB_sat = displayed_image(I_cell(:,:,:,i), Vdd, SATURATED);
    img_RGB_dist = displayed_image(I_cell(:,:,:,i), Vdd, DISTORTED);
    figure(i)
    subplot(2,1,1)
    image(img_RGB_sat/255);       % display saturated RGB image
    subplot(2,1,2)
    image(img_RGB_dist/255);       % display distorted RGB imagz

end
