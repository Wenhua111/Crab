clc
close all
clear all
for i=1:25
    i
    file_name = [num2str(i) '.tif'];
    I_Raw = imread(['./RawImage/' file_name]);
    I_Raw = Image_Preprocessing(I_Raw); % Change to Class I_Raw, which includes Height, Width, RGB, HSV, Lab, ROI map
    I_crab_body = Crab_Extract(I_Raw);
    I_meat = Meat_Extract(I_crab_body);
    I_leg = Leg_Extract(I_meat, I_crab_body.map);
    I_knckle = knckle_Extract(I_leg, I_meat);
    I_write = uint8(I_knckle.map).*I_Raw.Raw;
    %figure(i)
    %imshow(I_leg.map)
    %imshow(uint8(I_knckle.map).*I_Raw.Raw);
    imwrite(I_write, ['./knuckle/' file_name])
    for ii=1:I_knckle.Height
        for jj=1:I_knckle.Width
            if(I_knckle.map(ii,jj)~=0)
                I_knckle.Raw(ii,jj,1) = 255;
                I_knckle.Raw(ii,jj,2) = 0;
                I_knckle.Raw(ii,jj,3) = 0;
            end
        end
    end
    %figure(i)
    %imshow(I_knckle.Raw)
    imwrite(I_knckle.Raw, ['./knuckle_label/' file_name])
end