%%%%%%%%% Ricardo Fitas, 2018 %%%%%%%%%%
%%% Main script




clc
clear
close all

v4= input('numero de manchas principais: ','s');
if ~strcmp(v4,'all')
    v4=str2num(v4);
end
M_total=[];
M_total_1=[];
M_total_2=[];
for a=1:3
    linha=[];
    linha_2=[];
    linha_3=[];
%v1=input('kernel: ');
%v2=input('standard deviation: ');

%F=imread('Bif7_transv3.png');

switch a
    case 1
        F_1=dicomread('IM_0016');
        l_1=30;
        l_2=10;
    case 2
        F_1=dicomread('IM_0019');
        l_1=90;
        l_2=30;
    case 3
        F_1=dicomread('IM_0021');
        l_1=30;
        l_2=10;
end
F_1=F_1(108:555,132:670,:,:);

for b=1:size(F_1,4)
%for l_2=10:2:30
    Figura_101= F_1(:,:,1,b);
    Figura_101(Figura_101==254)=0;
    %figure(1), imshow(Figura_101), title('Original image');

gss=fspecial('gaussian',[l_1 l_1],l_2);
Figura_102= imfilter(Figura_101, gss);

Vetor=reshape(Figura_101,1,size(Figura_101,1)*size(Figura_101,2));
Vetor=sort(Vetor);
Vetor=Vetor(:,1:uint8(0.05*length(Vetor)));
l_3=Vetor(end);
%Luminance=0.299*Figura_101+0.587*Figura_101+0.114*Figura_101;
Luminance=0.299*Figura_101+0.587*Figura_101+0.114*Figura_101;
Luminance(Luminance>0)=255;
%figure(3), imshow(Luminance), title('Two toned image');
%imshow(Figura_101);
comprimento= size(F_1,2);
altura= size(F_1,1);

Matriz_x=[1 1];
m=1;

while size(Matriz_x,1) ~= 0
    [Matriz_x , Matriz_y, Soma_pontos, cinzentos, numero]=segmentar(Luminance);
    Matriz_xr= reshape(Matriz_x,1,size(Matriz_x,1)*size(Matriz_x,2));
    Matriz_yr= reshape(Matriz_y,1,size(Matriz_y,1)*size(Matriz_y,2));
    Matriz1= Matriz_xr(find(Matriz_xr));
    Matriz2= Matriz_yr(find(Matriz_yr));

    Matriz=[Matriz1;Matriz2];
    
    for i=1:(size(Matriz,2)-1)
        Luminance(Matriz(2,i),Matriz(1,i))=255;
    end
    for i=1:size(Matriz,2)
    F_1(Matriz(2,i),Matriz(1,i),1,b)=0;
    F_1(Matriz(2,i),Matriz(1,i),2,b)=255; 
    F_1(Matriz(2,i),Matriz(1,i),3,b)=0;
    end
    figure(m), imshow(F_1(:,:,:,b))
    pause();
    m=m+1;
end

[E, MR, Ir, Ir_2, distance, Media_x, Media_raios, Media_y]=deal(zeros(1,size(Matriz_x,2)));

dist_max=sqrt((comprimento/2)^2+(altura/2)^2);

for i=1:size(Matriz_x,2)
    dist=[];
    Media_x(i)=mean(Matriz_x(find(Matriz_x(:,i)),i));
    Media_y(i)=mean(Matriz_y(find(Matriz_y(:,i)),i));    
    Raios=sqrt((Matriz_x(find(Matriz_x(:,i)),i)-Media_x(i)).^2+(Matriz_y(find(Matriz_y(:,i)),i)-Media_y(i)).^2);
    Media_raios(i)=mean(Raios);
    MR(i)=mean(Media_raios(i)./(abs(Media_raios(i)-Raios)+Media_raios(i)));
    Matriz_x_d=Matriz_x(find(Matriz_x(:,i)),i)';
    Matriz_y_d=Matriz_y(find(Matriz_y(:,i)),i)';
    Ir(i)=Soma_pontos(i)*(1/((2*min(Raios))-1/(2*max(Raios)))+1);
    Ir_2(i)=sqrt((Media_raios(i)/min([comprimento/2, altura/2])))*(1-1/(2*min(Raios))+1/(2*max(Raios)));
    %Ir(i)=max(Raios);
    %Ir_2(i)=sqrt((Soma_pontos(i)/max(Soma_pontos)))*(1-1/(2*min(Raios))+1/(2*max(Raios)));
    distance(i)=sqrt((comprimento/2-Media_x(i))^2+(altura/2-Media_y(i))^2);
