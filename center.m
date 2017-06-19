% find central gravity 
% input binary
function center_point = center(I)
I = double(I);
height = size(I, 1);
width = size(I, 2);
sum_x = 0;
sum_y = 0;
count = 0;
for i=1:height
    for j=1:width
        if(I(i,j)~=0)
            sum_x = sum_x + j;
            sum_y = sum_y + i;
            count = count + 1;
        end
    end
end
center_point.x = sum_x / count;
center_point.y = sum_y / count;