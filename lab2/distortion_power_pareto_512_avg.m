%% Pareto curve average distortion vs average saved power
%  taken the RGB representation of the img, the script
%  computes the saved power for different approaches
%  together with the average distortion
%  results are plotted in a graph

clc
clear all
close all

%first attempt: use the image_reduce_blue.m script
%compute number of images in the directory
a = dir(['images.tar' '/*.tiff']);
n=numel(a);

% data structures for 512x512 images
A_512 = zeros(512,512,3,8);
B_512 = zeros(512,512,3);
p_array_512=zeros(8,10);
dist_array_512 = zeros(8,10);
p_array_blue_512=zeros(8,10);
dist_array_blue_512 = zeros(8,10);

% avg variables initialization
current_avg_power_saving = 0.0;
current_avg_distortion = 0.0;
avg_power_saving = [];
avg_distortion = [];

% loads images
i_str = 'images.tar/';
for i = 1:8
   %initialize counters to cycle inside
   %power and distortion matrices
   j=1;
   n = 1; 
    %store RGB representation of all images in an array
    image_str= [i_str, num2str(i+7), '.tiff'];
    A_512(:,:,:,i) = imread(image_str);
    A_512=uint8(A_512);
end

%% Blue reduction

for k = 1:-0.02:0
    for i = 1:8
        B_512 = image_reduce_blue(A_512(:,:,:,i),k);
        %compute power and distortion for 512x512 images
        p_img_512 = image_power(A_512(:,:,:,i));
        p_reduced_512 = image_power(B_512);
        pow_saving_512 = ((p_img_512 - p_reduced_512)*100)/p_img_512;

        % update avg holding variables
        current_avg_power_saving = current_avg_power_saving + pow_saving_512;
        current_avg_distortion = current_avg_distortion + image_distortion(A_512(:,:,:,i),B_512);
    end

    % compute avg and add it to avg arrays
    current_avg_power_saving = current_avg_power_saving/8;
    current_avg_distortion = current_avg_distortion/8;
    avg_power_saving = [avg_power_saving;current_avg_power_saving];
    avg_distortion = [avg_distortion;current_avg_distortion];

end

% plot distortion vs power saving graph - histogram equalization 512x512
figure(1)
plot(avg_distortion, avg_power_saving,'.-b');
hold on
grid on
xlabel('Avg Distortion (%)');
ylabel('Avg Power savings (%)');
title('Avg Power savings vs Avg Distortion Pareto Analysis - 512x512');


%% Value scale

% avg variables reset
current_avg_power_saving = 0.0;
current_avg_distortion = 0.0;
avg_power_saving = [];
avg_distortion = [];

% loop to apply different values of k for image value reduction
for k = 1:-0.1:0
    % apply given reduction coefficient to all images
    for i = 1:8
        B_512 = image_value_scale(A_512(:,:,:,i),k);
        %compute power and distortion for 512x512 images
        p_img_512 = image_power(A_512(:,:,:,i));
        p_reduced_512 = image_power(B_512); 
        pow_saving_512 = ((p_img_512 - p_reduced_512)*100)/p_img_512;

        % update avg holding variables
        current_avg_power_saving = current_avg_power_saving + pow_saving_512;
        current_avg_distortion = current_avg_distortion + image_distortion(A_512(:,:,:,i),B_512);
    end

    % compute avg and add it to avg arrays
    current_avg_power_saving = current_avg_power_saving/8;
    current_avg_distortion = current_avg_distortion/8;
    avg_power_saving = [avg_power_saving;current_avg_power_saving];
    avg_distortion = [avg_distortion;current_avg_distortion];

end

plot(avg_distortion, avg_power_saving,'.-g');

%% Histogram equalization

% avg variables reset
current_avg_power_saving = 0.0;
current_avg_distortion = 0.0;
avg_power_saving = [];
avg_distortion = [];

% Nested loop to apply different values of j,k to histogram equalization
%   function. j*k is the number of tiles in which the image is divided for
%   processing. (Maybe try also 'ClipLimit' and 'Distribution'???)
for j = 2:1:10
    for k = 2:1:10
        for i = 1:8
            B_512 = image_histogram_eq(A_512(:,:,:,i),j,k);
            %compute power and distortion for 512x512 images
            p_img_512 = image_power(A_512(:,:,:,i));
            p_reduced_512 = image_power(B_512); 
            pow_saving_512 = ((p_img_512 - p_reduced_512)*100)/p_img_512;
    
            % update avg holding variables
            current_avg_power_saving = current_avg_power_saving + pow_saving_512;
            current_avg_distortion = current_avg_distortion + image_distortion(A_512(:,:,:,i),B_512);
        end
    
        % compute avg and add it to avg arrays
        current_avg_power_saving = current_avg_power_saving/8;
        current_avg_distortion = current_avg_distortion/8;
        avg_power_saving = [avg_power_saving;current_avg_power_saving];
        avg_distortion = [avg_distortion;current_avg_distortion];
    
    end
end

plot(avg_distortion, avg_power_saving,'.r');
legend('blue reduction','value scale','histogram equalization')
