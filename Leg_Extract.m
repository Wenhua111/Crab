function I_leg_out=Leg_Extract(I_Meat, I_crab_map)
I_leg_out = I_Meat;
I_leg_map = I_crab_map & (~I_Meat.map);
I_leg_out.map = I_leg_map;