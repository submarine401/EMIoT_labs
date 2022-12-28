%% Assignment 2 - part 2
% Cell current calculation section
% for 256x256 images
function [I_cell,P_panel] = power_consumption_dvs_per_image(rel_path)
    %clear all
    %matrices initialization
    RGB_original = zeros(256,256,3);
    A_256 = zeros(256,256,3);
    A_256_hsv = zeros(256,256,3);
    P_mean=zeros(1,5);
    %declare coefficients and counters
    i = 1; %counter for RGB matrix
    p1 = 4.251e-5;
    p2 = -3.029e-04;
    p3 = 3.024e-05;
    %b1 = 0.7;             %for contrast compensation
    b2 = 0.1;             %for brightness compensation
    %mode variables for 'displaed_image()'
    SATURATED = 1;
    DISTORTED = 2;
    %reference voltage
    Vdd = 14.95; %Volts
    %read 256x256 images only
    i_str = 'images.tar/';
    %store RGB representation of all images in an array
    image_str= [i_str, rel_path, '.tiff'];
    RGB_original = imread(image_str);
    %==================================
    %keep 'double' type since we deal with
    %very small values
    %==================================
    %A_256=uint8(A_256);
    

    %convert from RGB to HSV
    %initialize counter for 4th dimension of RGB matrix
    i = 1;
    for k = 300:5:350
        A_256_hsv = rgb2hsv(RGB_original);
        %scale brightness and contrast of image (DUMMY VALUES AS FOR NOW)
        A_256_hsv(:,:,3) = A_256_hsv(:,:,3) + k;
        A_256_hsv(:,:,3) = A_256_hsv(:,:,3) * b2;

        %reconvert back to RGB
        A_256(:,:,:,i) = uint8(hsv2rgb(A_256_hsv))
        i = i+1;
    end

    %compute cell current for each pixel
    % cycle through 4-th dimension, then
    %rows and columns
    for n = 1:size(A_256,4)  
        for i = 1:size(A_256,1)
            for j = 1:size(A_256,2)
                I_cell1 = (p1*Vdd*A_256(i,j,:,n))/255;
                I_cell2 = (p2*A_256(i,j,:,n))/255;
                I_cell(i,j,:,n) = I_cell1 + I_cell2 + p3;
            end
        end
        %compute distortion w.r.t. the original image
        dist_arr(n)=image_distortion(RGB_original,A_256(:,:,:,n));
    end
    
    %compute power of original image
    P_original = image_power(RGB_original);

    %compute power for each image
    for i = 1:size(I_cell,4)
        Image_curr = I_cell(:,:,:,i);
        P_panel(:,:,:,i) = Vdd*sum(Image_curr,[1 2]);
        P_mean(i) = mean(P_panel(1,1,:,i));
    end

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
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                   %PLOTS%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %plot original power (it will be represented as a rect)
    figure(i+1);
    yline(P_original,'r');
    hold on
    plot(dist_arr,P_mean,'.-b');
    legend('Original image')
    xlabel('Avg distortion');
    ylabel('Avg power');
    grid on
    hold off

end


