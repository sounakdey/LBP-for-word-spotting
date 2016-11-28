function [boxes, breakPoints, normalisedBreakPoints] = kdTree(img)
 bw = im2bw(img, graythresh(img));
breakPoints =[];
cg = cMass(img);
cg1(1) = cg(2);
cg1(2) = cg(1);
breakPoints =cat(2,breakPoints,cg1);
s = size(img);
boxes = [1, 1, cg(2), cg(1);cg(2), 1, s(2), cg(1);...
         1, cg(1), cg(2), s(1); cg(2), cg(1), s(2), s(1)];
prevBoxes = boxes;
levels = 1;
for i=1:levels
    tempBoxes = [];
    for j=1:size(prevBoxes,1)
      BB(1) =  prevBoxes(j,1);
      BB(2) =  prevBoxes(j,2);
      BB(3) =  abs(prevBoxes(j,3)-prevBoxes(j,1));
      BB(4) =  abs(prevBoxes(j,4)-prevBoxes(j,2));
      tempIM = imcrop(img,BB);
      cg = cMass(tempIM);
      cg(1)= cg(1)+BB(2);
      cg(2)= cg(2)+BB(1);
      breakPoints =cat(2,breakPoints,cg);
      storeBoxes = [BB(1), BB(2), cg(2), cg(1);cg(2), BB(2), (BB(3)+BB(1)), cg(1);...
                    BB(1), cg(1), cg(2), (BB(2)+BB(4)); cg(2), cg(1), (BB(3)+BB(1)), (BB(2)+BB(4))];
                
      tempBoxes = cat(1,tempBoxes,storeBoxes);
      clear BB;
    end 
    boxes = cat(1,boxes,tempBoxes);
    clear prevBoxes;
    prevBoxes = tempBoxes;
    clear tempBoxes;
    
end
nbPoints = sum(4.^(0:levels));
normalisedBreakPoints = breakPoints./repmat([size(img,2),size(img,1)],[1,nbPoints]);
close all;
end

    
    
