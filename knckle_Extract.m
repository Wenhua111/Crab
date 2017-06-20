function I_knckle = knckle_Extract(I_leg)
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
    type = 1;
else
    type = 2;
end
count = 0;
for i = 1 : I_leg.Height
    for j = 1 : I_leg.Width
        if(A(i,j)~= 0)
            count = count+1;
            if(idx(count) == type)
                I_knckle.map(i,j)=1;
            else
                I_knckle.map(i,j)=0;
            end
        end
    end
end

kernal = strel('disk', 4);
I_knckle.map = imclose(I_knckle.map, kernal);
I_knckle.map = bwareaopen(I_knckle.map, 150);
I_knckle.map = imfill(I_knckle.map,'holes');
%I_knckle.map = I_knckle.map & (~ bwareaopen(I_knckle.map, 1000));

% 
% effective_num = nonzeros(A);
% hist = zeros(256,1);
% for ii=1:length(effective_num)
%     hist(effective_num(ii)+1)=hist(effective_num(ii)+1)+1;
% end
% [hist_value,level_index]=max(hist);
% level=(level_index)/256;
% A_filter=im2bw(A,level);
%I_knckle.map = A;
