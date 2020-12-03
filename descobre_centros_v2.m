%%%%%%% Ricardo Fitas, 2018 %%%%%%%%%%%%%
%%%%% find centres method %%%%%%





function [centro]=descobre_centros_new(Luminance,vet_ind)

guardar_pontos=[1 1];
centro=[];
m=1;
w=0;
while size(guardar_pontos,2)>0
    w=w+1;
    [Matriz_x , Matriz_y, guardar_pontos]=segmentar(Luminance,0,1);

    figure,imshow(Luminance);
    pause();
    i=1;
    [Mx,My]=deal([]);

    MatX=reshape(Matriz_x,1,size(Matriz_x,1)*size(Matriz_x,2));
    MatY=reshape(Matriz_y,1,size(Matriz_y,1)*size(Matriz_y,2));
    Matriz=[MatX(MatX~=0);MatY(MatY~=0)];
    
    for i=1:size(Matriz,2)
        Luminance(Matriz(2,i),Matriz(1,i))=150;
        
    end
    
    guardar_pontos=guardar_pontos-1;
    Matriz_x=[zeros(size(Matriz_x,1),1) Matriz_x];
    Matriz_y=[zeros(size(Matriz_y,1),1) Matriz_y];
    
    i=1;
    k=0;
    maior=0;
    while size(Matriz_x,2)>0
        
        k=k+1;
        if k~=1 && k<=size(Matriz_x,2)
            if vet_ind(k)~=vet_ind(k-1)
                i=i+1;
            end
        end
        conjunto_seguinte=[];
                Matriz_x=Matriz_x(:,2:end);
                Matriz_y=Matriz_y(:,2:end);
                if isempty(Matriz_y)
                    break;
                end
                VX=Matriz_x(:,1); VY=Matriz_y(:,1);
                segmentados=[VX(VX~=0) VY(VY~=0)]';
                
        if isempty(guardar_pontos)==false
            for j=1:size(segmentados,2)
                AB=find(abs(segmentados(1,j)-guardar_pontos(1,:))<=1 & abs(segmentados(2,j)-guardar_pontos(2,:))<=1);
                conjunto_seguinte=[conjunto_seguinte guardar_pontos(:,AB)];
                guardar_pontos(:,AB)=[];
            end  
        end

        if isempty(conjunto_seguinte)
            centro=[centro, [i;round(mean(segmentados(1,:))); round(mean(segmentados(2,:)))]]; 
        else
            [Matriz_organizada_x, Matriz_organizada_y]=organizar_versao1(conjunto_seguinte);
            Mxi=[i*ones(1,size(Matriz_organizada_x,2));Matriz_organizada_x];
            Myi=[i*ones(1,size(Matriz_organizada_y,2));Matriz_organizada_y];
            if size(Mxi,1)>maior
            maior=size(Mxi,1);
            Mx=[Mx; zeros(maior-size(Mx,1),size(Mx,2))];
            My=[My; zeros(maior-size(My,1),size(My,2))];
            else
            if size(Mxi,1)<maior
                Mxi=[Mxi; zeros(size(Mx,1)-size(Mxi,1),size(Mxi,2))];
                Myi=[Myi; zeros(size(My,1)-size(Myi,1),size(Myi,2))];
            end
            end
            Mx=[Mx Mxi];
            My=[My Myi];
        end
    end
    
    if size(Matriz,2)==1
        break;
    end
    
    vet_ind=Mx(1,:);
    
    for i=1:size(Matriz,2)
        Luminance(Matriz(2,i),Matriz(1,i))=255;
    end
    m=m+1;
end

end