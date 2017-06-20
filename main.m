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
    I_knckle = knckle_Extract(I_leg, I_meat);
    
    
%     
%     
%     D = -bwdist(~I_knckle.map);
% 
%     mask = imextendedmin(D,2);
%     D2 = imimposemin(D,mask);
%     Ld2 = watershed(D2);
% 
%     bw3 = I_knckle.map;
%     bw3(Ld2 == 0) = 0;
%     bw4= bw3;
%     
%     bw3_handle=regionprops(bw3,'Centroid', 'PixelList');
%     
% 
%     
%     for ii=1:length(bw3_handle)
%         pL = bw3_handle(ii).PixelList;
%         center = bw3_handle(ii).Centroid;
%         x_c = center(1);
%         y_c = center(2);
%         x = pL(:,1);
%         y = pL(:,2);
%         ratio = (max(y)-min(y))/(max(x)-min(x));
%         count = 0;
%         if(~((max(y)>(I_meat.center.y - 1.25*I_meat.r)) && (min(y) < (I_meat.center.y + 1.25*I_meat.r))))  
%             for jj=1:length(x)
%                 count = count+1;
%                 bw4(y(jj), x(jj)) = 0;
%             end
%         elseif(((y_c>(I_meat.center.y - 0.7*I_meat.r)) && (y_c<(I_meat.center.y + 0.7*I_meat.r))))
%             for jj=1:length(x)
%                 count = count+1;
%                 bw4(y(jj), x(jj)) = 0;
%             end
%         elseif((ratio>2) || (ratio<0.5))
%             for jj=1:length(x)
%                 count = count+1;
%                 bw4(y(jj), x(jj)) = 0;
%             end
%         end
%     end
%     bw4 = bwareaopen(bw4, 150);       
    
    
    %L=watershed(D);
    %rgb = label2rgb(L,'jet',[.5 .5 .5]);  
    %Lrgb = label2rgb(L);
    I_write = I_Raw.Raw.*uint8(I_knckle.map);
    for ii=1:I_Raw.Height
        for jj =1:I_Raw.Width
            if(I_knckle.map(ii,jj)==1)
                I_knckle.Raw(ii,jj,1) = 255;
                I_knckle.Raw(ii,jj,2) = 0;
                I_knckle.Raw(ii,jj,2) = 0;
            end
        end
    end
            
    figure(i)
    imshow(I_knckle.Raw)
%     figure(1)
%     imshow(I_Raw.Raw.*uint8(I_crab_body.map))
%     figure(2)
%     imshow(I_Raw.Raw.*uint8(I_meat.map))
%     figure(3)
%     imshow(I_Raw.Raw.*uint8(I_leg.map))
%     figure(4)
%     imshow(I_knckle.A)
%     figure(5)
%     imshow(I_knckle.Aug)
%     figure(6)
%     imshow(I_Raw.Raw.*uint8(bw4))
%     rgb = label2rgb(Ld2,'jet',[.5 .5 .5]);  
%     imshow(rgb,'InitialMagnification','fit')  
    %hold on
    %imcontour(D)
    %hold off
    imwrite(I_knckle.Raw, ['./knuckle/' file_name])
end