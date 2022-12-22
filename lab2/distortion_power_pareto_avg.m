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
% data structures for 256x256 images
A_256 = zeros(256,256,3,15);
B_256 = zeros(256,256,3);

p_array_256=zeros(8,10);
dist_array_256 = zeros(8,10);
p_array_blue_256=zeros(8,10);
dist_array_blue_256 = zeros(8,10);
% data structures for 512x512 images
A_512 = zeros(512,512,3,8);
B_512 = zeros(512,512,3);
p_array_512=zeros(8,10);
dist_array_512 = zeros(8,10);
p_array_blue_512=zeros(8,10);
dist_array_blue_512 = zeros(8,10);

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
    image_str= [i_str, num2str(i+7), '.tiff'];
    A_512(:,:,:,i) = imread(image_str);
    A_512=uint8(A_512);
end

%% Blue reduction

for k = 1:-0.02:0
    for i = 1:8
        if i<8  % 256x256 images are only 7, skip last iteration
            B_256 = image_reduce_blue(A_256(:,:,:,i),k);
            %compute power and distortion for 256x256 images c
            p_img_256 = image_power(A_256(:,:,:,i));
            p_reduced_256 = image_power(B_256); 
%             p_diff_256 = p_img_256 - p_reduced_256;
            pow_saving_256 = ((p_img_256 - p_reduced_256)*100)/p_img_256;
    
            %store into the power array the normalized difference 256x256
            current_avg_power_saving = current_avg_power_saving + pow_saving_256;
            current_avg_distortion = current_avg_distortion + image_distortion(A_256(:,:,:,i),B_256);
        end

        B_512 = image_reduce_blue(A_512(:,:,:,i),k);
        %compute power and distortion for 512x512 images
        p_img_512 = image_power(A_512(:,:,:,i));
        p_reduced_512 = image_power(B_512); 
%         p_diff_512 = p_img_512 - p_reduced_512;
        pow_saving_512 = ((p_img_512 - p_reduced_512)*100)/p_img_512;

        %store into the power array the normalized difference 512x512
        current_avg_power_saving = current_avg_power_saving + pow_saving_512;
        current_avg_distortion = current_avg_distortion + image_distortion(A_512(:,:,:,i),B_512);
    end

    current_avg_power_saving = current_avg_power_saving/15;
    current_avg_distortion = current_avg_distortion/15;
    avg_power_saving = [avg_power_saving;current_avg_power_saving];
    avg_distortion = [avg_distortion;current_avg_distortion];

end

% plot distortion vs power saving graph - histogram equalization 256x256
figure(1)
plot(avg_distortion, avg_power_saving,'.-g');
% plot(dist_array_256(1,:),p_array_256(1,:),'-r');
hold on
grid on
% plot(dist_array_256(2,:),p_array_256(2,:),'Color','#7E2F8E');
% plot(dist_array_256(3,:),p_array_256(3,:),'-g');
% plot(dist_array_256(4,:),p_array_256(4,:),'-m');
% plot(dist_array_256(5,:),p_array_256(5,:),'-c');
% plot(dist_array_256(6,:),p_array_256(6,:),'-b');
% plot(dist_array_256(7,:),p_array_256(7,:),'-y');
xlabel('Avg Distortion (%)');
ylabel('Avg Power savings (%)');
title('Power savings vs distortion 256x256 - histogram equalization');
% lgd = legend('1','2','3','4','5','6','7');
% hold off


%% Value scale

current_avg_power_saving = 0.0;
current_avg_distortion = 0.0;
avg_power_saving = [];
avg_distortion = [];

for k = 1:-0.1:0
    for i = 1:8
        if i<8  % 256x256 images are only 7, skip last iteration
            B_256 = image_value_scale(A_256(:,:,:,i),k);
            %compute power and distortion for 256x256 images c
            p_img_256 = image_power(A_256(:,:,:,i));
            p_reduced_256 = image_power(B_256); 
%             p_diff_256 = p_img_256 - p_reduced_256;
            pow_saving_256 = ((p_img_256 - p_reduced_256)*100)/p_img_256;
    
            %store into the power array the normalized difference 256x256
            current_avg_power_saving = current_avg_power_saving + pow_saving_256;
            current_avg_distortion = current_avg_distortion + image_distortion(A_256(:,:,:,i),B_256);
        end

        B_512 = image_value_scale(A_512(:,:,:,i),k);
        %compute power and distortion for 512x512 images
        p_img_512 = image_power(A_512(:,:,:,i));
        p_reduced_512 = image_power(B_512); 
%         p_diff_512 = p_img_512 - p_reduced_512;
        pow_saving_512 = ((p_img_512 - p_reduced_512)*100)/p_img_512;

        %store into the power array the normalized difference 512x512
        current_avg_power_saving = current_avg_power_saving + pow_saving_512;
        current_avg_distortion = current_avg_distortion + image_distortion(A_512(:,:,:,i),B_512);
    end

    current_avg_power_saving = current_avg_power_saving/15;
    current_avg_distortion = current_avg_distortion/15;
    avg_power_saving = [avg_power_saving;current_avg_power_saving];
    avg_distortion = [avg_distortion;current_avg_distortion];

