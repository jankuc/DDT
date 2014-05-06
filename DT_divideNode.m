function [indexNew, prispevek1, prispevek2] = DT_divideNode(clusterForDivision, weights, indexOld, indexOfDividedCluster,  nHist, flags, divisionType, probs)
% [indexNew, prispevek1, prispevek2] = TreeDiv_stepeniA(clusterForDivision, weights, indexOld, indexOfDividedCluster,  nHist, flags, divisionType)
%
% clusterForDivision ... data, which we will divide
% weights ... weights of data
% indexOld ... indeces of ALL data, not only those of clusterForDivision
% indexOf DividedCluster ... index of divided node
% flags ... flags of different types of signal
% nHist ... number of bins of histogram in one dimension.

n=size(clusterForDivision,1);
%% Transformace dat
dataTransfed = DT_transformData(clusterForDivision,'pcacov');
dim = size(dataTransfed,2);

%% All the divisions to two clusters

divergenceType = @divRenyi; % specification of used divergence
alpha = 0.3;
numOfPC = 15; % max number of parameters
dimOfHist = 2; % dimension of the empirical distribution function

numOfCountedVars = min(numOfPC,dim); % later we count only 'few' principal components, or all of the parameters
varCombinations = combnk(1:numOfCountedVars,dimOfHist); % rows are combinations of the dimOfHist parameters of numOfCountedVars

% initialization
Dmin  = inf*ones(size(varCombinations,1),1);
D1min = inf*ones(size(varCombinations,1),1);
D2min = inf*ones(size(varCombinations,1),1);
probabilities = cell(size(varCombinations,1),1);
I = cell(size(varCombinations,1),1);

for k = 1:size(varCombinations,1)
	dataNew = dataTransfed(:,varCombinations(k,:)); % used new subset of the parameters
	
	[indeces, probabilities{k}] = DT_data2Clusters(dataNew,flags, divisionType);
	I{k} = indeces;
	
	
	cluster1 = dataNew((indeces==1),:);
	n1 = size(cluster1,1);
	cluster2 = dataNew((indeces==2),:);
	n2 = size(cluster2,1);
	
	H1 = DT_histcn(cluster1, 'AccumData',weights(indeces==1)) / n1; % empirical distributions with weights
	H2 = DT_histcn(cluster2, 'AccumData',weights(indeces==2)) / n2;
	H = DT_histcn(dataNew, 'AccumData',weights) / n;
	
	D1min(k) = divergenceType(H,H1,alpha);
	D2min(k) =  divergenceType(H,H2,alpha);
	Dmin(k) = (n1*D1min(k) + n2*D2min(k))/n;
	
end

[~,minInd] = min(Dmin); % which clusterization was the best
[indexBest probabilities] = DT_data2Clusters(dataTransfed(:,varCombinations(minInd,:)),flags, divisionType);

prispevek1=(sum(I{minInd} == 1)/n)*D1min(minInd);
prispevek2=(sum(I{minInd} == 2)/n)*D2min(minInd);

% reindexing of indexBest, so it has unique index with respect to indexOld.
indexBest(indexBest==1) = -1;
indexBest(indexBest==2) = max(indexOld) + 1; % one of the new clusters will have the new index
indexBest(indexBest==-1) = indexOfDividedCluster; % second cluster will have the old index of the divided node.

figure;
scatter(clusterForDivision(:,1), clusterForDivision(:,2),10*indexBest,indexBest,'+');
colormap(jet(max(indexBest)))
title('Cluster Division');

indexNew = indexOld;
indexNew( indexNew(:,end)==indexOfDividedCluster, end) = indexBest;

end
