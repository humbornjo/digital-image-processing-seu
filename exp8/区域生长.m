clear all

clc;

 

filepath='segImg.bmp';                                        %%ͼ��������·��

Info=imfinfo(filepath);                                     %%��ȡͼƬ��Ϣ���ж��Ƿ�Ϊbmp

bmp='bmp';

format=Info.Format;

if  (strcmp(format ,bmp)==0)

    disp('����Ĳ���tifͼ����ȷ�����������');                  

end 

Width=Info.Width;

Height=Info.Height;

Image=zeros(Height,Width);

Image(:,:)=imread(filepath);                                  %%����ͼ��
Image=mat2gray(Image);
a=seeding_way(Image,40);
imshow(a)
function[I]=seeding_way(Image,k)
    [M,N]=size(Image);
    I=zeros(M,N);
    for i=1:k+1
        for j=1:k+1
            h=round(1+(i-1)*((M-1)/k));
            w=round(1+(j-1)*((N-1)/k));
            if I(h,w)==1
            else
                I=I+growing_way(Image,h,w);
            end
        end
    end
end
function[b_matrix]=growing_way(Image,h,w)
    I=mat2gray(Image);
    [M,N]=size(I);
    seed=I(h,w); %��ȡ�������ػҶ�ֵ
    b_matrix=zeros(M,N);
    b_matrix(h,w)=1;
    count=1; %����������
    threshold=0.25;
    d=0;
    while count>0
        d=d+1;
        if d>30
            b_matrix=zeros(M,N);
            break
        end
        count=0;
        for i=1:M %��������ͼ��
        for j=1:N
            if b_matrix(i,j)==1 %���ڡ�ջ����
            if (i-1)>1&(i+1)<M&(j-1)>1&(j+1)<N %3*3������ͼ��Χ��
                for u=-1:1 %8-��������
                for v=-1:1
                    if b_matrix(i+u,j+v)==0&abs(I(i+u,j+v)-seed)<=threshold
                        b_matrix(i+u,j+v)=1;
                        count=count+1;  %��¼�˴��������ĵ����
                    end
                end
                end
            end
            end
        end
        end
    end
end

