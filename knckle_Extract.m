function I_knckle = knckle_Extract(I_leg, I_meat)
I_knckle = I_leg;
ROI = I_leg.a .* uint8(I_leg.map);
%A = BDND(ROI, I_leg_map, 100);
%A = Augment(ROI, I_leg.map);
I_knckle.A = ROI;
A = AMF(ROI, I_leg.map);
A = AMF(A, I_leg.map);
A = Augment(A, I_leg.map);
A = AMF(A, I_leg.map);
I_knckle.Aug = A;
count = 0;
effective_value = 0;
for i = 1 : I_leg.Height
    for j = 1 : I_leg.Width
        if(A(i,j)~= 0)
            count = count+1;
            effective_value(count) = A(i,j);
        end
    end
end
[idx, C] = kmeans(effective_value', 2);
if( C(1) > C(2) )
    type = 1;
else
    type = 2;
end
count = 0;
for i = 1 : I_leg.Height
    for j = 1 : I_leg.Width
        if(A(i,j)~= 0)
            count = count+1;
%             if(idx(count) == type)
            if(A(i,j) >= (C(type) - ((C(type) - C(2-mod(type-1,2)))*0.1)))
                I_knckle.map(i,j)=1;
            else
                I_knckle.map(i,j)=0;
            end
        end
    end
end

kernal = strel('disk', 4);
I_knckle.map = imclose(I_knckle.map, kernal);
%I_knckle.map = imdilate(I_knckle.map, kernal);
I_knckle.map = bwareaopen(I_knckle.map, 200);
I_knckle.map = imfill(I_knckle.map,'holes');

I_map_left = zeros(I_leg.Height,I_leg.Width);
I_map_left(floor(I_meat.center.y-4*I_meat.r/3):floor(I_meat.center.y+4*I_meat.r/3), 1:floor(I_meat.center.x)) = I_knckle.map(floor(I_meat.center.y-4*I_meat.r/3):floor(I_meat.center.y+4*I_meat.r/3), 1:floor(I_meat.center.x));
I_map_right = zeros(I_leg.Height,I_leg.Width);
I_map_right(floor(I_meat.center.y-4*I_meat.r/3):floor(I_meat.center.y+4*I_meat.r/3), floor(I_meat.center.x):end) = I_knckle.map(floor(I_meat.center.y-4*I_meat.r/3):floor(I_meat.center.y+4*I_meat.r/3), floor(I_meat.center.x):end);

sum_left=sum(sum(double(I_map_left)));
sum_right=sum(sum(double(I_map_right)));

if(sum_right>=sum_left)
    I_knckle.map(:,1:floor(I_meat.center.x)) = 0;
else
    I_knckle.map(:,floor(I_meat.center.x):end) = 0;
end
erode_kernal = strel('disk', 4);
I_knckle.map = imdilate(I_knckle.map, erode_kernal);
I_knckle.map = imfill(I_knckle.map,'holes');
%I_knckle.map = bwareaopen(I_knckle.map, 500);

% bw = I_knckle.map;
% bw_handle = regionprops(I_knckle.map,'Centroid', 'PixelList', 'Eccentricity');
% for ii=1:length(bw_handle)
%     pL = bw_handle(ii).PixelList;
%     center = bw_handle(ii).Centroid;
%     eccent = bw_handle(ii).Eccentricity;
%     x_c = center(1);
%     y_c = center(2);
%     x = pL(:,1);
%     y = pL(:,2);
%     ratio = (max(y)-min(y))/(max(x)-min(x));
%     count = 0;
%     if(~((max(y)>(I_meat.center.y - 4*I_meat.r/3)) && (min(y) < (I_meat.center.y + 4*I_meat.r/3))))  
%         for jj=1:length(x)
%             count = count+1;
%             bw(y(jj), x(jj)) = 0;
%         end
%     elseif(((y_c>(I_meat.center.y - 0.7*I_meat.r)) && (y_c<(I_meat.center.y + 0.7*I_meat.r))))
%         for jj=1:length(x)
%             count = count+1;
%             bw(y(jj), x(jj)) = 0;
%         end
% %     elseif(eccent > 0.67)
% %         for jj=1:length(x)
% %             count = count+1;
% %             bw(y(jj), x(jj)) = 0;
% %         end
% % %     elseif(abs(x_c - I_meat.center.x) < 0.7*I_meat.r)
% % %         for jj=1:length(x)
% % %             count = count+1;
% % %             bw(y(jj), x(jj)) = 0;
% % %         end
%     end
% end
% % 
% % D = -bwdist(~I_knckle.map);
% % 
% % mask = imextendedmin(D,3);
% % D2 = imimposemin(D,mask);
% % Ld2 = watershed(D2);
% % 
% % I_knckle.map(Ld2 == 0) = 0;
% 
% 
% 
% 
%I_knckle.map = bw;