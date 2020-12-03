%%%%%%%%% Ricardo Fitas, 2018 %%%%%%%%%%
%%% segmentation method for Doppler Images

function [Matriz_x , Matriz_y, Soma_pontos, cinzentos, vetor]=segmentar(Luminance)

Luminance=[255+zeros(1,size(Luminance,2)+4);255+zeros(size(Luminance,1),1) Luminance 255+zeros(size(Luminance,1),3); 255+zeros(3,size(Luminance,2)+1) [255 255 255; 255 0 255;255 255 255]];
comprimento= size(Luminance,2);
altura= size(Luminance,1);

Aux=Luminance;
Luminance(Luminance==0)=255;
Luminance(Aux==255)=0;

A=find(Luminance);
%figure(4), imshow(Luminance), title('Two toned image');
x=ones(1,length(A));
y=x;
for i=1:length(x)
    y(i)=rem(A(i),altura);
    x(i)=(A(i)- y(i))/altura+1;
end
y(y==0)=altura;
maior=0;
B=[x;y];
numero_circulos=[];
c=0;
referencia=[];

Soma_pontos=[];
Matriz_x=[];
Matriz_y=[];
guardar_pontos=[];
total=0;
Guardar=[];
while size(B,2)>1
    verifica_referencia=0;
    e=0;
    pontos=[];
    preto=-1;
    if c==1
        B=B(:,2:end);
    end
    
    if Luminance(B(2,1),B(1,1)-1)~=0 && Luminance(B(2,1),B(1,1)+1)~=0 && Luminance(B(2,1)-1,B(1,1))~=0 && Luminance(B(2,1)+1,B(1,1))~=0
    	c=1;
                    if size(guardar_pontos,2)>0
                        %if find(abs(guardar_pontos(1,:)-B(1,1))<=1 & abs(guardar_pontos(2,:)-B(2,1))<=1)
                         guardar_pontos=[guardar_pontos B(:,1)];
                         total=total+1;
                        %end
                    else
                           total=1;
                           guardar_pontos=B(:,1);
                    end
    else
        c=0;
    end
    
    while c==0
        
        left=B(1,1)-1;
        right=B(1,1)+1;
        up=B(2,1)-1;
        down=B(2,1)+1;
        contar=0;
        d=0;
        
        while d==0 && c==0 
            
            preto=preto+1;
            quadrado= rem(preto,8)+1;
            contar=contar+1;
        
            switch quadrado
            
                case 1
                    if Luminance(up,left)~=0 && Luminance(B(2,1),left)==0
                        if verifica_referencia==0
                            verifica_referencia=1;
                            nova_referencia=[left;B(2,1)];
                        else

                            Luminance(B(2,1),B(1,1))=150;
                            referencia=[referencia [left;B(2,1)]];
                            pontos=[pontos B(:,1)];            
                         if left==pontos(1,1) && up==pontos(2,1)
                            c=1;
                         else
                             if ~isempty(find(B(2,:)==up & B(1,:)==left))
                             
                                B=[B(:,B(2,:)==up & B(1,:)==left) B(:,2:(find(B(2,:)==up & B(1,:)==left)-1)) B(:,(find(B(2,:)==up & B(1,:)==left)+1):end)];
                             else
                                B=[[left;up] B(:,2:end)];
                             end
                             d=1;
                             preto=5;
                         end
                        end
                    
                    end
                    
                case 2
                    
                    if Luminance(up,B(1,1))~=0 && Luminance(up, left)==0
                        if verifica_referencia==0
                            verifica_referencia=1;
                            nova_referencia=[left;up];
                        else
                            referencia=[referencia [left;up]];
                            Luminance(B(2,1),B(1,1))=150;
                            pontos=[pontos B(:,1)];
                         if B(1,1)==pontos(1,1) && up==pontos(2,1)
                            c=1;
                         else
                            d=1;
                            if ~isempty(find(B(1,:)==B(1,1) & B(2,:)==up))
                                
                                B=[B(:,find(B(1,:)==B(1,1) & B(2,:)==up)) B(:,2:(find(B(1,:)==B(1,1) & B(2,:)==up)-1)) B(:,(find(B(1,:)==B(1,1) & B(2,:)==up)+1):end)];
                            else
                                B=[[B(1,1);up] B(:,2:end)];
                            end
                                preto=-1;
                         end 
                        end
                    end         
                case 3
                    
                    if Luminance(up,right)~=0 && Luminance(up,B(1,1))==0
                        if verifica_referencia==0
                           verifica_referencia=1;
                            nova_referencia=[B(1,1);up];
                        else
                            referencia=[referencia [B(1,1);up]];
                            Luminance(B(2,1),B(1,1))=150;
                            pontos=[pontos B(:,1)];
                          if right==pontos(1,1) && up==pontos(2,1)
                            c=1;
                          else
                              if ~isempty(find(B(1,:)==right & B(2,:)==up))
                              
                                B=[B(:,find(B(1,:)==right & B(2,:)==up)) B(:,2:(find(B(1,:)==right & B(2,:)==up)-1)) B(:,(find(B(1,:)==right & B(2,:)==up)+1):end)];
                              else
                                B=[[right;up] B(:,2:end)];
                              end
                                
                            d=1;
                            preto=-1;
                          end
                        end  
                    end
                    
                case 4
          
                    if Luminance(B(2,1),right)~=0 && Luminance(up,right)==0 
                        if verifica_referencia==0
                            verifica_referencia=1;
                            nova_referencia=[right;up];
                        else
                            referencia=[referencia [right;up]];
                            Luminance(B(2,1),B(1,1))=150;
                            pontos=[pontos B(:,1)];
                         if right==pontos(1,1) && B(2,1)==pontos(2,1)
                            c=1;
                         else
                             if ~isempty(find(B(1,:)==right & B(2,:)==B(2,1)))

                                B=[B(:,find(B(1,:)==right & B(2,:)==B(2,1))) B(:,2:(find(B(1,:)==right & B(2,:)==B(2,1))-1)) B(:,(find(B(1,:)==right & B(2,:)==B(2,1))+1):end)];
                             
                             else
                                B=[[right;B(2,1)] B(:,2:end)];
                             end
                            d=1;
                            preto=1;
                         end
                        end                    
                    end
                    
                    
                case 5
                    
                    if Luminance(down,right)~=0 && Luminance(B(2,1),right)==0
                        if verifica_referencia==0
                            verifica_referencia=1;
                            nova_referencia=[right;B(2,1)];
                        else
                            referencia=[referencia [right;B(2,1)]];
                            Luminance(B(2,1),B(1,1))=150;
                            pontos=[pontos B(:,1)];
                         if right==pontos(1,1) && down==pontos(2,1)
                            c=1;
                         else
                             if ~isempty(find(B(1,:)==right & B(2,:)==down))
                             
                                    B=[B(:,B(1,:)==right & B(2,:)==down) B(:,2:(find(B(1,:)==right & B(2,:)==down)-1)) B(:,(find(B(1,:)==right & B(2,:)==down)+1):end)];
                             else
                                B=[[right;down] B(:,2:end)];
                             end
                             d=1;
                            preto=1;
                         end
                        end
                                                
                    end          
                    
                case 6
                    
                     if Luminance(down, B(1,1))~=0 && Luminance(down,right)==0
                        if verifica_referencia==0
                            verifica_referencia=1;
                            nova_referencia=[right;down];
                        else
                            referencia=[referencia [right;down]];
                            Luminance(B(2,1),B(1,1))=150;
                            pontos=[pontos B(:,1)];
                         if B(1,1)==pontos(1,1) && down==pontos(2,1)
                            c=1;
                         else
                             if ~isempty(find(B(1,:)==B(1,1) & B(2,:)==down))
                           
                                 B=[B(:,find(B(1,:)==B(1,1) & B(2,:)==down)) B(:,2:(find(B(1,:)==B(1,1) & B(2,:)==down)-1)) B(:,(find(B(1,:)==B(1,1) & B(2,:)==down)+1):end)];
                             else
                                B=[[B(1,1);down] B(:,2:end)];
                             end
                             d=1;
                            preto=3;
                         end
                    end   
                     end
                    
                case 7
                    
                    if Luminance(down,left)~=0 && Luminance(down,B(1,1))==0
                        if verifica_referencia==0
                            verifica_referencia=1;
                            nova_referencia=[B(1,1);down];
                        else
                            referencia=[referencia [B(1,1);down]];
                            Luminance(B(2,1),B(1,1))=150;
                            pontos=[pontos B(:,1)];
                         if left==pontos(1,1) && down==pontos(2,1)
                            c=1;
                         else
                             if ~isempty(find(B(1,:)==left & B(2,:)==down))
                               
                                    B=[B(:,find(B(1,:)==left & B(2,:)==down)) B(:,2:(find(B(1,:)==left & B(2,:)==down)-1)) B(:,(find(B(1,:)==left & B(2,:)==down)+1):end)];
                             else
                                B=[[left;down] B(:,2:end)];
                             end
                             d=1;
                            preto=3;
                         end
                        end
                    end   
                    
                case 8
                    
                    if Luminance(B(2,1),left)~=0 && Luminance(down,left)==0
                        if verifica_referencia==0
                            verifica_referencia=1;
                            nova_referencia=[left;down];
                        else
                            referencia=[referencia [left;down]];
                            Luminance(B(2,1),B(1,1))=150;
                            pontos=[pontos B(:,1)];
                         if left==pontos(1,1) && B(2,1)==pontos(2,1)
                            c=1;
                         else
                             if ~isempty(find(B(1,:)==left & B(2,:)==B(2,1)))

                                B=[B(:,find(B(1,:)==left & B(2,:)==B(2,1))) B(:,2:(find(B(1,:)==left & B(2,:)==B(2,1))-1)) B(:,(find(B(1,:)==left & B(2,:)==B(2,1))+1):end)];
                             else
                                B=[[left;B(2,1)] B(:,2:end)];
                             end
                             d=1;
                            preto=5;
                         end
                        end          
                    end   
            end
                        
            if contar>=8
               c=1; 
               if ~(Luminance(B(2,1),B(1,1)-1)~=0 && Luminance(B(2,1),B(1,1)+1)~=0 && Luminance(B(2,1)-1,B(1,1))~=0 && Luminance(B(2,1)+1,B(1,1))~=0)
                  pontos=[B(1,1);B(2,1)];
               end
            end
            
            if verifica_referencia==1
                verifica_referencia=2;
                if size(referencia,2)>0
                if isempty(find(referencia(1,:)==nova_referencia(1,1) & referencia(2,:)==nova_referencia(2,1)))
                    preto=preto-1;
                    contar=contar-1;
                end
                else
                    preto=preto-1;
                    contar=contar-1;
                end
            end 
       
        end

    end 
    
    if size(pontos,2)>0
        Pontos_x=pontos(1,:)'-1;
        Pontos_y=pontos(2,:)'-1;
        if size(pontos,2)>maior
            maior=size(pontos,2);
            Matriz_x=[Matriz_x; zeros(maior-size(Matriz_x,1),size(Matriz_x,2))];
            Matriz_y=[Matriz_y; zeros(maior-size(Matriz_y,1),size(Matriz_y,2))];
        else
            if size(pontos,2)<maior
                Pontos_x=[Pontos_x; zeros(size(Matriz_x,1)-size(pontos,2),1)];
                Pontos_y=[Pontos_y; zeros(size(Matriz_y,1)-size(pontos,2),1)];
            end
        end
        Matriz_x=[Matriz_x Pontos_x];
        Matriz_y=[Matriz_y Pontos_y];
        Soma_pontos=[Soma_pontos size(pontos,2)];

        
    end

