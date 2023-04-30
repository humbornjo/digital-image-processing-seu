clear all
clc;
filepath='segImg.bmp';                                        %%图像名称与路径
Info=imfinfo(filepath);                                     %%获取图片信息并判断是否为bmp
bmp='bmp';
format=Info.Format;
if  (strcmp(format ,bmp)==0)
    disp('载入的不是bmp图像，请确认载入的数据');                  
end 
Width=Info.Width;
Height=Info.Height;
Image=zeros(Height,Width);
Image(:,:)=imread(filepath);                                  %%读入图像

scale=512;
d=region_div(Image,scale);%scale可选择256，512等
imshow(d,'border','tight','initialmagnification','fit');%注释此行可以查看阈值矩阵
%imwrite(d, 'C:\Users\Sebastian\Desktop\61518218沈书杨.bmp');


function[thresholding] = ostu_method(Image)
    [h,w] = size(Image);
    min_gray =min(min(Image));                                              
    max_gray =max(max(Image));
    pro = zeros(max_gray-min_gray+1,1); %直方图计算
    for i=1:h
        for j=1:w
            pro(Image(i,j)+1-min_gray) = pro(Image(i,j)+1-min_gray)+1;
        end
    end
    pro=pro/(h*w);
    k = min_gray;
    result = zeros(max_gray-min_gray+1,1);
    while (k<=max_gray) 
        %k分割的两个类的出现概率
        p0 = sum(pro(min_gray-min_gray+1:k-min_gray+1));
        p1 = sum(pro(k-min_gray+1:max_gray-min_gray+1));
        %计算两个类的均值
        mu0 = 0;
        mu1 = 0;
        for i=min_gray:k
            mu0 = mu0 + i*pro(i+1-min_gray)/p0;
        end
        for i=k:max_gray 
            mu1 = mu1 + i*pro(i+1-min_gray)/p1;
        end
        %计算两个类的方差
        sigma0=0;
        sigma1=0;
        for i=min_gray:k
            sigma0 = sigma0 + (i-mu0)^2*pro(i+1-min_gray)/p0;
        end  
        for i=k:max_gray 
            sigma1 = sigma1 + (i-mu1)^2*pro(i+1-min_gray)/p1;
        end
        result(k-min_gray+1)=sqrt(sigma0)*p0+sqrt(sigma1)*p1;
        k=k+1;
    end
    temp_t=find(result == min(result));%经过实践，存在多个阈值的情况，这里取平均
    thresholding =sum(temp_t)/length(temp_t)+min_gray-1;
end

function[dived]=region_div(Image,scale)
    [Height,Width]=size(Image);
    I=round(imresize(Image,[scale scale],'bilinear'));%经过双线性插值，需要做四舍五入
    thres=zeros(15);
    for i=0:14
        for j=0:14
            region = imcrop(I,[1+j*scale/16 1+i*scale/16 scale/8-1 scale/8-1]);%按照scale设置区域大小、步长(区域裁剪左上坐标先列后行)
            thres(i+1,j+1)=ostu_method(region);%用大津阈值算法得出区域阈值
        end
    end
    all_thres=imresize(thres,[Height Width],'bilinear');%双线性插值缩放还原原图大小
    imshow(uint8(all_thres))
    dived=zeros(Height,Width);
    for i=1:Height
        for j=1:Width
            if (Image(i,j)>=all_thres(i,j))
                dived(i,j)=1;
            end
        end
    end
end

