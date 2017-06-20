%BDND
% google scholar: Ng, P. E., & Ma, K. K. (2006). A switching median filter with boundary discriminative noise detection for extremely corrupted images. IEEE Transactions on image processing, 15(6), 1506-1516.

function I_out = BDND(I,I_map,threshold)
height=size(I,1);
width=size(I,2);
I=double(I);
I=I;
for i=1:height
    for j=1:width
        if(I_map(i,j)~=0)
%             window_size = 7 ;
%             half_window_size = (window_size - 1)/2;
%             window=0;
%             count = 1;
%             for ii=max(i-half_window_size,1):min(i+half_window_size,height) 
%                 for jj=max(j-half_window_size,1):max(j+half_window_size,width)
%                     if(I_map(ii,jj)~=0)
%                         window(count)=I(ii,jj);
%                         count=count+1;
%                     end
%                 end
%             end
%             sort_window=sort(window);
%             medvalue = median(sort_window);
%             count_1 = 1;
%             window_1 = 0;
%             count_2 = 1;
%             window_2 = 0;
%             level_1=0;
%             level_2=0;
%             for ii=1:length(sort_window)
%                 if(sort_window(ii)<=medvalue)
%                     window_1(count_1)=sort_window(ii);
%                     count_1 = count_1+1;
%                 end
%                 if(sort_window(ii)>=medvalue)
%                     window_2(count_2)=sort_window(ii);
%                     count_2 = count_2+1;
%                 end
%             end
%             if(length(window_1)>1)
%                 VD_1 = window_1(2:end) - window_1(1:end-1);
%                 [b1,b1_index]=max(VD_1);
%                 level_1 = window_1(b1_index+1);
%             else
%                 level_1 = window_1(1);
%             end
% 
%             if(length(window_2)>1)
%                 VD_2 = window_2(2:end) - window_2(1:end-1);
%                 [b2,b2_index]=max(VD_2);
%                 level_2 = window_2(b2_index+1);
%             else
%                 level_2 = window_2(1);
%             end
%            
%             
%             if((I(i,j)>=level_2)||(I(i,j)<=level_1))
                window=0;
                count = 1;
                window = nonzeros(I(max(i-1,1):min(i+1,height),max(j-1,1):max(j+1,width)));
%                 for ii=max(i-1,1):min(i+1,height)
%                     for jj=max(j-1,1):max(j+1,width)
%                         if(I_map(ii,jj)~=0)
%                             window(count)=I(ii,jj);
%                             count=count+1;
%                         end
%                     end
%                 end
            if(std(window)>threshold)
                sort_window=sort(window);
                medvalue = median(sort_window);
                count_1 = 1;
                window_1 = 0;
                count_2 = 1;
                window_2 = 0;
                level_1=0;
                level_2=0;
                for ii=1:length(sort_window)
                    if(sort_window(ii)<=medvalue)
                        window_1(count_1)=sort_window(ii);
                        count_1 = count_1+1;
                    end
                    if(sort_window(ii)>=medvalue)
                        window_2(count_2)=sort_window(ii);
                        count_2 = count_2+1;
                    end
                end
                if(length(window_1)>1)
                    VD_1 = window_1(2:end) - window_1(1:end-1);
                    [b1,b1_index]=max(VD_1);
                    level_1 = window_1(b1_index+1);
                else
                    level_1 = window_1(1);
                end

                if(length(window_2)>1)
                    VD_2 = window_2(2:end) - window_2(1:end-1);
                    [b2,b2_index]=max(VD_2);
                    level_2 = window_2(b2_index+1);
                else
                    level_2 = window_2(1);
                end
                if((I(i,j)>=level_2)||(I(i,j)<=level_1))
                    I(i,j)=medvalue;
                end
            end
        end
    end
end
I_out=I;