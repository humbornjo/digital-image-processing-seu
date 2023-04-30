clear all

clc;

 

filepath='OUT_DR4.TIF';                                        %%图像名称与路径

Info=imfinfo(filepath);                                     %%获取图片信息并判断是否为TIF

tif='tif';

format=Info.Format;

if  (strcmp(format ,tif)==0)

    disp('载入的不是tif图像，请确认载入的数据');                  

end 

Width=Info.Width;

Height=Info.Height;

Image=zeros(Height,Width);

Image(:,:)=imread(filepath);                                  %%读入图像

%imshow(uint8(to_ewl(Image,Info)));

% count=statistic(Image,Info);
% 
% sta=balanced(Image,count);
% 
% imshow(uint8(to_ewl(sta,Info)))
% 
imwrite(uint8(to_ewl(Image,Info)), 'C:\Users\Sebastian\Desktop\4.bmp')
% Image=to_ewl(Image,Info);
% 
% figure(1),subplot(121),imshow(uint8(Image));title('填充后的图像')
% 
% I1=log(Image+1);    %取对数
% 
% FI=fft2(I1);    %傅里叶变换 
% 
% figure(2),subplot(122),imshow(uint8(FI));title('填充后的图像')
% rL=0.25;    
% rH=2.2;     % 可根据需要效果调整参数 
% c=2.0;       %锐化参数
% D0=20;
% n1=floor(P/2); 
% n2=floor(Q/2);
% for u=1:P 
%     for v=1:Q 
%         D(u,v)=sqrt(((u-n1).^2+(v-n2).^2));  %频率域中点（u，v）与频率矩形中心的距离       
%         H(u,v)=(rH-rL).*(1-exp(-c.*(D(u,v)^2./D0^2)))+rL; %高斯同态滤波 
%     end
% end
% H=ifftshift(H);  %对H做反中心化
% I3=ifft2(H.*FI);  %傅里叶逆变换
% I4=real(I3); 
% I5 =I4(1:M, 1:N);  %截取一部分
% I6=exp(I5)-1;  %取指数
% figure(1),subplot(122),imshow(uint8(I6));title('同态滤波增强后');

%imshow(uint8(to_ewl(Image,Info)));
% m=ones(3,3);
% Image=rectMF(Image,m,Info);
% 
% m_g=[1,2,1;2,4,2;1,2,1]/16;
% 
% m_lap=[0,1,0;1,-4,1;0,1,0];
% 
% m_sob=[1,2,1;0,0,0;-1,-2,-1];
% 
% m_sob_=[1,0,-1;2,0,-2;1,0,-1];
% m1=[1,2,0;2,0,-2;0,-2,-1];
% m2=[0,2,1;-2,0,2;-1,-2,0];
% 
% 
% m_w=[0,0,0;0,-1,0;0,0,1];
% 
% 
% laplacian_image=kernel(Image,m_lap,Info);
% 
% sob_image=kernel(Image,m_sob,Info);
% 
% sob_image_=kernel(Image,m_sob_,Info);
% t1_image=kernel(Image,m1,Info);
% t2_image=kernel(Image,m2,Info);
% f2=Image-(sob_image+sob_image_)/2;
% 
% f1=Image-(sob_image+sob_image_);
% 
% t1=Image-t1_image;
% t2=Image-t2_image;
% f3=Image-(sob_image+sob_image_+t1_image+t2_image)/2;
% f4=Image-(sob_image+sob_image_+t1_image+t2_image);
% 
% imwrite(uint8(to_ewl(Image-laplacian_image,Info)), 'C:\Users\Sebastian\Desktop\after.bmp');
function[sub_image]=to_ewl(image,Info)

    sub_image=zeros(Info.Height,Info.Width);

    for i=1:Info.Height
    
        for j=1:Info.Width
                
            sub_image(i,j)=idivide(image(i,j), int32(16));
            
        end
                
    end  

end

function[subimage]=rectMF(image,m,info)

    subimage=zeros(size(image));
    
    sl=length(m);
    
    for i=(sl+1)/2:info.Height-(sl+1)/2+1
        
        for j=(sl+1)/2:info.Width-(sl+1)/2+1
        
            subimage(i,j)=Medselect(image,m,i,j);
        
        end
        
    end

end

function[med]=Mselect(image,m,h,w)

    sl=length(m);

    med_matrix=zeros(sl,sl);
    
    for i=1:sl
       
        for j=1:sl
            
            med_matrix(i,j)=image(h+(i-(sl+1)/2),w+(j-(sl+1)/2));
        
        end
        
    end
    
    for i=1:sl
        
        for j=1:sl
            
            med_matrix(i,j)=med_matrix(i,j)*m(i,j);
            
        end
        
    end
    
    med=sum(sum(med_matrix));
    
end

function[subarray]=my_sort(array)

    my_bool=0;

    for i=1:length(array)-1
    
        for j=1:length(array)-1
        
            temp=array(j);
        
            if array(j+1)<array(j)
            
                array(j)=array(j+1);
            
                array(j+1)=temp;
                
                my_bool=1;
        
            end
        
        end
        
        if my_bool==0
            
            break;
            
        end
        
    end  
    
    subarray=array;

end

function[subimage]=kernel(image,m,info)

    subimage=zeros(size(image));
    
    sl=length(m);
    
    for i=(sl+1)/2:info.Height-(sl+1)/2+1
        
        for j=(sl+1)/2:info.Width-(sl+1)/2+1
        
            subimage(i,j)=Mselect(image,m,i,j);
        
        end
        
    end

end

function[med]=Medselect(image,m,h,w)

    sl=length(m);

    med_matrix=zeros(sl,sl);
    
    for i=1:sl
       
        for j=1:sl
            
            med_matrix(i,j)=image(h+(i-(sl+1)/2),w+(j-(sl+1)/2));
        
        end
        
    end
    
    m_to_a=reshape(m,sl*sl,1);
    
    med_array = zeros(sum(sum(m)),1);
    
    for i=1:sl*sl
        
        for j=1:m(i)
            
            med_array(sum(m_to_a(1:i-1))+j)=med_matrix(i);
            
        end
        
    end
    
    med_array=my_sort(med_array);
    
    if mod(length(med_array),2)==0
    
        med = med_array(length(med_array)/2);
    
    else
        
        med = med_array((length(med_array)+1)/2);
        
    end

end

function[count]=statistic(image,info)

    count=zeros(4096,1);

    for i=1:info.Height
        
        for j=1:info.Width
            
            count(image(i,j)+1)=count(image(i,j)+1)+1;
            
        end
        
    end
    
end
    
function[subimage]=balanced(image,count)

    bcount=zeros(4096,1);
    
    bcount(1)=count(1);
    
    for i=2:4096
        
        bcount(i)=bcount(i-1)+count(i);
        
    end
    
    [h,w]=size(image);
    
    btrans=round(bcount/(w*h)*4096);
    
    subimage=zeros(size(image));
    
    for i=1:h
        
        for j=1:w
        
            subimage(i,j)=btrans(image(i,j)+1);
        
        end
        
    end

end

function[res_count]=array_shift(count,trans_array)

    res_count=zeros(size(count));
    
    for i=1:length(count)
       
        res_count(trans_array(i)+1)=res_count(trans_array(i)+1)+count(i);
        
    end

end
