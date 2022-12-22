function[eq_image] = image_histogram_eq(img_RGB, j, k)
    % converts RGB image to HSV space
    img_HSV = rgb2hsv(img_RGB);

    %% performs histogram equalization on the whole image
    %   (!! causes very bad color distortion !!)
%     img_HSV = histeq(img_HSV);

    %%  Contrast-limited adaptive histogram equalization (CLAHE)
    %   Much better than previous, but distortion  above 5% on avg
%     V = img_HSV(:,:,3);
%     V = histeq(V);
%     img_HSV(:,:,3) = V;

    %%  Contrast-limited adaptive histogram equalization (CLAHE)
    %   Best histogram equalization solution, distortion around 3% on avg,
    %       color scheme close to original, sometimes the final image is
    %       perceived even better than the original.
    V = img_HSV(:,:,3);
    V = adapthisteq(V, "NumTiles",[j k]);
    img_HSV(:,:,3) = V;


    % converts image back to RGB 0-255 and returns it
    eq_image = uint8(hsv2rgb(img_HSV)*255);

end