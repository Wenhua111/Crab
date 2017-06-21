function I_knckle = knckle_Extract(I_leg, I_meat)
I_knckle = I_leg;
ROI = I_leg.a .* uint8(I_leg.map);
%A = BDND(ROI, I_leg_map, 100);
%A = Augment(ROI, I_leg.map);
A = AMF(ROI, I_leg.map);
A = AMF(A, I_leg.map);
A = Augment(A, I_leg.map);
A = AMF(A, I_leg.map);
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
    type_1 = 1;
    type_2 = 2;
else
    type_1 = 2;
    type_2 = 1;
end
count = 0;
for i = 1 : I_leg.Height
    for j = 1 : I_leg.Width
        if(A(i,j)~= 0)
            count = count+1;
            if(idx(count) == type_1)
            %if((C(type_1) - 0.1*(C(type_1) - C(type_2)))  < A(i,j))
                I_knckle.map(i,j)=1;
            else
                I_knckle.map(i,j)=0;
            end
        end
    end
end
I_map_left = zeros(I_meat.Height,I_meat.Width);
I_map_left((I_meat.center.y-1.3*I_meat.r):(I_meat.center.y+1.3*I_meat.r), 1:I_meat.center.x) = I_knckle.map((I_meat.center.y-1.3*I_meat.r):(I_meat.center.y+1.3*I_meat.r), 1:I_meat.center.x);
I_map_right = zeros(I_meat.Height,I_meat.Width);
I_map_right((I_meat.center.y-1.3*I_meat.r):(I_meat.center.y+1.3*I_meat.r), I_meat.center.x:end) = I_knckle.map((I_meat.center.y-1.3*I_meat.r):(I_meat.center.y+1.3*I_meat.r), I_meat.center.x:end);
I_out_left = double(I_map_left).*I_knckle.map;
I_out_right = double(I_map_right).*I_knckle.map;
sum_left=sum(sum(double(I_out_left)));
sum_right=sum(sum(double(I_out_right)));

if(sum_right>=sum_left)
    I_knckle.map(:,1:I_meat.center.x) = 0;
else
    I_knckle.map(:,I_meat.center.x:end) = 0;
end
I_knckle.map = bwareaopen(I_knckle.map, 200);

% kernal = strel('disk', 6);
% I_knckle.map = imdilate(I_knckle.map, kernal);
% I_knckle.map = bwareaopen(I_knckle.map, 300);
% I_knckle.map = imfill(I_knckle.map,'holes');


% I_knckle.map = bwareaopen(I_knckle.map, 300);
I_knckle.map((I_meat.center.y - 0.6*I_meat.r):(I_meat.center.y + 0.6*I_meat.r),:)=0;
I_knckle.map((I_meat.center.y + 1.6*I_meat.r):end,:)=0;
I_knckle.map(1:(I_meat.center.y - 1.6*I_meat.r),:)=0;
I_knckle.map(:,(I_meat.center.x - 0.6*I_meat.r):(I_meat.center.x + 0.6*I_meat.r))=0;

% I_knckle.map = bwareaopen(I_knckle.map, 300);
% erode_kernal = strel('disk', 3);
% I_knckle.map = imdilate(I_knckle.map, erode_kernal);
% I_knckle.map = bwareaopen(I_knckle.map, 300);


bw = I_knckle.map;
bw_handle = regionprops(bw, 'Centroid', 'PixelList','Eccentricity','MajorAxisLength','MinorAxisLength','Area');
for i = 1:length(bw_handle)
    region_center = bw_handle(i).Centroid;
    eccent = bw_handle(i).Eccentricity;
    PL = bw_handle(i).PixelList;
    x = PL(:,1);
    y = PL(:,2);
    area =  bw_handle(i).Area;
    long_axis = bw_handle(i).MajorAxisLength;
    short_axis = bw_handle(i).MinorAxisLength;
    ratio = (1*area)/(pi*long_axis*short_axis);
    if((region_center(1) < (I_meat.center.x + 0.7*I_meat.r)) && (region_center(1) > (I_meat.center.x - 0.7*I_meat.r)))
        for ii = 1:length(x)
            bw(y,x) = 0;
        end
    end
    if((region_center(2) < (I_meat.center.y + 0.6*I_meat.r)) && (region_center(2) > (I_meat.center.y - 0.6*I_meat.r)))
        for ii = 1:length(x)
            bw(y,x) = 0;
        end
    end
%     if(ratio > 0.7)
%         for ii = 1:length(x)
%             bw(y,x) = 0;
%         end
%     end
end
 
I_knckle.map = bw;
kernal = strel('disk', 5);
I_knckle.map = imdilate(I_knckle.map, kernal);

bw = I_knckle.map;
D = -bwdist(~bw);
mask = imextendedmin(D,2);
D2 = imimposemin(D,mask);
Ld = watershed(D2);
bw(Ld == 0) = 0;
I_knckle.map = bw;
kernal = strel('disk', 5);
I_knckle.map = imerode(I_knckle.map, kernal);
I_knckle.map = bwareaopen(I_knckle.map, 200);

bw = I_knckle.map;
bw_handle = regionprops(bw, 'Centroid', 'PixelList','Eccentricity','MajorAxisLength','MinorAxisLength','Area');
for i = 1:length(bw_handle)
    region_center = bw_handle(i).Centroid;
    eccent = bw_handle(i).Eccentricity;
    PL = bw_handle(i).PixelList;
    x = PL(:,1);
    y = PL(:,2);
    area =  bw_handle(i).Area;
    long_axis = bw_handle(i).MajorAxisLength;
    short_axis = bw_handle(i).MinorAxisLength;
    ratio = (1*area)/(pi*long_axis*short_axis);
    if((region_center(1) < (I_meat.center.x + 0.7*I_meat.r)) && (region_center(1) > (I_meat.center.x - 0.7*I_meat.r)))
        for ii = 1:length(x)
            bw(y,x) = 0;
        end
    end
    if((region_center(2) < (I_meat.center.y + 0.7*I_meat.r)) && (region_center(2) > (I_meat.center.y - 0.7*I_meat.r)))
        for ii = 1:length(x)
            bw(y,x) = 0;
        end
    end
    if(eccent > 0.9)
        for ii = 1:length(x)
            bw(y,x) = 0;
        end
    end
end
I_knckle.map = bw;
I_knckle.map = bwareaopen(I_knckle.map, 200);
% 
% 
% 
% 
% I_knckle.map = bw;
% I_knckle.map = bwareaopen(I_knckle.map, 300);