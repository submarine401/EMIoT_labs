function[d_image] = image_distortion(img1_RGB,img2_RGB)
   img1_Lab = rgb2lab(img1_RGB);
   img2_Lab = rgb2lab(img2_RGB);

   L = (img1_Lab(:,:,1)-img2_Lab(:,:,1)).^2;
   a = (img1_Lab(:,:,2)-img2_Lab(:,:,2)).^2;
   b = (img1_Lab(:,:,3)-img2_Lab(:,:,3)).^2;
   epsilon = sum(sum(sqrt(L + a + b)));

   %normalization
   dimensions = size(L);
   H = dimensions(1);
   W = dimensions(2);
   norm_factor = W*H*sqrt(100^2+2*255^2);

   d_image = epsilon/norm_factor * 100;

end

%%  Comments
%   This function as is works pretty well in terms of final
%   perceived image. However, sometimes the image distortion is
%   our limit of 3%.