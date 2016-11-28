function [cg] = cMass (img)
img = double(img)./255;
bw=(img<graythresh(img));
x=cumsum(ones(size(img)),2);
y=cumsum(ones(size(img)),1);
cg=[median(y(bw)),median(x(bw))];
if any(isnan(cg))
    cg = size(bw)./2;
%     temp = cg(1);
%     cg(1) = cg(2);
%     cg(2) = temp;
end
%quantile(x(bw),10)
%plot(x(bw),'*');
end
