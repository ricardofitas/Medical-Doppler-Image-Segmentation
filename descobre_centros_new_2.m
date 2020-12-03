%%%%%%%% Ricardo Fitas, 2018 %%%%%%%
%%%%%% Finding centres method


function [centro,areas,evt,CCC,S]=descobre_centros_new_2(Luminance)
start=tic;
centro=[];
w=0;
[Matriz_x , Matriz_y, guardar_pontos,ev]=segmentar(Luminance,0,1,size(Luminance,2)*size(Luminance,1));
evt=ev;
S=size(guardar_pontos,2);
vet_ind=1:size(Matriz_x,2);
areas=zeros(3,size(vet_ind,2));
for i=1:size(Matriz_x,2)
    VX=Matriz_x(:,i);
    areas(1,i)=size(VX(VX~=0),1);
end
MatX=reshape(Matriz_x,1,size(Matriz_x,1)*size(Matriz_x,2));
MatY=reshape(Matriz_y,1,size(Matriz_y,1)*size(Matriz_y,2));
Matriz=[MatX(MatX~=0);MatY(MatY~=0)];
for i=1:size(Matriz,2)
    Luminance(Matriz(2,i),Matriz(1,i))=255;
end
Mx=[vet_ind; Matriz_x];
My=[vet_ind; Matriz_y];

while S>0
    w=w+1;
    [Matriz_x , Matriz_y, guardar_pontos,ev]=segmentar(Luminance,0,1,S(end));
    evt=[evt ev];
    S=[S size(guardar_pontos,2)];
    MatX=reshape(Matriz_x,1,size(Matriz_x,1)*size(Matriz_x,2));
    MatY=reshape(Matriz_y,1,size(Matriz_y,1)*size(Matriz_y,2));
    Matriz=[MatX(MatX~=0);MatY(MatY~=0)];
    for i=1:size(Matriz,2)
        Luminance(Matriz(2,i),Matriz(1,i))=150;
    end    
    
    Matriz_x=[zeros(1,size(Matriz_x,2));Matriz_x];
    Matriz_y=[zeros(1,size(Matriz_y,2));Matriz_y];
    
    for f=1:size(Matriz_x,2)
        
        conjunto_seguinte=[];
        VX=Matriz_x(2:end,f); VY=Matriz_y(2:end,f);
        VX(VX==0)=[]; VY(VY==0)=[];
        segmentados=[VX VY]';       
        
        
        for j=1:size(segmentados,2)
            %             if S>0
            AB=find(abs(segmentados(1,j)-guardar_pontos(1,:))<=1 & abs(segmentados(2,j)-guardar_pontos(2,:))<=1);
            conjunto_seguinte=[conjunto_seguinte guardar_pontos(:,AB)];
            guardar_pontos(:,AB)=[];
            %             end
        end
           c=1;
           d=1;
           while c<=size(Mx,2) && d<=size(segmentados,2)
               Vx=Mx(2:end,c)'; Vy=My(2:end,c)';
               Vx(Vx==0)=[]; Vy(Vy==0)=[];
               Ab=find(abs(segmentados(1,d)-Vx)<=1 & abs(segmentados(2,d)-Vy)<=1,1);
               if isempty(Ab)==false
                   Matriz_x(1,f)=Mx(1,c);
                   c=size(Mx,2);
                   d=size(segmentados,2);
               end
               if c==size(Mx,2)
                    d=d+1;
                    c=1;
               else
                   c=c+1;
               end
           end
           if isempty(conjunto_seguinte)
            centro=[centro, [Matriz_x(1,f);w;round(mean(segmentados(1,:))); round(mean(segmentados(2,:)))]];
            
           end
           areas(1,Matriz_x(1,f))=areas(1,Matriz_x(1,f))+size(VX,1);
           
    end

    vet_ind=Matriz_x(1,:);
  
    Mx=Matriz_x;
    My=Matriz_y;
    
    for i=1:size(Matriz,2)
        Luminance(Matriz(2,i),Matriz(1,i))=255;
    end
end

for i=1:size(areas,2)
    XX=find(centro(1,:)==i);
    [Xmed,Ymed]=deal(0);
    for j=1:length(XX)
        Xmed=Xmed+centro(3,XX(j))*centro(2,XX(j))^2;
        Ymed=Ymed+centro(4,XX(j))*centro(2,XX(j))^2;
    end
    SOMA=sum(centro(2,XX).^2);
    if SOMA==0
        areas(2,i)=centro(3,i);
        areas(3,i)=centro(4,i);
    else
        areas(2,i)=Xmed/SOMA;
        areas(3,i)=Ymed/SOMA;
    end
end

CCC=toc(start);
end