%% Assignment 2 - part 2
% Cell current calculation section
% for 256x256 images

function [A_256,I_cell,P_panel] = power_consumption_dvs(V_ref)
    %matrices initialization
    A_256 = zeros(256,256,3,7);
    A_256_hsv = zeros(256,256,3,7);
    I_cell = zeros(256,256,3,7);
    P_panel = zeros(1,1,3,7);
    %declare coefficients and reference voltage
    %V_ref = 15;
    p1 = 4.251e-5;
    p2 = -3.029e-04;
    p3 = 3.024e-05;
    b1 = 0.7;             %for contrast compensation
    b2 = 120;             %for brightness compensation
    
    %read 256x256 images only
    i_str = 'images.tar/';
    for i = 1:7 
        %store RGB representation of all images in an array
        image_str= [i_str, num2str(i), '.tiff'];
        A_256(:,:,:,i) = imread(image_str);
        %==================================
        %keep 'double' type since we deal with
        %very small values
        %==================================
        %A_256=uint8(A_256);
    end
    

    %convert from RGB to HSV
    for n = 1:size(A_256,4)
        A_256_hsv(:,:,:,n) = rgb2hsv(A_256(:,:,:,n));
        %scale brightness and contrast of image (DUMMY VALUES AS FOR NOW)
        A_256_hsv(:,:,3,n) = A_256_hsv(:,:,3,n) * b1;
        A_256_hsv(:,:,3,n) = A_256_hsv(:,:,3,n) + b2;

        %reconvert back to RGB
        A_256(:,:,:,n) = hsv2rgb(A_256_hsv(:,:,:,n));
    end

    %compute cell current for each pixel
    % cycle through 4-th dimension, then
    %rows and columns
    for n = 1:size(A_256,4)  
        for i = 1:size(A_256,1)
            for j = 1:size(A_256,2)
                I_cell1 = (p1*V_ref*A_256(i,j,:,n))/255;
                I_cell2 = (p2*A_256(i,j,:,n))/255;
                I_cell(i,j,:,n) = I_cell1 + I_cell2 + p3;
            end
        end
    end
    
    %compute power for each image
    for i = 1:size(I_cell,4)
        Image_curr = I_cell(:,:,:,i);
        P_panel(:,:,:,i) = V_ref*sum(Image_curr,[1 2]);    
    end
end