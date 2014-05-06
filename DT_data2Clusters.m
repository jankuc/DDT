function [indeces, probabilities] = DT_data2Clusters(data, flags, type)
% [indeces, probabilities] = DT_data2Clusters(data, flags, type)
% types: kmeans, fuzzy, mbc, chou_kmeans, dbscan, gmm
% 100% working: kmeans, 

% we define the types 
types = {
	'kmeans',...		% 1
	'fuzzy',...			% 2
	'mbc',...			% 3
	'chou_kmeans',...	% 4
	'dbscan'...			% 5 % 
	'gmm'...			% 6
	};


if strcmp(type, types{1})
	indeces = kmeans(data,2);
elseif strcmp(type, types{2}) 
    e = 1;
    a = 1;
    b = 1;
    F = 1;
    indeces = rfuzzy2(e,a,data,b,F);
elseif strcmp(type, types{3})
	boolTrain = flags < 100;
	indeces = MBC_dismix([data(boolTrain,:) flags(boolTrain,:)],[data(~boolTrain,:) flags(~boolTrain,:)]);
elseif strcmp(type, types{4})
	indeces = DT_chou_KMeans(data,2);
elseif strcmp(type, types{5})
	k = 5;
	l = 0;
	numOfTries = 5;
	notTwoClusters = 1;
	while notTwoClusters
		l = l+1;
		[indeces, ~] = dbscan(data,k,[]);
		if max(indeces) > 2
			if l > numOfTries
				k = k +1
				l = 0;
			end
			continue 
		elseif max(indeces) < 2
			if l > numOfTries
				k = k - 1
				l = 0;
			end
			continue
		else
			notTwoClusters = 0;
		end
	end
	disp('')
elseif strcmp(type, types{6})
	try
		gmfit = gmdistribution.fit(data,2,'Regularize',0);
		[indeces, nlogl, probabilities, logpdf] = cluster(gmfit,data);
	catch
		indeces = DT_data2Clusters(data,flags,'kmeans');
	end
else 
	for k = 1:length(types)
		types{k} = [types{k}, ' '];
	end
	error('Specified separation method does not exist. Please choose one of: \n %s', [types{:}])
end

probabilities = []; % TODO: implement probabilities of every data point