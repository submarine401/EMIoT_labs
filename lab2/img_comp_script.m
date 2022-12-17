%%  Image Histogram Equalization in HSV space
%   Simple script to apply a transformation to an image,
%   plot the original and the modified version, and print key figures.
%   The user simply needs to manually specify the image path.

clear
clc
i1_orig = imread("images.tar/4.2.06.tiff");
% Histogram equalization
i1_mod = image_reduce_blue(i1_orig, 0.9);  % uncomment to enable
% Histogram equalization
%i1_mod = image_histogram_eq(i1_orig);  % uncomment to enable
% HSV Value matrix scaling
%i1_mod = image_value_scale(i1_orig, 0.861); % uncomment to enable
imshowpair(i1_orig,i1_mod,'montage')
distortion = image_distortion(i1_orig, i1_mod)
orig_power = image_power(i1_orig)
hieq_power = image_power(i1_mod)
