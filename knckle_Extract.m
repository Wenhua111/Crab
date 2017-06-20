function I_knckle = knckle_Extract(I_leg)
I_knckle = I_leg;
ROI = I_leg.a .* uint8(I_leg.map);
%A = BDND(ROI, I_leg_map, 100);
A = Augment(ROI, I_leg.map);
A = AMF(A, I_leg.map);

effective_num = nonzeros(A);
hist = zeros(256,1);
for ii=1:length(effective_num)
    hist(effective_num(ii)+1)=hist(effective_num(ii)+1)+1;
end
[hist_value,level_index]=max(hist);
level=(level_index-1+15)/256;
A_filter=im2bw(A,level);
I_knckle.map = A_filter;
