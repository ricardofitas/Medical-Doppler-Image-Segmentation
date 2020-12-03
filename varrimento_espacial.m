%%%%%%% Ricardo Fitas, 2018 %%%%%%%%%%%%
while ispossible dicomread('IM_0002', 'frames', i)
    F=dicomread('IM_0002', 'frames', i);
    imshow(F);
end
