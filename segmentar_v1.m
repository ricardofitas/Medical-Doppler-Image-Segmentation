%%%%%%%%% Ricardo Fitas, 2018 %%%%%%%%%%
%%% segmentation method for Doppler Images

function [Matriz_x , Matriz_y,guardar_pontos]=segmentar(Luminance,w)

Luminance=[255+zeros(1,size(Luminance,2)+4);255+zeros(size(Luminance,1),1) Luminance 255+zeros(size(Luminance,1),3); 255+zeros(3,size(Luminance,2)+1) [255 255 255; 255 0 255;255 255 255]];
comprimento= size(Luminance,2);
altura= size(Luminance,1);

Aux=Luminance;
Luminance(Luminance==0)=255;
Luminance(Aux==255)=0;

A=find(Luminance);
%figure(4), imshow(Luminance(1:(end-3),1:(end-3))), title('Two toned image');
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
Tamanho=[];
aaa=0;
e=0;
contagem=0;
while size(B,2)>1
    ver_scase=0;
    verifica_referencia=0;
    pontos=[];
    preto=-1;
    if c==1
        B=B(:,2:end);
    end
    
    if Luminance(B(2,1),B(1,1)-1)~=0 && Luminance(B(2,1),B(1,1)+1)~=0 && Luminance(B(2,1)-1,B(1,1))~=0 && Luminance(B(2,1)+1,B(1,1))~=0
    	c=1;
                    if size(guardar_pontos,2)>0
                        
                         guardar_pontos=[guardar_pontos B(:,1)];
                         total=total+1;
                        
                    else
                           total=1;
                           guardar_pontos=B(:,1);
                    end
    else
        c=0;
    end
    
    while c==0
        
        contagem=contagem+1;
%         if contagem>1970
%         VVV=cat(3,Luminance,Luminance,Luminance);
%         VVV(B(2,1),B(1,1),1)=255;
%         VVV(B(2,1),B(1,1),2:3)=0;
%         figure(1), imshow(VVV);title(contagem);
%         pause();
%         end
        
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
                             if ~isempty(find(B(2,:)==up & B(1,:)==left,1))
                             
                                B=[B(:,find(B(2,:)==up & B(1,:)==left)) B(:,2:(find(B(2,:)==up & B(1,:)==left)-1)) B(:,(find(B(2,:)==up & B(1,:)==left)+1):end)];
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
                            if isempty(pontos)
                                ver_scase=1;
                            end
                            pontos=[pontos B(:,1)];
                         if B(1,1)==pontos(1,1) && up==pontos(2,1)
                            c=1;
                         else
                            d=1;
                            if ~isempty(find(B(1,:)==B(1,1) & B(2,:)==up,1))
                                
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
                              if ~isempty(find(B(1,:)==right & B(2,:)==up,1))
                              
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
                            if isempty(pontos)
                                ver_scase=1;
                            end
                            pontos=[pontos B(:,1)];
                         if right==pontos(1,1) && B(2,1)==pontos(2,1)
                            c=1;
                         else
                             if ~isempty(find(B(1,:)==right & B(2,:)==B(2,1),1))

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
                             if ~isempty(find(B(1,:)==right & B(2,:)==down,1))
                             
                                    B=[B(:,find(B(1,:)==right & B(2,:)==down)) B(:,2:(find(B(1,:)==right & B(2,:)==down)-1)) B(:,(find(B(1,:)==right & B(2,:)==down)+1):end)];
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
                            if isempty(pontos)
                                ver_scase=1;
                            end
                            pontos=[pontos B(:,1)];
                         if B(1,1)==pontos(1,1) && down==pontos(2,1)
                            c=1;
                         else
                             if ~isempty(find(B(1,:)==B(1,1) & B(2,:)==down,1))
                           
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
                             if ~isempty(find(B(1,:)==left & B(2,:)==down,1))
                               
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
                            if isempty(pontos)
                                ver_scase=1;
                            end
                            pontos=[pontos B(:,1)];
                         if left==pontos(1,1) && B(2,1)==pontos(2,1)
                            c=1;
                         else
                             if ~isempty(find(B(1,:)==left & B(2,:)==B(2,1),1))

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
%             if e==1
%                 quadrado
%                 B(:,1)
%                 pause();
%             end

 
            
            if contar>=8
               c=1; 
                
               
               if ~(Luminance(B(2,1),B(1,1)-1)~=0 && Luminance(B(2,1),B(1,1)+1)~=0 && Luminance(B(2,1)-1,B(1,1))~=0 && Luminance(B(2,1)+1,B(1,1))~=0)
                  pontos=[B(1,1);B(2,1)];
               end
            end
            
            if verifica_referencia==1
                verifica_referencia=2;
                if size(referencia,2)>0
                if isempty(find(referencia(1,:)==nova_referencia(1,1) & referencia(2,:)==nova_referencia(2,1),1))
                    preto=preto-1;
                    contar=contar-1;
                end
                else
                    preto=preto-1;
                    contar=contar-1;
                end
            end 

        end
        
%         if contagem>1930
%             VVV=cat(3,Luminance,Luminance,Luminance);
%             VVV(referencia(2,(end-1)),referencia(1,(end-1)),1)=255;
%             VVV(referencia(2,end),referencia(1,end),2:3)=0;
%              figure(4), imshow(VVV(304:330,272:303,:));
%             pause();
        %end
    if size(pontos,2)>1 && ver_scase==1
        if (Luminance(pontos(2,1),pontos(1,1)-1)~=0 && Luminance(pontos(2,1),pontos(1,1)+1)~=0 && Luminance(pontos(2,1)-1,pontos(1,1))~=0 && Luminance(pontos(2,1)+1,pontos(1,1))~=0)
        ver_scase=0;
        B=[B, pontos(:,1)];
        Luminance(pontos(2,1),pontos(1,1))=255;
        pontos=pontos(:,2:end);
        end
    end 
    end
    if size(pontos,2)>w
        Pontos_x=pontos(1,:)'-1;
        Pontos_y=pontos(2,:)'-1;
        Tamanho = [Tamanho, size(pontos,2)];
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
    
%            if B(1,1)==222 && B(2,1)==126
%                 e=1;
%             end
           
end
Matriz_x=Matriz_x(:,1:(end-1));
Matriz_y=Matriz_y(:,1:(end-1));

end

