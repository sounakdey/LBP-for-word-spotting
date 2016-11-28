function [ imgStruct] = featLBPu2kdTree(imgStruct, radius, nbSamples, medianFilterSize)
% Input sPyr : [top left right bottom]
hist_image = zeros(numel(imgStruct),59);
for imgNum =1:numel(imgStruct)
    flag=0;
    
    [sPyr, breakPoints, normalisedBreakPoints] = kdTree(imgStruct(imgNum).img);
    bw = edge(imgStruct(imgNum).img,'sobel');
    
    im = medfilt2(imgStruct(imgNum).img,[medianFilterSize medianFilterSize]);  % median filter

    lbpImg = genericLBP(im,radius,nbSamples);

    imgStruct(imgNum).lbpImg = lbpImg;

    binaryMap = (dec2bin(0:((2^nbSamples)-1)))=='1';
    u2 = sum(binaryMap~=[binaryMap(:,2:end) binaryMap(:,1)],2);

    compressionMap=0:((2^nbSamples)-1);
    compressionMap(u2>2)=1000;
    nonUni = find(compressionMap==1000);
    noOfUni = numel(compressionMap)-numel(nonUni);
    compressionMap(u2<=2)=0:(noOfUni-1);

    compressionMap(compressionMap==1000)=noOfUni;
    lbpImgU2=compressionMap(1+lbpImg);
    hist_image(imgNum,1:59) = hist(lbpImgU2(:),(1:59));
  
    f=[];
        t = 1;
        l = 1;
        b = size(imgStruct(imgNum).img,1);
        r = size(imgStruct(imgNum).img,2);
        height = abs(t-b);
        width = abs(l-r);
        for subWindow=1:size(sPyr,1)
            tempt = floor(sPyr(subWindow,2));
            templ = floor(sPyr(subWindow,1));
            tempb = floor(sPyr(subWindow,4));
            tempr = floor(sPyr(subWindow,3));
        
             if tempr> size(imgStruct(imgNum).img,2)
                tempr = size(imgStruct(imgNum).img,2);
             end
             if tempb> size(imgStruct(imgNum).img,1)
                tempb = size(imgStruct(imgNum).img,1);
             end
            try
              variance = sum(sum(bw(tempt:tempb, templ:tempr)))/(height*width);
            catch
              tempt
              tempb
              templ
              tempr
            end
            windowPatch = lbpImgU2(tempt:tempb, templ:tempr);
            hist_subWindow = hist(windowPatch(:),(1:59)).*variance;

            normalisedHist = [hist_subWindow(1)/(1+sum(hist_subWindow)) hist_subWindow(2:end-1)/(1+sum(hist_subWindow(2:end-1))) hist_subWindow(end)/(1+(sum(hist_subWindow(2:end))))];
            f = cat(2, f, normalisedHist(2:end-1));

            
            if flag == 0 
                flag=1;
                surface = 0;
                surface = abs(tempt-tempb)*abs(templ-tempr);
            end
        end
        imgStruct(imgNum).surface = surface;
        imgStruct(imgNum).width = width;
        imgStruct(imgNum).featuresU2SP = f;
end
end

