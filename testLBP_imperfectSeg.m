clc; 
global features labels
debug = false;
%% Preload the queries and target documents
[labels, qImgStruct] = loadDirCropped('../distortedGWnew/100/');
%% Features LBP extraction
qImgStruct = featLBPu2kdTree(qImgStruct, 1, 8, 13);
features = reshape([qImgStruct.featuresU2SP],size(qImgStruct(1).featuresU2SP,2),[])';
%% The initialisation
logmAP=zeros(100,1);
logAccuracy=zeros(100,1);
logrPrecision=zeros(100,1);
logP10 = zeros(100,1);
count=1;
if ~exist('dataResultDevelop','dir')
    mkdir('./dataResultDevelop');
end
parfor folder=10:100
    %% The feature extraction  
    [~, newStruct] = loadDirCropped(['/home/sounak/Desktop/distortedGWnew/' num2str(folder) '/']);
    newStruct = featLBPu2kdTree(newStruct, 1, 8, 13);

    featuresDB = reshape([newStruct.featuresU2SP],size(newStruct(1).featuresU2SP,2),[])';



    %% The width cosideration
    surface = [newStruct(:).width];

    repSurface1 = repmat(surface',[1, numel(surface)]);
    repSurface2 = repmat(surface,[numel(surface), 1]);
    ratio1 = repSurface1./repSurface2;
    ratio2 = repSurface2./repSurface1;
    %% The coefficient calculation 
    k =1;  
    coeff = 0.15;
    %% The ditance matrix calculation
    dm=pdist2(features,featuresDB,'cityblock');                % citiblock distance
    dm=dm./max(max(dm));
    dm1 = (1-coeff)*dm+coeff*(1-min(ratio1, ratio2));          
    %% The calculation of the metrics
    %[averagePrecision, meanAveragePrecision, recall, rprecision] = metricCalculation(dm1,labels);
    [averagePrecision, meanAveragePrecision, recall, rprecision] = metricCalculation_self(dm1,labels);

    %% The storing of the results
    logmAP(folder) = meanAveragePrecision;
    logAccuracy(folder) = mean(averagePrecision(:,1));
    logrPrecision(folder) = rprecision;
    logP10(folder) = mean(averagePrecision(:,10));
    fname = ['./dataResultDevelop/LBP_Scorefiles_GW' num2str(folder) '.mat'];
    fnameIn = ['./dataResultDevelop/LBP_Scoreindex_GW' num2str(folder) '.mat'];
    %parforsave(fname,fnameIn,dm1);
end
%% Storing of the overall results
save('./GWlogmAP_LBP_self.mat','logmAP');
save('./GWloplogAccuracy_LBP_self.mat','logAccuracy');
save('./GWlogrPrecision_LBP_self.mat','logrPrecision');
save('./GWlogP10_LBP_self.mat','logP10');

