function [img_out] = image_reduce_blue(img_in, k)
    
    reduction_coefficient_B = k;
    reduction_coefficient_R = 1;
    reduction_coefficient_G = 1;
    
    R = img_in(:,:,1);
    G = img_in(:,:,2);
    B = img_in(:,:,3);
    R = R*reduction_coefficient_R;
    G = G*reduction_coefficient_G;
    B = B*reduction_coefficient_B;
    R = cast(R,"uint8");
    G = cast(G,"uint8");
    B = cast(B,"uint8");
    img_out(:,:,1) = R;
    img_out(:,:,2) = G;
    img_out(:,:,3) = B;
    %imshow(img_out);
    

end