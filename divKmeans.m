function index = divKmeans(X,k,distance)
% data ... data we want to separate (preferably principal components from PCA)
% k ... max number of clusters
% distance ... divergence we want to use as a criterion for clustering

index = clusterdata(X,'maxclust',k,'distance',distance);

scatter(X(:,1), X(:,2),10*index,index,'filled');
colormap(jet)

end