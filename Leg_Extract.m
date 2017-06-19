function [I_leg_out, I_meat_out]=Leg_Extract(I_Meat, I_crab_map)
I_leg_out = I_Meat;
I_meat_out = I_Meat;
I_leg_map = I_crab_map & (~I_Meat.map);
I_leg_map = imfill(I_leg_map,'holes');
ROI = I_Meat.a .* uint8(I_leg_map);
%A = BDND(ROI, I_leg_map, 100);
A = Augment(ROI, I_leg_map);
I_meat_map = I_crab_map & (~I_leg_map);
I_leg_out.Augment = uint8(A);
I_leg_out.map = I_leg_map;
I_meat_out.map = I_meat_map;