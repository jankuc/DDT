function [indeces H divergences]=DT_trainSupervisedTree(data, weights, nHist, maxNClusters, nMin, flags, divisionType)
%   [indeces H divergence]=DT_trainSupervisedTree(data, weights, nHist, maxNClusters, nMin, flags, divisionType)
%
%   data .........	data, which will be classified
%   nHist ........	number of bins of histogram in one dimension. 2D
%					histogram will have nHist*nHist bins.
%   maxNClusters .	maximum number of clusters
%   nMin .........	minimal number of dates in one node so it is
%					candidate for division in next iteration
%   indeces ......	vector of resulting classes of the data
%   divergences ..	vector of resulting divergence of each node
%						(TODO does it have any meaning ??? )
%   flags ........	flags of different types of signal

%data = DT_transformData(data,'PCAcov');
plot(data(:,2),data(:,3),'r+')
%title('data')

%divMin = 0; % if we set nonzero value, nodes with divergence < divMin won't be divided.
[n,dim] = size(data);
indeces=ones(n,1); % vector of indeces showing to which node the data belong
divergences = - Inf * ones(maxNClusters,1); % initialization of divergence
divergences(1) = 1; % we always divide node with the highest divergence and now, we want to divide first node.

sidedNodes = zeros(maxNClusters,1); % vector of booleans {0,1}. 0 -> can be divided, 1 -> cannot be divided
puttingAside = 1; % boolean which only tells if we are going to put some nodes aside, or we won't do it

%% init of histograms of every node
histDim = 2; % number of parameters in histogram we want saved (dimension)
histDim = min(histDim,dim);
dataHist = DT_transformData(data,'PCAcov'); % data which will be used for creation of histogram
dataHist = dataHist(:,1:histDim);
H = cell(maxNClusters,1); % in here we'll store all of the histograms
H{1} = DT_histcn(dataHist, 'AccumData',weights) / n;

for numOfDivision = 1:maxNClusters-1
	
	divergenceTmp = divergences; % temporary divergence vector (we have to do some tmp changes)
	[~, index] = max(divergenceTmp(divergenceTmp < inf)); % index of node with the highest divergence
	try
		while sidedNodes(index) == 1 || sum(indeces == index) < nMin % selection of node, which is not put aside and has enough data to try to divide it
			divergenceTmp(index) = -inf;
			[~, index] = max(divergenceTmp);
			if divergenceTmp(index) == -inf
				break
			end
		end
	catch
	end
	
	if max(divergenceTmp) == -inf
		disp('None of the nodes are fit for splitting any more.');
		break;
	end
	disp(strcat('Dividing node num._',num2str(index),', it contains_',num2str(sum(indeces==index)),'_of data.'));
	% Now we have index of node with the highest divergence
	[indeces, prispevek1, prispevek2]=DT_divideNode(data(indeces == index,:), weights(indeces == index,:) ,indeces, index ,nHist, flags(indeces == index,:), divisionType); %deleni prvniho shluku
	% we always 
	
	divergences(index) = prispevek1; % we have to update the divergence of the divided node
	divergences(max(indeces)) = prispevek2; % and the new node
	
	% actualization of histograms
	ind = index;
	H{ind} = DT_histcn(dataHist(indeces == ind, :), 'AccumData',weights(indeces == ind)) / sum(indeces == ind);
	ind = max(indeces);
	H{ind} = DT_histcn(dataHist(indeces == ind, :), 'AccumData',weights(indeces == ind)) / sum(indeces == ind);
	
	if puttingAside
		for k = 1:length(sidedNodes)
			if var(flags(indeces==k))==0 % node is homogenous 
				sidedNodes(k) = 1;
			else
				sidedNodes(k) = 0;
			end
		end
	end
	figure;
	scatter(data(:,2), data(:,3),10*indeces,indeces,'+');
	colormap(jet(maxNClusters))
	title(strcat('After division to  ', num2str(numOfDivision+1), ' nodes.'));
	colorbar
end


