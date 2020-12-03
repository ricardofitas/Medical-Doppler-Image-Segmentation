%%%%%%% Ricardo Fitas, 2018 %%%%%%%%%%
%%%%%%%% spline drawing


%conjunto principal

xq = z(1):10:z(end);
sx = spline(z,x,xq);
sy = spline(z,y,xq);

%conjunto secundario

xq1 = z1(1):6:z1(end);
sx1 = spline(z1,x1,xq1);
sy1 = spline(z1,y1,xq1);
figure(12),
    scatter3(x(1:2:end),y(1:2:end),z(1:2:end),'MarkerEdgeColor','k','MarkerFaceColor',[0 .75 .75])
    view(150,400)
    hold on
    scatter3(x1(1:2:end),y1(1:2:end),z1(1:2:end),'MarkerEdgeColor','k','MarkerFaceColor',[1 0 0])
plot3(sx(1:4),sy(1:4),xq(1:4),'color',[0, 104/255, 21/255],'linewidth',15);
hold on
plot3(sx(4:end),sy(4:end),xq(4:end),'color',[0, 104/255, 21/255],'linewidth',10);
hold on
plot3(sx1,sy1,xq1, 'color', [0, 104/255, 21/255],'linewidth',7);
hold off