clc
close all
clear all
for i=1:25
    file_name = [num2str(i) '.tif'];
    I_Raw = imread(['./crab_body/' file_name]);
    width = size(I_Raw, 2);
    height = size(I_Raw,1);
    I_R = I_Raw(:,:,1);
    I_G = I_Raw(:,:,2);
    I_B = I_Raw(:,:,3);
    I_map = I_R | I_G | I_B;
    I_map = double(I_map);

    
    I_HSV = rgb2hsv(I_Raw);
    I_H = I_HSV(:,:,1);
    I_S = I_HSV(:,:,2);
    I_V = I_HSV(:,:,3);
    
    
    cform=makecform('srgb2lab');
    I_Lab=applycform(I_Raw,cform);
    I_Lab=double(I_Lab).*double(I_map);
    I_Lab=uint8(I_Lab);
    L = I_Lab(:,:,1);
    A = I_Lab(:,:,2);
    B = I_Lab(:,:,3);
    %figure(i)
    level=graythresh(nonzeros(L));
    L_filter=im2bw(L,level);
    count=0;
    x_sum = 0;
    y_sum = 0;
    for ii=1:height
        for jj=1:width
            if(L_filter(ii,jj)~=0)
                count=count+1;
                x_sum = x_sum + jj;
                y_sum = y_sum + ii;
            end
        end
    end
    x_avg=floor(x_sum/count);
    y_avg=floor(y_sum/count);
    center_line_y = L_filter(floor(y_avg), :);
    minx=find(center_line_y,1,'first');
    maxx=find(center_line_y,1,'last');
    r=(maxx-minx)*1/2;
    I_circle_filter=zeros(height,width);
    for ii=1:height
        for jj=1:width
            r_temp=sqrt(((ii-y_avg)^2)/((1.3*r)^2) + ((jj-x_avg)^2)/((1*r)^2));
            if((r_temp>=1)&&(I_map(ii,jj)~=0))
                I_circle_filter(ii,jj)=1;
            end 
        end
    end
    %imshow(L_filter)
    I_new_map = I_map & I_circle_filter;
    I_out=BDND(A,I_map,100);
    I_out=I_out.*I_new_map; 
    I_out=Augment(I_out,I_new_map);
    
    
    
    
    %I_out=BDND(I_out,I_map,240);
    I_out=AMF(I_out,I_new_map);
    %I_out=I_out.*uint8(I_circle_filter);
    I_out=I_out.*I_new_map;
    I_out=uint8(I_out);
    
    effective_num = nonzeros(I_out);
    
    hist = zeros(256,1);
    for ii=1:length(effective_num)
        hist(effective_num(ii)+1)=hist(effective_num(ii)+1)+1;
    end
    [hist_value,level_index]=max(hist);
%    figure(i+25)
%    plot(0:255,hist)
    level=(level_index-1+15)/256;
    
    
    
    
    %imshow(uint8(I_out))
%     I_map_left = zeros(height,width);
%     I_map_left((y_avg-0.5*r):(y_avg+0.5*r), 1:x_avg) = I_new_map((y_avg-0.5*r):(y_avg+0.5*r), 1:x_avg);
%     I_map_right = zeros(height,width);
%     I_map_right((y_avg-0.5*r):(y_avg+0.5*r), x_avg:end) = I_new_map((y_avg-0.5*r):(y_avg+0.5*r), x_avg:end);
%     
%     I_out_left = uint8(I_map_left).*I_out;
%     I_out_right = uint8(I_map_right).*I_out;
%     sum_left=sum(sum(double(I_out_left)));
%     avg_left=sum_left/sum(sum(I_map_left));
%     sum_right=sum(sum(double(I_out_right)));
%     avg_right=sum_right/sum(sum(I_map_right));
%     if(avg_right>=avg_left)
%         I_out(:,1:x_avg) = 0;
%     else
%         I_out(:,x_avg:end) = 0;
%     end
    
%     count=0;
%     kmeans_data=0;
%     for ii=1:height
%         for jj=1:width
%             if(I_out(ii,jj)~=0)
%                 count=count+1;
%                 kmeans_data(count)=I_out(ii,jj);
%             end
%         end
%     end
%     [kmeans_idx,kmeans_center]=kmeans(kmeans_data',2);
%     count=0;
%     I_kmeans_out=zeros(height,width);
%     for ii=1:height
%         for jj=1:width
%             if(I_out(ii,jj)~=0)
%                 count=count+1;
%                 std_idx = 2;
%                 if(kmeans_center(1)>kmeans_center(2))
%                     std_idx = 1;
%                 end
%                 if(kmeans_idx(count)==std_idx)
%                     I_kmeans_out(ii,jj)=1;
%                 end
%             end
%         end
%     end
        
%     I_out=double(I_out).*I_kmeans_out;

    I_out=double(I_out).*(im2bw(I_out,level));
    
    


    I_out=double(I_out);
    I_map_left = zeros(height,width);
    I_map_left((y_avg-1.3*r):(y_avg+1.3*r), 1:x_avg) = I_new_map((y_avg-1.3*r):(y_avg+1.3*r), 1:x_avg);
    I_map_right = zeros(height,width);
    I_map_right((y_avg-1.3*r):(y_avg+1.3*r), x_avg:end) = I_new_map((y_avg-1.3*r):(y_avg+1.3*r), x_avg:end);
    
    I_out_left = double(I_map_left).*I_out;
    I_out_right = double(I_map_right).*I_out;
    sum_left=sum(sum(double(I_out_left)));
%     num_left=sum(sum(I_map_left));
%     avg_left=0;
%     if(num_left~=0)
%         avg_left=sum_left/num_left;
%     end
    sum_right=sum(sum(double(I_out_right)));
%     avg_right=sum_right/sum(sum(I_map_right));
%     num_right=sum(sum(I_map_right));
%     avg_right=0;
%     
%     if(num_left~=0)
%         avg_left=sum_left/num_left;
%     end
    if(sum_right>=sum_left)
        I_out(:,1:x_avg) = 0;
    else
        I_out(:,x_avg:end) = 0;
    end

    I_final_map = I_out&ones(height,width);
    I_final_map = imfill(I_final_map, 'holes');
    I_final_map = bwareaopen(I_final_map,100);
    figure(i)
    imshow(I_final_map)
%     D = bwdist(~I_final_map);
%     D = -D;
%     D(~I_final_map) = Inf;
%     L = watershed(D);
%     L(~I_final_map) = 0;
%     rgb = label2rgb(L,'jet',[.5 .5 .5]);
%     figure(i)
%     imshow(rgb,'InitialMagnification','fit')
    final_map(i,:,:) = I_final_map;
end