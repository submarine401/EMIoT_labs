%% Pareto curve average distortion vs saved power
%  taken the RGB representation of the img, the script
%  computes the saved power for different approaches
%  together with the average distortion
%  results are plotted in a graph

%first attempt: use the image_reduce_blue.m script
%compute number of images in the directory
a = dir(['images.tar' '/*.tiff']);
n=numel(a);
A = zeros(512,512,3,15);
B = zeros(512,512,3);
p_array=zeros(8,10);
dist_array = zeros(8,10);

%store RGB representation of all images in an array

for i = 1:8
    i_str = num2str(i+7);
    C= [i_str,'.tiff'];
    A(:,:,:,i) = imread(C);
    A=cast(A,'uint8');
    
    j=1;

   for k = 0.1:0.1:1
   B = image_reduce_blue(A(:,:,:,i),k);
   %compute power and distortion
   p_img = image_power(A(:,:,:,i));
   p_reduced = image_power(B); 
   p_diff = p_img - p_reduced;

   %store into the power array the normalized difference
   p_array(i,j) = (p_diff*100)/p_img;
   dist_array(i,j) = image_distortion(A(:,:,:,i),B);
   j= j+1;

   end
end

%apply the blue reduction on the image
j = 1; 
plot(dist_array(1,:),p_array(1,:),'-or');
hold on
plot(dist_array(2,:),p_array(2,:),'-o','Color','#7E2F8E');
plot(dist_array(3,:),p_array(3,:),'-og');
plot(dist_array(4,:),p_array(4,:),'-om');
plot(dist_array(5,:),p_array(5,:),'-oc');
plot(dist_array(6,:),p_array(6,:),'-ob');
plot(dist_array(7,:),p_array(7,:),'-oy');
plot(dist_array(8,:),p_array(8,:),'-ok');
xlabel('Distortion (%)');
ylabel('Power savings (%)');
title('Power savings vs distortion pareto graph');
lgd = legend('8','9','10','11','12','13','14','15');
title(lgd, 'Images (.tiff format)');
grid on
hold off
