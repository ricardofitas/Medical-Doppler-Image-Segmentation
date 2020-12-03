%%%%%%%%% Ricardo Fitas, 2018 %%%%%%%%%%
%%% segmentation method for Doppler Images

function [Matriz_x , Matriz_y,G,ev]=segmentar_3(Luminance,w,cc,SS)

start1=tic;
comprimento= size(Luminance,2);
altura= size(Luminance,1);
Luminance=[255+zeros(2,comprimento+6);255+zeros(altura,2) Luminance 255+zeros(altura,4); 255+zeros(4,comprimento+6)];
Luminance(end-1,end-1)=0;
guardar_pontos=zeros(2,SS+1);
altura= size(Luminance,1);
Aux=Luminance;
Luminance(Luminance==0)=255;
Luminance(Aux==255)=0;
A=find(Luminance);
x=ones(1,length(A));
y=x;
for i=1:length(x)
    y(i)=rem(A(i),altura);
    x(i)=(A(i)- y(i))/altura+1;
end
y(y==0)=altura;
maior=0;
B=[x;y];
Matriz_x=[];
Matriz_y=[];
f=0;
for i=1:size(B,2)
    if Luminance(B(2,i),B(1,i)-1)~=0 && Luminance(B(2,i),B(1,i)+1)~=0 && Luminance(B(2,i)-1,B(1,i))~=0 && Luminance(B(2,i)+1,B(1,i))~=0
        f=f+1;
        guardar_pontos(f)=i;   
    end
end
guardar_pontos(f+1:end)=[];
G=B(:,guardar_pontos)-2;
B(:,guardar_pontos)=[];
while size(B,2)>0
    H0=[[-1+zeros(1,2),0,ones(1,3),0,-1+zeros(1,2)];[0,-1+zeros(1,3),0,ones(1,3),0]];
    H=H0+B(:,1);
    [L,Laux]=deal(ones(1,9));
    for i=1:2:9
        L(i)=Luminance(H(2,i),H(1,i));
    end
    h=find(L==0,1);
    r_inicial=H(:,h);
    for i=2:2:8
        Laux(i)=Luminance(H(2,i),H(1,i));
    end
    if h~=1
        H0=[H0(:,h:end-1), H0(:,1:h)];
        H=H0+B(:,1);
    end
    for i=2:2:8
        L(i)=Laux(i);
    end
    L=[L(:,h:end-1), L(:,1:h)];
    k=find(L~=0,1)-1;
    if isempty(k)
        Nref=4;
        pontos=B(:,1);
        B(:,1)=[];
    else
        s_ref_final=[0;0];        
        h=mod(k-2+mod(k-1,2),8);
        P=H(:,k+1);
        tiraB=1;
        pontos=[B(:,1), P(:,1)];
        Nref=floor(k/2);
        while pontos(1,end-1)~=pontos(1,1) || pontos(2,end-1)~=pontos(2,1) || isempty(find(r_inicial(1,1)==s_ref_final(1,:) & r_inicial(2,1)==s_ref_final(2,:),1))==true
            H0=[H0(:,h:end-1), H0(:,1:h)];
            H=H0+P(:,1);
            for i=1:9
                L(i)=Luminance(H(2,i),H(1,i));
            end
            k=find(L~=0,1)-1;                      
            h=mod(k-2+mod(k-1,2),8);
            s_ref_final=H(:,1:2:k);
            tiraB=[tiraB find(B(1,:)==P(1,1) & B(2,:)==P(2,1))];
            P=H(:,k+1);
            pontos=[pontos [P(1,1);P(2,1)]];
            Nref=Nref+floor(k/2);
        end
        pontos(:,end-1:end)=[];
        F=find(r_inicial(1,1)==s_ref_final(1,:) & r_inicial(2,1)==s_ref_final(2,:),1);
        Nref=Nref-(size(s_ref_final,2)-F+1);
        B(:,unique(tiraB))=[];
    end
    if size(pontos,2)>w
        if cc==1
            if size(pontos,2)>=Nref
                verifica_if=0;
            else
                verifica_if=1;
            end
        else
            verifica_if=1;
        end
        if verifica_if==1
            Pontos_x=pontos(1,:)'-2;
            Pontos_y=pontos(2,:)'-2;
            if size(pontos,2)>maior
                maior=size(pontos,2);
                Matriz_x=[Matriz_x; zeros(maior-size(Matriz_x,1)+1,size(Matriz_x,2))];
                Matriz_y=[Matriz_y; zeros(maior-size(Matriz_y,1)+1,size(Matriz_y,2))];
            else
                if size(pontos,2)<maior
                    Pontos_x=[Pontos_x; zeros(size(Matriz_x,1)-size(pontos,2)-1,1)];
                    Pontos_y=[Pontos_y; zeros(size(Matriz_y,1)-size(pontos,2)-1,1)];
                end
            end
            Matriz_x=[Matriz_x [size(pontos,2);Pontos_x]];
            Matriz_y=[Matriz_y [size(pontos,2);Pontos_y]];
        end
    end
end
Matriz_x=Matriz_x(2:end,1:(end-1));
Matriz_y=Matriz_y(2:end,1:(end-1));
ev=toc(start1);
end

