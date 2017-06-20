clc
close all
clear all
for i=1:25
    file_name = [num2str(i) '.tif'];
    I_Raw = imread(['./RawImage/' file_name]);
    I_Raw = Image_Preprocessing(I_Raw); % Change to Class I_Raw, which includes Height, Width, RGB, HSV, Lab, ROI map
    I_crab_body = Crab_Extract(I_Raw);
    I_meat = Meat_Extract(I_crab_body);
    I_leg = Leg_Extract(I_meat, I_crab_body.map);
    I_knckle = knckle_Extract(I_leg);
    I_write = uint8(I_knckle.map).*I_Raw.Raw;
    %figure(i)
    %imshow(I_leg.map)
    %imshow(uint8(I_knckle.map).*I_Raw.Raw);
    imwrite(I_write, ['./knuckle/' file_name])
end