clear all
clc;
filepath='segImg.bmp';                                        %%ͼ��������·��
Info=imfinfo(filepath);                                     %%��ȡͼƬ��Ϣ���ж��Ƿ�Ϊbmp
bmp='bmp';
format=Info.Format;
if  (strcmp(format ,bmp)==0)
    disp('����Ĳ���bmpͼ����ȷ�����������');                  
end 
Width=Info.Width;
Height=Info.Height;
Image=zeros(Height,Width);
Image(:,:)=imread(filepath);                                  %%����ͼ��

scale=512;
d=region_div(Image,scale);%scale��ѡ��256��512��
imshow(d,'border','tight','initialmagnification','fit');%ע�ʹ��п��Բ鿴��ֵ����
%imwrite(d, 'C:\Users\Sebastian\Desktop\61518218������.bmp');


function[thresholding] = ostu_method(Image)
    [h,w] = size(Image);
    min_gray =min(min(Image));                                              
    max_gray =max(max(Image));
    pro = zeros(max_gray-min_gray+1,1); %ֱ��ͼ����
    for i=1:h
        for j=1:w
            pro(Image(i,j)+1-min_gray) = pro(Image(i,j)+1-min_gray)+1;
        end
    end
    pro=pro/(h*w);
    k = min_gray;
    result = zeros(max_gray-min_gray+1,1);
    while (k<=max_gray) 
        %k�ָ��������ĳ��ָ���
        p0 = sum(pro(min_gray-min_gray+1:k-min_gray+1));
        p1 = sum(pro(k-min_gray+1:max_gray-min_gray+1));
        %����������ľ�ֵ
        mu0 = 0;
        mu1 = 0;
        for i=min_gray:k
            mu0 = mu0 + i*pro(i+1-min_gray)/p0;
        end
        for i=k:max_gray 
            mu1 = mu1 + i*pro(i+1-min_gray)/p1;
        end
        %����������ķ���
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
    temp_t=find(result == min(result));%����ʵ�������ڶ����ֵ�����������ȡƽ��
    thresholding =sum(temp_t)/length(temp_t)+min_gray-1;
end

function[dived]=region_div(Image,scale)
    [Height,Width]=size(Image);
    I=round(imresize(Image,[scale scale],'bilinear'));%����˫���Բ�ֵ����Ҫ����������
    thres=zeros(15);
    for i=0:14
        for j=0:14
            region = imcrop(I,[1+j*scale/16 1+i*scale/16 scale/8-1 scale/8-1]);%����scale���������С������(����ü������������к���)
            thres(i+1,j+1)=ostu_method(region);%�ô����ֵ�㷨�ó�������ֵ
        end
    end
    all_thres=imresize(thres,[Height Width],'bilinear');%˫���Բ�ֵ���Ż�ԭԭͼ��С
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

