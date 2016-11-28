function [lbp] = genericLBP(img,radius,nbSamples)
    img=double(img);
    allAngles=((0:(nbSamples-1))*2*pi)/nbSamples;
    xCenter=cumsum(ones(size(img)),2);
    yCenter=cumsum(ones(size(img)),1);
    lbp=zeros(size(img));
    counter=0;
    for ang = allAngles
        lbp=lbp+(2^counter)*(img<interp2(img,xCenter+cos(ang)*radius,yCenter+sin(ang)*radius,'linear',0));
        counter=counter+1;
    end
end