end

Matriz_x=[Soma_pontos;Media_raios; Media_x; Matriz_x];
Matriz_y=[Soma_pontos;Media_raios; Media_x; Matriz_y];
Matriz_x = sortrows(Matriz_x',1)';
Matriz_y = sortrows(Matriz_y',1)';
tamanho=size(Matriz_x,2);
if tamanho==1
    Matriz_x=[zeros(size(Matriz_x,1),2) Matriz_x];
    Matriz_y=[zeros(size(Matriz_x,1),2) Matriz_y];
    Matx=Matriz_x(1:3,(end-v4+1):end);
    Maty=Matriz_y(1:3,(end-v4+1):end);
else
    if tamanho==2
        Matriz_x=[zeros(size(Matriz_x,1),1) Matriz_x];
        Matriz_y=[zeros(size(Matriz_x,1),1) Matriz_y];
        Matx=Matriz_x(1:3,(end-v4+1):end);
        Maty=Matriz_y(1:3,(end-v4+1):end);
    else
        if ~strcmp(v4,'all')            
            Matx=Matriz_x(1:3,(end-v4+1):end);
            Maty=Matriz_y(1:3,(end-v4+1):end);
        end
    end
end
%MR_total=[MR_total Matx(:,end)]
%E_total=[E_total Matx(:,(end-1))]

if strcmp(v4,'all')
    Matriz_x = Matriz_x(5:end,:);
    Matriz_y = Matriz_y(5:end,:);
else
    
        Matriz_x = Matriz_x(5:end,(end-v4+1):end);
        Matriz_y = Matriz_y(5:end,(end-v4+1):end);
    
end


if tamanho==1
    Matriz_x=Matriz_x(:,end);
    Matriz_y=Matriz_y(:,end);
else
    if tamanho==2
       Matriz_x=Matriz_x(:,(end-1):end);
       Matriz_y=Matriz_y(:,(end-1):end);
    end
end

mancha=[Matriz_x(:,end) Matriz_y(:,end)];

Matriz_xr= reshape(Matriz_x,1,size(Matriz_x,1)*size(Matriz_x,2));
Matriz_yr= reshape(Matriz_y,1,size(Matriz_y,1)*size(Matriz_y,2));
Matriz1= Matriz_xr(find(Matriz_xr));
Matriz2= Matriz_yr(find(Matriz_yr));

Matriz=[Matriz1;Matriz2];

Numero_de_manchas=nnz(Matriz_x);

for i=1:size(Matriz,2)
    F_1(Matriz(2,i),Matriz(1,i),1,b)=0;
    F_1(Matriz(2,i),Matriz(1,i),2,b)=255; 
    F_1(Matriz(2,i),Matriz(1,i),3,b)=0;
end

figure(9), imshow(F_1(:,:,:,b))
pause();

for j=1:comprimento
    for k=1:altura
        if Luminance(k,j)~=150
            F_1(k,j,:,b)=Figura_101(k,j);
        end
    end
end

% figure(6), imshow(insertShape(F_1(:,:,:,b), 'circle', [Matx(4,end) Maty(4,end) Matx(3,end)], 'LineWidth', 3, 'Color', 'blue')); 
% linha=[linha Matx(:,end)];
% linha_2=[linha_2 Matx(:,(end-1))];
% linha_3=[linha_3 Matx(:,(end-2))];
end
% M_total(:,:,a)=linha;
% M_total_1(:,:,a)=linha_2;
% M_total_2(:,:,a)=linha_3;
end
