clear all

clc;

 

filepath='Img_Denoise.bmp';                                        %%图像名称与路径

Info=imfinfo(filepath);                                     %%获取图片信息并判断是否为bmp

bmp='bmp';

format=Info.Format;

if  (strcmp(format ,bmp)==0)

    disp('载入的不是tif图像，请确认载入的数据');                  

end 

Width=Info.Width;

Height=Info.Height;

Image=zeros(Height,Width);

Image(:,:)=imread(filepath);                                  %%读入图像

%m=[1,2,1;2,3,2;1,2,1];
%m=ones(3,3);
m=ones(5,5);

Subimage=rectMF(Image,m,Info);

set (gcf,'Position',[500 ,500 ,Width ,Height] );

imshow(uint8(Subimage),'border','tight','initialmagnification','fit');

F=getframe(gcf);

imwrite(F.cdata, 'C:\Users\Sebastian\Desktop\61518218沈书杨3.bmp');

function[subimage]=rectMF(image,m,info)

    subimage=zeros(size(image));
    
    sl=length(m);
    
    for i=(sl+1)/2:info.Height-(sl+1)/2+1
        
        for j=(sl+1)/2:info.Width-(sl+1)/2+1
        
            subimage(i,j)=Mselect(image,m,i,j);
        
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
