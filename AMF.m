%Aptive Median Filter
function I_out=AMF(I,I_map)
height=size(I,1);
width=size(I,2);
I=double(I);
I_copy=I;
MAX_window_size =5;
for i=1:height
    for j=1:width
        if(I_map(i,j)~=0)
            for ii=1:MAX_window_size
                count=0;
                AMF_W=0;
                for iii=max(i-ii,1):min(i+ii,height)
                    for jjj=max(j-ii,1):min(j+ii,width)
                        if(I_map(iii,jjj)~=0)
                            count=count+1;
                            AMF_W(count) = I(iii,jjj);
                        end
                    end
                end
                sminw=min(AMF_W);
                smaxw=max(AMF_W);
                smedw=median(AMF_W);
                if((sminw<smedw)&&(smedw<smaxw))
                    if(~((I(i,j)>sminw)&&(I(i,j)<smaxw)))
                        I(i,j)=smedw;
                    end
                    break;
                end
            end
        end
    end
end
I_out=uint8(I);
                
                    
                
                