end

guardar_pontos=guardar_pontos-1;
figure(4), imshow(Luminance), title('Two toned image');
cinzentos=[Matriz_x(find(Matriz_x)) Matriz_y(find(Matriz_y))]';
vetor=[guardar_pontos cinzentos];
limite=size(guardar_pontos,2)

numero_manchas=0;
Lista=[];
conjunto=[];
while size(vetor,2)==0
    
    conjunto_seguinte=[];
    if isempty(conjunto)
        if ~isempty(Lista)
            Lista_total=[Lista_total [size(Lista,2); brancos; seg]];
            Lista_total
            pause();
            Lista=[];
            
        end
            [brancos, seg]=deal(0);
            conjunto= vetor(:,1);
            numero_manchas=numero_manchas+1;
    end
    
    for j=1:size(conjunto,2)
        vetor
        figure(4), imshow(Luminance(2:end-2,2:end-2)), title('Two toned image');
        vetor(:,limite:limite+20)
        ind_conjunto=find(abs(vetor(1,:)-conjunto(1,j))<=1 & abs(vetor(2,:)-conjunto(2,j))<=1);
        ind_conjunto
        pause();
        if ~isempty(ind_conjunto) 
            for i=1:length(ind_conjunto)
                if ind_conjunto(i)<limite
                    brancos=brancos+1;
                    limite=limite-1;
                else
                seg=seg+1;
                end
                conjunto_seguinte=[conjunto_seguinte vetor(:,ind_conjunto(i))];
                vetor(:,ind_conjunto(i))=[];
            end
        end
    end
    conjunto=conjunto_seguinte;
    conjunto
    pause();
    Lista=[Lista conjunto];
          
end

end

