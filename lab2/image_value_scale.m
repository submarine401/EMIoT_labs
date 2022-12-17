function[vs_image] = image_value_scale(img_RGB, k)
    % checks that k is a valid coefficient: 0 <= k <= 1
    if k<0 || k>1
        error("Bad k coefficient, must be between 0 and 1")
    end

    % converts RGB image to HSV space
    img_HSV = rgb2hsv(img_RGB);

    % extracts Value matrix from image
    V = img_HSV(:,:,3);
    % applies scaling factor to Value matrix
    V = k*V;
    % substitutes modified Value matrix back into image
    img_HSV(:,:,3) = V;

    % converts image back to RGB 0-255 and returns it
    vs_image = uint8(hsv2rgb(img_HSV)*255);

end