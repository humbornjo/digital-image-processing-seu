clear all

clc;

filepath='DR1.TIF';                                        %%图像名称与路径

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

m_sob=[1,2,1;0,0,0;-1,-2,-1];

m_sob_=[1,0,-1;2,0,-2;1,0,-1];

m_sob_t=[1,2,0;2,0,-2;0,-2,-1];

m_sob_t_=[0,2,1;-2,0,2;-1,-2,0];

m=[1,2,1;2,3,2;1,2,1];

sob_image=kernel(Image,m_sob,Info);

sob_image_=kernel(Image,m_sob_,Info);

sob_image_t=kernel(Image,m_sob_t,Info);

sob_image_t_=kernel(Image,m_sob_t_,Info);

f=Image-(sob_image+sob_image_+sob_image_t+sob_image_t_)/1.5;

s=rectMF(f,m,Info);

stan=standard(s,Info);

imwrite(uint16(stan), 'C:\Users\Sebastian\Desktop\OUT_DR1.TIF')

function[sub_image]=to_ewl(image,Info)

    sub_image=zeros(Info.Height,Info.Width);

    for i=1:Info.Height
    
        for j=1:Info.Width
                
            sub_image(i,j)=idivide(image(i,j), int32(16));
            
        end
                
    end  

end  %转换256灰度级

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

function[sub_image]=standard(image,Info)

    sub_image=round(image);

    for i=1:Info.Height
    
        for j=1:Info.Width
            
            if sub_image(i,j)<0
            
                sub_image(i,j)=0;
                
            elseif sub_image(i,j)>4095
                
                sub_image(i,j)=4095;
                
            end
            
        end
                
    end  

end
