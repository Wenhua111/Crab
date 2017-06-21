% s filter to rule out the background
% method: otsu algorithm 
function I_class_out = Crab_Extract(I_class)
level = graythresh(I_class.S); % make use of otsu algorithm to find an adaptive threshold to rule out the background
I_class_out = I_class;
I_crab_template = im2bw(I_class.S, level);
% rule out the bolb to narrow
for i=1:I_class.Height
    for j=1:I_class.Width
        if(I_crab_template(i, j) == 1)
            if( sum(I_crab_template(i, max(j-5, 1):min(j+5, I_class.Width))) <= 5 )
                I_crab_template(i, j) = 0;
            end
        end
    end
end
for i=1:I_class.Height
    for j=1:I_class.Width
        if(I_crab_template(i, j) == 1)
            if( sum(I_crab_template(max(i-10, 1):min(i+10, I_class.Height), j)) <= 10 )
                I_crab_template(i, j) = 0;
            end
        end
    end
end

%find the largest one
I_S_binary_area_handle = regionprops(I_crab_template, 'area');
for i = 1:length(I_S_binary_area_handle)
    I_S_area(i) = I_S_binary_area_handle(i).Area;
end
I_crab_template = bwareaopen(I_crab_template, max(I_S_area));
erode_kernal = strel('disk', 4);
I_crab_template = imdilate(I_crab_template, erode_kernal);
%I_crab_template = imfill(I_crab_template,'holes');
I_class_out.map = I_crab_template;
      