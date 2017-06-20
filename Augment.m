%Augment
%input:gray scale image
function I_out = Augment(I,I_map)
height=size(I,1);
width=size(I,2);
I=double(I);
I_copy=I;
beta = 20;
level=nonzeros(I);
level=sort(level);
level_1 = level(floor(end*0.8));
level_2 = level(floor(end*0.2));

for i=1:height
    for j=1:width
        if((I_map(i,j)~=0)&&((I(i,j)>level_1)||(I(i,j)<level_2)))
                W=0;
                count = 0;
                for ii=max(i-2,1):min(i+2,height) 
                    for jj=max(j-2,1):max(j+2,width)
                        if((I_map(ii,jj)~=0))
                            count=count+1;
                            W(count) = I(ii,jj);
                        end
                    end
                end
                U=mean(W);
                U=1-U/256;
                I_pixel = 1-I(i,j)/256;
                I_copy(i,j)=256*(1-exp((1+beta)*(log(I_pixel)-log(U)) + log(U)));
        end
    end
end            
I_out=I_copy;