end

plot(avg_distortion, avg_power_saving,'.-b');

%% Histogram equalization
current_avg_power_saving = 0.0;
current_avg_distortion = 0.0;
avg_power_saving = [];
avg_distortion = [];

for j = 2:1:10
    for k = 2:1:10
        for i = 1:8
            if i<8  % 256x256 images are only 7, skip last iteration
                B_256 = image_histogram_eq(A_256(:,:,:,i),j,k);
                %compute power and distortion for 256x256 images c
                p_img_256 = image_power(A_256(:,:,:,i));
                p_reduced_256 = image_power(B_256); 
    %             p_diff_256 = p_img_256 - p_reduced_256;
                pow_saving_256 = ((p_img_256 - p_reduced_256)*100)/p_img_256;
        
                %store into the power array the normalized difference 256x256
                current_avg_power_saving = current_avg_power_saving + pow_saving_256;
                current_avg_distortion = current_avg_distortion + image_distortion(A_256(:,:,:,i),B_256);
            end
    
            B_512 = image_histogram_eq(A_512(:,:,:,i),j,k);
            %compute power and distortion for 512x512 images
            p_img_512 = image_power(A_512(:,:,:,i));
            p_reduced_512 = image_power(B_512); 
    %         p_diff_512 = p_img_512 - p_reduced_512;
            pow_saving_512 = ((p_img_512 - p_reduced_512)*100)/p_img_512;
    
            %store into the power array the normalized difference 512x512
            current_avg_power_saving = current_avg_power_saving + pow_saving_512;
            current_avg_distortion = current_avg_distortion + image_distortion(A_512(:,:,:,i),B_512);
        end
    
        current_avg_power_saving = current_avg_power_saving/15;
        current_avg_distortion = current_avg_distortion/15;
        avg_power_saving = [avg_power_saving;current_avg_power_saving];
        avg_distortion = [avg_distortion;current_avg_distortion];
    
    end
end

plot(avg_distortion, avg_power_saving,'.-r');

% % plot distortion vs power saving graph - blue reduction 256x256
% figure(2)
% plot(dist_array_blue_256(1,:),p_array_blue_256(1,:),'-or');
% hold on
% plot(dist_array_blue_256(2,:),p_array_blue_256(2,:),'-o','Color','#7E2F8E');
% plot(dist_array_blue_256(3,:),p_array_blue_256(3,:),'-og');
% plot(dist_array_blue_256(4,:),p_array_blue_256(4,:),'-om');
% plot(dist_array_blue_256(5,:),p_array_blue_256(5,:),'-oc');
% plot(dist_array_blue_256(6,:),p_array_blue_256(6,:),'-ob');
% plot(dist_array_blue_256(7,:),p_array_blue_256(7,:),'-oy');
% xlabel('Distortion (%)');
% ylabel('Power savings (%)');
% title('Power savings vs distortion 256x256 - blue reduction');
% lgd = legend('1','2','3','4','5','6','7');
% title(lgd, 'Images (.tiff format)');
% grid on
% hold off
% 
% % plot distortion vs power saving graph 512x512
% figure(3)
% plot(dist_array_512(1,:),p_array_512(1,:),'-or');
% hold on
% plot(dist_array_512(2,:),p_array_512(2,:),'Color','#7E2F8E');
% plot(dist_array_512(3,:),p_array_512(3,:),'-g');
% plot(dist_array_512(4,:),p_array_512(4,:),'-m');
% plot(dist_array_512(5,:),p_array_512(5,:),'-c');
% plot(dist_array_512(6,:),p_array_512(6,:),'-b');
% plot(dist_array_512(7,:),p_array_512(7,:),'-y');
% plot(dist_array_512(8,:),p_array_512(8,:),'-k');
% xlabel('Distortion (%)');
% ylabel('Power savings (%)');
% title('Power savings vs distortion pareto graph 512x512');
% lgd = legend('8','9','10','11','12','13','14','15');
% title(lgd, 'Images (.tiff format)');
% grid on
% hold off
% 
% % plot distortion vs power saving graph - blue reduction 512x512
% figure(4)
% plot(dist_array_blue_512(1,:),p_array_blue_512(1,:),'-or');
% hold on
% plot(dist_array_blue_512(2,:),p_array_blue_512(2,:),'-o','Color','#7E2F8E');
% plot(dist_array_blue_512(3,:),p_array_blue_512(3,:),'-og');
% plot(dist_array_blue_512(4,:),p_array_blue_512(4,:),'-om');
% plot(dist_array_blue_512(5,:),p_array_blue_512(5,:),'-oc');
% plot(dist_array_blue_512(6,:),p_array_blue_512(6,:),'-ob');
% plot(dist_array_blue_512(7,:),p_array_blue_512(7,:),'-oy');
% xlabel('Distortion (%)');
% ylabel('Power savings (%)');
% title('Power savings vs distortion 512x512 - blue reduction');
% lgd = legend('8','9','10','11','12','13','14','15');
% title(lgd, 'Images (.tiff format)');
% grid on
% hold off
