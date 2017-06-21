% L filter to find the meat area
% method: otsu algorithm 
function I_class_out = Meat_Extract(I_class)
I_class_out = I_class;
L = I_class.L .* uint8(I_class.map);
level = graythresh(nonzeros(L));
I_meat_template = im2bw(L, level);
kernal = strel('disk', 4);
I_meat_template_temp = I_meat_template;
I_meat_template = imopen(I_meat_template, kernal);
I_meat_template = imfill(I_meat_template,'holes');
I_meat_template = bwareaopen(I_meat_template, 200);
meat_center = center(I_meat_template);
r= sqrt(sum(sum(I_meat_template)) / (pi*4/3));
I_circle_filter=zeros(I_class.Height,I_class.Width);
for i=1:I_class.Height
    for j=1:I_class.Width
        r_temp=sqrt(((i-meat_center.y)^2)/((4*r/3)^2) + ((j-meat_center.x)^2)/((1*r)^2));
        if((r_temp<=1))
            I_circle_filter(i,j)=1;
        end 
    end
end
I_meat_template = I_circle_filter | I_meat_template_temp;
I_class_out.map = I_meat_template;
I_class_out.center = meat_center;
I_class_out.r = r;

