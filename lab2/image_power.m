function [p_image] = image_power(img_RGB) 
    gamma = 0.7755;
    w = [2.13636845e-07, 1.77746705e-07, 2.14348309e-07];
    w0 = 1.48169521e-06;
    %A = imread(image_name);
    %imshow(A);
    
    R = img_RGB(:,:,1);
    G = img_RGB(:,:,2);
    B = img_RGB(:,:,3);
    
    R_double = cast(R,"double");
    R_gamma = R_double.^(gamma);
    
    G_double = cast(G,"double");
    G_gamma = G_double.^(gamma);
    
    B_double = cast(B,"double");
    B_gamma = B_double.^(gamma);
    
    p_image = w0 + sum(w(1)*sum(R_gamma)) + sum(w(2)*sum(G_gamma)) + sum(w(3)*sum(B_gamma));

end