
clc;

clear all;

close all;

filepath='DR4.TIF';                                        %%ͼ��������·��

Info=imfinfo(filepath);                                     %%��ȡͼƬ��Ϣ���ж��Ƿ�ΪTIF

tif='tif';

format=Info.Format;

if  (strcmp(format ,tif)==0)

    disp('����Ĳ���tifͼ����ȷ�����������');                  

end 

Width=Info.Width;

Height=Info.Height;

I=zeros(Height,Width);

I(:,:)=imread(filepath);                                  %%����ͼ��

%����ͼ�񣬲�ת��Ϊdouble��

I_D=im2double(I);

%���ͼ��ĸ߶ȺͿ��

[M,N]=size(I_D);

%ͼ�����ĵ�

M0=M/2;

N0=N/2;

%%-------------��Ƶ�����˲�

J=fft2(I_D);

J_shift=fftshift(J);

D0=10;  %ȡֵ��С������ϸ��

delta=D0;

for x=1:M

    for y=1:N

        %����㣨x,y�������ĵ�ľ���

        d2=(x-M0)^2+(y-N0)^2;

        %�����˹�˲���

        h=1-exp(-d2/(2*delta^2));

        %���˲�������������

        J_shift(x,y)=J_shift(x,y)*h;

    end

end 

J=ifftshift(J_shift);

I_D_rep=ifft2(J);

homo=real(I_D_rep);

homo=standard(I+homo);

%%----------�ڿռ�������ֵ�˲�

m=[1,2,1;2,3,2;1,2,1];

s=rectMF(homo,m,Info);

imwrite(uint16(s), 'C:\Users\Sebastian\Desktop\OUT_DR4.TIF');


function[sub_image]=to_ewl(image)

    [h,w]=size(image);

    sub_image=zeros(h,w);

    for i=1:h
    
        for j=1:w
                
            sub_image(i,j)=idivide(image(i,j), uint32(16));
            
        end
                
    end  

end  %ת��256�Ҷȼ�

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

function[subimage]=kernel(image,m)

    subimage=zeros(size(image));
    
    sl=length(m);
    
    [h,w]=size(image);
    
    for i=(sl+1)/2:h-(sl+1)/2+1
        
        for j=(sl+1)/2:w-(sl+1)/2+1
        
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

function[sub_image]=standard(image)

    [h,w]=size(image);

    sub_image=round(image);

    for i=1:h
    
        for j=1:w
            
            if sub_image(i,j)<0
            
                sub_image(i,j)=0;
                
            elseif sub_image(i,j)>4095
                
                sub_image(i,j)=4095;
                
            end
            
        end
                
    end  

end
