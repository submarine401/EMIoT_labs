%% Assignment 2 - part 2
% Cell current calculation section
% for 256x256 images

function [out,dist,P_panel,P_panel2] = power_consumption_dvs(V_ref)
    %matrices initialization
    A_256 = zeros(256,256,3);
    A_256_hsv = zeros(256,256,3);
    I_cell = zeros(256,256,3,'double');
    I_cell1 = 0.0;
    I_cell2 = 0.0;
    P_panel = zeros(1,1,3);
    %declare coefficients and reference voltage
    %V_ref = 15;
    p1 = 4.251e-05;
    p2 = -3.029e-04;
    p3 = 3.024e-05;
    b1 = 3;             %for contrast compensation
    b2 = 0.4;             %for brightness compensation
    
    i_str = 'images.tar/';
    %read 256x256 images only
        %store RGB representation of all images in an array
        image_str= [i_str, '1', '.tiff'];
        A_256 = imread(image_str);
        A_256_orig = A_256;
        figure(1)
        imshow(A_256)
        %==================================
        %keep 'double' type since we deal with
        %very small values
        %==================================

        %convert I_cell value to double
        I_cell = double(I_cell);
        I_cell1 = double(I_cell1);
        I_cell2 = double(I_cell2);

        %approximate all pixels under a certain threshold to 0
        A_256((A_256 <= 100)) = 0;
        figure(2)
        imshow(A_256)

        A_256 = im2double(A_256);
        A_256_orig = im2double(A_256_orig);
        figure(3)
        imshow(A_256_orig)

        %convert from RGB to HSV
        %A_256_hsv = rgb2hsv(A_256_modified);
        %scale brightness and contrast of image (DUMMY VALUES AS FOR NOW)
        %A_256_hsv(:,:,3) = A_256_hsv(:,:,3) * b1;
        %A_256_hsv(:,:,3) = A_256_hsv(:,:,3) + b2;

        %reconvert back to RGB 
        %multiplication by 255 is required since we are dealing with
        %'double' type
        %A_256_modified = hsv2rgb(A_256_hsv)*255;
      
    %compute cell current for each pixel
    % cycle through 4-th dimension, then
    %rows and columns
        for i = 1:size(A_256,1)
            for j = 1:size(A_256,2)
                I_cell1 = (p1*V_ref*A_256(i,j,:))/255;
                I_cell2 = (p2*A_256(i,j,:))/255;
                I_cell(i,j,1) = I_cell1(:,:,1) + I_cell2(:,:,1) + p3;
                I_cell(i,j,2) = I_cell1(:,:,2) + I_cell2(:,:,2) + p3;
                I_cell(i,j,3) = I_cell1(:,:,3) + I_cell2(:,:,3) + p3;
            end
        end

        for i = 1:size(A_256_orig,1)
           for j = 1:size(A_256_orig,2)
               I_cell1_orig = (p1*V_ref*A_256_orig(i,j,:))/255;
               I_cell2_orig = (p2*A_256_orig(i,j,:))/255;
               I_cell_orig(i,j,1) = I_cell1_orig(:,:,1) + I_cell2_orig(:,:,1) + p3;
               I_cell_orig(i,j,2) = I_cell1_orig(:,:,2) + I_cell2_orig(:,:,2) + p3;
               I_cell_orig(i,j,3) = I_cell1_orig(:,:,3) + I_cell2_orig(:,:,3) + p3;
           end
        end
    
    %compute power for each image
        P_panel = V_ref*sum(I_cell,[1 2]);  
        P_panel2 = 15*sum(I_cell_orig,[1 2]);

    %out = round(((I_cell - p3)*255/(p1*15+p2)));
    out=(displayed_image(I_cell,V_ref,1));
    figure(4)
    imshow(out);

    dist = image_distortion(A_256_orig, out);

end