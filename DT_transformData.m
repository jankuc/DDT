function dataTransfed = DT_transformData(data,type)
%
% dataTransfed = DT_transformData(data,type)
%
% data ... data we want transformed
%
% type ... string defining type of transformation
%           pcacov ... Principal component analysis on covariance matrix 
%           pca ... Principal component analysis (PCA) on data
%           anything else ... nothing

if strcmpi(type,'PCAcov')
    P = pcacov(cov(data));
    dataTransfed = data*P;
elseif strcmpi(type,'PCA')
    [~, dataTransfed] = princomp(data);
else
    dataTransfed = data;
end

