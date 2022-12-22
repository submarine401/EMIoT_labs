%% Assignment 2 - part 2
% Cell current calculation section
%clear workspace
clear all;

%declare coefficients and reference voltage
A_256 = zeros(256,256,3,7);
I_cell = zeros(256,256,3,7);
P_panel = zeros(1,1,3,7);
V_ref = 15;
p1 = 4.251e-05;
p2 = -3.029e-04;
p3 = 3.024e-05;
k = 1; %to cycle through the current array

%read 256x256 images only
i_str = 'images.tar/';
for i = 1:7 
    %store RGB representation of all images in an array
    image_str= [i_str, num2str(i), '.tiff'];
    A_256(:,:,:,i) = imread(image_str);
    %A_256=uint8(A_256);
end

%compute cell current for each pixel
for n = 1:size(A_256,4)
    for i = 1:size(A_256,1)
        for j = 1:size(A_256,2)
            I_cell1 = (p1*V_ref*A_256(i,j,:,n))/255;
            I_cell2 = (p2*A_256(i,j,:,n))/255;
            I_cell(i,j,:,n) = I_cell1 + I_cell2 + p3;
            k = k + 1;
        end
    end
    k = 1;
end

for i = 1:size(I_cell,4)
    Image_curr = I_cell(:,:,:,i);
    P_panel(:,:,:,i) = V_ref*sum(Image_curr,[1 2]);
end