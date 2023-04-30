clear all

clc;

 

filepath='meteor.bmp';                                        %%图像名称与路径

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

sta=statistic(Image,Info);

[bsta,subimage]=balanced(Image,sta,Info);

set (gcf,'Position',[100 ,100 ,Width ,Height] );

imshow(uint8(subimage),'border','tight','initialmagnification','fit');   %%结果图像显示

F=getframe(gcf);

imwrite(F.cdata, 'C:\Users\Sebastian\Desktop\实验结果图像.bmp');

close;

x_axis=0:1:Info.NumColormapEntries-1;

bar(x_axis,sta);

xlabel('gray scale');

ylabel('number');

title('原始图像灰度直方图');

set(gca,'YLim',[0 Width*Height/50]);%X轴的数据显示范围

F=getframe(gcf);

imwrite(F.cdata, 'C:\Users\Sebastian\Desktop\原始图像灰度直方图.jpg');

close;

recount=array_shift(sta,bsta);

bar(x_axis,recount);

xlabel('gray scale');

ylabel('number');

title('结果图像灰度直方图');

set(gca,'YLim',[0 Width*Height/50]);%X轴的数据显示范围

F=getframe(gcf);

imwrite(F.cdata, 'C:\Users\Sebastian\Desktop\结果图像灰度直方图.jpg');

close;

function[count]=statistic(image,info)

    count=zeros(info.NumColormapEntries,1);

    for i=1:info.Height
        
        for j=1:info.Width
            
            count(image(i,j)+1)=count(image(i,j)+1)+1;
            
        end
        
    end
    
end
    
function[btrans,subimage]=balanced(image,count,info)

    bcount=zeros(info.NumColormapEntries,1);
    
    bcount(1)=count(1);
    
    for i=2:info.NumColormapEntries
        
        bcount(i)=bcount(i-1)+count(i);
        
    end
    
    [h,w]=size(image);
    
    btrans=round(bcount/(w*h)*(info.NumColormapEntries-1));
    
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
