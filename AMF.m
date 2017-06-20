%Aptive Median Filter
function I_out=AMF(I,I_map)
height=size(I,1);
width=size(I,2);
I=double(I);
I_copy=I;
y_noise=zeros(height,width);
MAX_window_size = 5;
for ii=1:height
    for jj=1:width
        if(I_map(ii,jj)~=0)
            for i=1:MAX_window_size
                count=1;
                window=0;
                for iii=max(ii-2,1):min(ii+2,height)
                    for jjj=max(jj-2,1):min(jj+2,width)
                        if(I_map(iii,jjj)~=0)
                            window(count) = I(iii,jjj);
                            count=count+1;
                        end
                    end
                end
                sminw=min(window);
                smaxw=max(window);
                smedw=median(window);
                if((sminw<smedw)&&(smedw<smaxw))
                    if((I(ii,jj)>sminw)&&(I(ii,jj)<smaxw))
                        y_noise(ii,jj)=0;
                    else
                        y_noise(ii,jj)=1;
                        I_copy(ii,jj)=smedw;
                    end
                    break;
                end
%                 if(i==MAX_window_size)
%                     I_copy(ii,jj)=smedw;
%                 end
            end
        end
    end
end
I_out=uint8(I_copy);
noise_candidate=y_noise;
                
                    
                
                