% Image preprocessing
function I_class = Image_Preprocessing(I)
if(size(I, 1) > size(I, 2))
    I_class.Raw = imrotate(I, 90);
else
    I_class.Raw = I;
end
I_class.Height = size(I_class.Raw, 1);
I_class.Width = size(I_class.Raw, 2);

I_class.Raw = double(I_class.Raw);
gausefilter = fspecial('gaussian',[3 3],1);
I_class.Raw = imfilter(I_class.Raw,gausefilter,'replicate');
I_class.Raw = uint8(I_class.Raw);

I_class.R = I_class.Raw(:,:,1);
I_class.G = I_class.Raw(:,:,2);
I_class.B = I_class.Raw(:,:,3);

I_HSV = rgb2hsv(I_class.Raw);
I_class.H = I_HSV(:,:,1);
I_class.S = I_HSV(:,:,2);
I_class.V = I_HSV(:,:,3);

cform = makecform('srgb2lab');
I_Lab = applycform(I_class.Raw, cform);
I_class.L = I_Lab(:,:,1);
I_class.a = I_Lab(:,:,2);
I_class.b = I_Lab(:,:,3);

I_class.map = ones(I_class.Height, I_class.Width); % to describe our interesting area