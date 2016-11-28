function [averagePrecision, meanAveragePrecision, recall, rprecision] = metricCalculation (dm1, labels)
%% The metric calculation 
% dm1 = distance matrix
% labels 
 dm=max(max(dm1)+1)*eye(size(dm1))+dm1;              %%% removing the diagnol self classification

%[distM,rankedIndexes]=sort(dm1,2);
[distM,rankedIndexes]=sort(dm,2);



rankedIndexes=rankedIndexes(:,1:end);

correctRetrievals=labels(cumsum(ones(size(rankedIndexes)),1))==labels(rankedIndexes);


validRows=sum(correctRetrievals,2)>1;


correctRetrievals=labels(cumsum(ones(size(rankedIndexes(:,1:end-1))),1))==labels(rankedIndexes(:,1:end-1));


averagePrecision = cumsum(correctRetrievals(validRows,:),2)./cumsum(ones(size(correctRetrievals(validRows,:))),2);
meanAveragePrecision = mean(sum(averagePrecision.*correctRetrievals(validRows,:), 2)./(sum(correctRetrievals(validRows,:), 2)));
recall=cumsum(correctRetrievals(validRows,:),2)./repmat(sum(correctRetrievals(validRows,:),2),[1,size(correctRetrievals,2)]);
rprecision=mean(averagePrecision(repmat(sum(correctRetrievals(validRows,:),2),[1,2605])==cumsum(ones([sum(validRows), 2605]),2)));

end
