%% Pareto curve average distortion vs average saved power
%  taken the RGB representation of the img, the script
%  computes the saved power for different approaches
%  together with the average distortion
%  results are plotted in a graph

clc
clear all
close all

% max_pow_saving = 0.0;
% max_pow_saving_i = -1;
% min_pow_saving = 100.0;
% min_pow_saving_i = -1;
% min_distortion = 100.0;
% min_distortion_pow_sav = -1;
% min_distortion_i = -1;

%first attempt: use the image_reduce_blue.m script
%compute number of images in the directory
a = dir(['images.tar' '/*.tiff']);
n=numel(a);
% data structures for 256x256 images
A_256 = zeros(256,256,3,7);
B_256 = zeros(256,256,3);

p_array_256=zeros(8,10);
dist_array_256 = zeros(8,10);
p_array_blue_256=zeros(8,10);
dist_array_blue_256 = zeros(8,10);

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
    if i<8  % 256x256 images are only 7, skip last iteration
        image_str= [i_str, num2str(i), '.tiff'];
        A_256(:,:,:,i) = imread(image_str);
        A_256=uint8(A_256);
    end
end

%% Blue reduction

for k = 1:-0.01:0.8
    for i = 1:8
        if i<8  % 256x256 images are only 7, skip last iteration
            B_256 = image_reduce_blue(A_256(:,:,:,i),k);
            %compute power and distortion for 256x256 images
            p_img_256 = image_power(A_256(:,:,:,i));
            p_reduced_256 = image_power(B_256); 
            pow_saving_256 = ((p_img_256 - p_reduced_256)*100)/p_img_256;
    
            % update avg holding variables
            current_avg_power_saving = current_avg_power_saving + pow_saving_256;
            current_avg_distortion = current_avg_distortion + image_distortion(A_256(:,:,:,i),B_256);

        end
    end

    % compute avg and add it to avg arrays
    current_avg_power_saving = current_avg_power_saving/7;
    current_avg_distortion = current_avg_distortion/7;
    avg_power_saving = [avg_power_saving;current_avg_power_saving];
    avg_distortion = [avg_distortion;current_avg_distortion];

end

% plot distortion vs power saving graph - histogram equalization 256x256
figure(1)
plot(avg_distortion, avg_power_saving,'.-b');
hold on
grid on
xlabel('Avg Distortion (%)');
ylabel('Avg Power savings (%)');
title('Avg Power savings vs Avg Distortion Pareto Analysis - 256x256 images');

%% Value scale

% avg variables reset
current_avg_power_saving = 0.0;
current_avg_distortion = 0.0;
avg_power_saving = [];
avg_distortion = [];


% loop to apply different values of k for image value reduction
for k = 1:-0.01:0.8
    % apply given reduction coefficient to all images
    for i = 1:8
        if i<8  % 256x256 images are only 7, skip last iteration
            B_256 = image_value_scale(A_256(:,:,:,i),k);
            %compute power and distortion for 256x256 images
            p_img_256 = image_power(A_256(:,:,:,i));
            p_reduced_256 = image_power(B_256); 
            pow_saving_256 = ((p_img_256 - p_reduced_256)*100)/p_img_256;
    
            % update avg holding variables
            current_avg_power_saving = current_avg_power_saving + pow_saving_256;
            current_avg_distortion = current_avg_distortion + image_distortion(A_256(:,:,:,i),B_256);
        end
    end

    % compute avg and add it to avg arrays
    current_avg_power_saving = current_avg_power_saving/7;
    current_avg_distortion = current_avg_distortion/7;
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
            if i<8  % 256x256 images are only 7, skip last iteration
                B_256 = image_histogram_eq(A_256(:,:,:,i),j,k);
                %compute power and distortion for 256x256 images
                p_img_256 = image_power(A_256(:,:,:,i));
                p_reduced_256 = image_power(B_256); 
                pow_saving_256 = ((p_img_256 - p_reduced_256)*100)/p_img_256;
        
                % update avg holding variables
                current_avg_power_saving = current_avg_power_saving + pow_saving_256;
                current_avg_distortion = current_avg_distortion + image_distortion(A_256(:,:,:,i),B_256);

%                 if pow_saving_256>max_pow_saving
%                     max_pow_saving = pow_saving_256;
%                     max_pow_saving_i = i;
%                 end
%                 if pow_saving_256<min_pow_saving
%                     min_pow_saving = pow_saving_256;
%                     min_pow_saving_i = i;
%                 end
%                 if image_distortion(A_256(:,:,:,i),B_256)<min_distortion
%                     min_distortion = image_distortion(A_256(:,:,:,i),B_256);
%                     min_distortion_pow_sav = pow_saving_256;
%                     min_distortion_i = i;
%                 end
                
            end
        end

%         max_pow_saving
%         max_pow_saving_i
%         min_pow_saving
%         min_pow_saving_i
%         min_distortion
%         min_distortion_pow_sav
%         min_distortion_i
    
        % compute avg and add it to avg arrays
        current_avg_power_saving = current_avg_power_saving/7;
        current_avg_distortion = current_avg_distortion/7;
        avg_power_saving = [avg_power_saving;current_avg_power_saving];
        avg_distortion = [avg_distortion;current_avg_distortion];
    
    end
end

plot(avg_distortion, avg_power_saving,'.r');
legend('blue reduction','value scale','histogram equalization')