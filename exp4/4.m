
clear all

clc;

 

filepath='cameraman.tif';                                        %%图像名称与路径

Info=imfinfo(filepath);                                     %%获取图片信息并判断是否为tif

tif='tif';

format=Info.Format;

if  (strcmp(format ,tif)==0)

    disp('载入的不是tif图像，请确认载入的数据');                  %%确保载入的图像是tiff图像

end 

Slice=size(Info,1);                                            %%获取图片z向帧数

Width=Info.Width;

Height=Info.Height;

Image=zeros(Height,Width,Slice);

angel=pi/6; 

r=3;

for i=1:Slice

    Image(:,:,i)=imread(filepath,i);                                  %%一层一层的读入图像

end

subimage=rotation(Image,Height,Width,angel);

rsubimage=rescale(subimage,Height,Width,r);

set (gcf,'Position',[500 ,500 ,256 ,256] );

imshow(uint8(rsubimage),'border','tight','initialmagnification','fit');

F=getframe(gcf);

imwrite(F.cdata, 'C:\Users\Sebastian\Desktop\61518218沈书杨.tif');

close;

function[grey_scale]=linear(ima,x,y)

    if(x==fix(x) && y==fix(y))       
            
        grey_scale=ima(x,y);
            
    elseif(x~=fix(x) && y==fix(y))
                  
        grey_scale=(x-fix(x))*ima(ceil(x),y)+(ceil(x)-x)*ima(fix(x),y);
        
    elseif(x==fix(x) && y~=fix(y))
    
        grey_scale=(y-fix(y))*ima(x,ceil(y))+(ceil(y)-y)*ima(x,fix(y));
            
    else
        
        grey_scale=(x-fix(x))*(ceil(y)-y)*ima(ceil(x),fix(y))+(ceil(x)-x)*(ceil(y)-y)*ima(fix(x),fix(y))+(x-fix(x))*(y-fix(y))*ima(ceil(x),ceil(y))+(ceil(x)-x)*(y-fix(y))*ima(fix(x),ceil(y));
    
    end

end

function[subima]=rotation(ima,height,width,an)

    subima=zeros(height,width);
    
    center=[(1+width)/2;(1+height)/2];
    
    for i=1:height
        
        for j=1:width
            
            ox=[cos(an),-sin(an)]*([j;i]-center)+(1+width)/2;
            
            oy=[sin(an),cos(an)]*([j;i]-center)+(1+height)/2;

            if(ox<=width && ox>=1 && oy<=height && oy>=1)
                
                subima(j,i)=linear(ima,ox,oy);
                
            elseif(fix(ox)==width && ceil(oy)~=1)
                
                subima(j,i)=(ceil(ox)-ox)*(ceil(oy)-oy)*ima(fix(ox),fix(oy))+(ceil(ox)-ox)*(oy-fix(oy))*ima(fix(ox),ceil(oy));
            
            elseif(fix(oy)==width && ceil(ox)~=1)
                
                subima(j,i)=(ceil(ox)-ox)*(ceil(oy)-oy)*ima(fix(ox),fix(oy))+(ox-fix(ox))*(ceil(oy)-oy)*ima(ceil(ox),fix(oy));
                
            elseif(ceil(ox)==1 && ceil(oy)~=1)
                
                subima(j,i)=(ox-fix(ox))*(ceil(oy)-oy)*ima(ceil(ox),fix(oy))+(ox-fix(ox))*(oy-fix(oy))*ima(ceil(ox),ceil(oy));
            
            elseif(ceil(oy)==1 && ceil(ox)~=1)
                
                subima(j,i)=(ceil(ox)-ox)*(oy-fix(oy))*ima(fix(ox),ceil(oy))+(ox-fix(ox))*(oy-fix(oy))*ima(ceil(ox),ceil(oy));
                
            else
                
                subima(j,i)=0;
                
            end
            
        end
        
    end
    
end

function[subima]=rescale(ima,height,width,re)

    subima=zeros(height,width);
    
    center=[(1+width)/2;(1+height)/2];
    
    for i=1:height
        
        for j=1:width
            
            ox=[1/re,0]*([j;i]-center)+(1+width)/2;
            
            oy=[0,1/re]*([j;i]-center)+(1+height)/2;
                
            subima(j,i)=linear(ima,ox,oy);
                            
        end
        
    end

end

