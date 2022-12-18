%% Pareto curve average distortion vs saved power
%  taken the RGB representation of the img, the script
%  computes the saved power for different approaches
%  together with the average distortion
%  results are plotted in a graph

%first attempt: use the image_reduce_blue.m script
%compute number of images in the directory
a = dir(['images.tar' '/*.tiff']);
n=numel(a);
% data structures for 256x256 images
A_256 = zeros(256,256,3,15);
B_256 = zeros(256,256,3);
p_array_256=zeros(8,10);
dist_array_256 = zeros(8,10);
% data structures for 512x512 images
A_512 = zeros(512,512,3,8);
B_512 = zeros(512,512,3);
p_array_512=zeros(8,10);
dist_array_512 = zeros(8,10);

i_str = 'images.tar/';
for i = 1:8
    %store RGB representation of all images in an array
    if i<8  % 256x256 images are only 7, skip last iteration
        image_str= [i_str, num2str(i), '.tiff'];
        A_256(:,:,:,i) = imread(image_str);
        A_256=uint8(A_256);
    end
    image_str= [i_str, num2str(i+7), '.tiff'];
    A_512(:,:,:,i) = imread(image_str);
    A_512=uint8(A_512);
    
    %apply the blue reduction on the image
    j=1;

    for k = 0.1:0.1:1
        B_256 = image_reduce_blue(A_256(:,:,:,i),k);
        %compute power and distortion for 256x256 images
        p_img_256 = image_power(A_256(:,:,:,i));
        p_reduced_256 = image_power(B_256); 
        p_diff_256 = p_img_256 - p_reduced_256;

        B_512 = image_reduce_blue(A_512(:,:,:,i),k);
        %compute power and distortion for 512x512 images
        p_img_512 = image_power(A_512(:,:,:,i));
        p_reduced_512 = image_power(B_512); 
        p_diff_512 = p_img_512 - p_reduced_512;
        
        %store into the power array the normalized difference 256x256
        p_array_256(i,j) = (p_diff_256*100)/p_img_256;
        dist_array_256(i,j) = image_distortion(A_256(:,:,:,i),B_256);

        %store into the power array the normalized difference 512x512
        p_array_512(i,j) = (p_diff_512*100)/p_img_512;
        dist_array_512(i,j) = image_distortion(A_512(:,:,:,i),B_512);

        j= j+1;
    
    end
end

% plot distortion vs power saving graph 256x256
plot(dist_array_256(1,:),p_array_256(1,:),'-or');
hold on
plot(dist_array_256(2,:),p_array_256(2,:),'-o','Color','#7E2F8E');
plot(dist_array_256(3,:),p_array_256(3,:),'-og');
plot(dist_array_256(4,:),p_array_256(4,:),'-om');
plot(dist_array_256(5,:),p_array_256(5,:),'-oc');
plot(dist_array_256(6,:),p_array_256(6,:),'-ob');
plot(dist_array_256(7,:),p_array_256(7,:),'-oy');
xlabel('Distortion (%)');
ylabel('Power savings (%)');
title('Power savings vs distortion pareto graph 256x256');
lgd = legend('1','2','3','4','5','6','7');
title(lgd, 'Images (.tiff format)');
grid on
hold off

% plot distortion vs power saving graph 512x512
figure
plot(dist_array_512(1,:),p_array_512(1,:),'-or');
hold on
plot(dist_array_512(2,:),p_array_512(2,:),'-o','Color','#7E2F8E');
plot(dist_array_512(3,:),p_array_512(3,:),'-og');
plot(dist_array_512(4,:),p_array_512(4,:),'-om');
plot(dist_array_512(5,:),p_array_512(5,:),'-oc');
plot(dist_array_512(6,:),p_array_512(6,:),'-ob');
plot(dist_array_512(7,:),p_array_512(7,:),'-oy');
plot(dist_array_512(8,:),p_array_512(8,:),'-ok');
xlabel('Distortion (%)');
ylabel('Power savings (%)');
title('Power savings vs distortion pareto graph 512x512');
lgd = legend('8','9','10','11','12','13','14','15');
title(lgd, 'Images (.tiff format)');
grid on
hold off
