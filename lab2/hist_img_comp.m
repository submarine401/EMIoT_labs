%%  Image Histogram Equalization in HSV space
%   Simple script to apply histogram equalization to an image and
%   print key figures by simply changing image path.

clear
clc
i1_orig = imread("images.tar/4.2.02.tiff");
i1_hieq = image_histogram_eq(i1_orig);
imshowpair(i1_orig,i1_hieq,'montage')
distortion = image_distortion(i1_orig, i1_hieq)
orig_power = image_power(i1_orig)
hieq_power = image_power(i1_hieq)
