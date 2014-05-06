function [data, flags, weights, dataAlreadyDefined] = DT_loadFNALData(nTraining,nTesting)
% creates data  with appropriate flags
%
% Flags for training data:
% --------------------
% tb              1
% tqb             2
% diboson         3
% QCD             4
% ttbar_dilepton  5
% ttbar_lepjets   6
% wbb             7
% wcc             8
% wlp             9
% zbb             10
% zcc             11
% zlp             12
% --------------------
%
% for testing data flagsTest =  flagsTrain + 100
%
load T2J2small_training
load T2J2testing

%% Train Data
% creation of training data and vector of appropriate flags
dataTrain = [tb; tqb; diboson; QCD; ttbar_dilepton; ttbar_lepjets;...
    wbb; wcc; wlp; zbb; zcc; zlp];

flagsTrain = [1*ones(size(tb,1),1); 2*ones(size(tqb,1),1); 3*ones(size(diboson,1),1);...
    4*ones(size(QCD,1),1); 5*ones(size(ttbar_dilepton,1),1); 6*ones(size(ttbar_lepjets,1),1);...
    7*ones(size(wbb,1),1); 8*ones(size(wcc,1),1); 9*ones(size(wlp,1),1);...
    10*ones(size(zbb,1),1); 11*ones(size(zcc,1),1); 12*ones(size(zlp,1),1)];

% zmenseni datoveho souboru
if nTraining > 0
	dataTrain = dataTrain(1:floor(size(dataTrain,1)/nTraining):end,:);
	flagsTrain = flagsTrain(1:floor(size(flagsTrain,1)/nTraining):end,:);
end
%% Test Data
% creation of testing data and vector of appropriate flags
dataTest = [tb_test; tqb_test; diboson_test; QCD_test; ttbar_dilepton_test; ttbar_lepjets_test;...
    wbb_test; wcc_test; wlp_test; zbb_test; zcc_test; zlp];

flagsTest = [1*ones(size(tb_test,1),1); 2*ones(size(tqb_test,1),1); ...
    3*ones(size(diboson_test,1),1); 4*ones(size(QCD_test,1),1); ...
    5*ones(size(ttbar_dilepton_test,1),1); 6*ones(size(ttbar_lepjets_test,1),1);...
    7*ones(size(wbb_test,1),1); 8*ones(size(wcc_test,1),1); 9*ones(size(wlp_test,1),1);...
    10*ones(size(zbb_test,1),1); 11*ones(size(zcc_test,1),1); 12*ones(size(zlp_test,1),1)];

% zmenseni datoveho souboru
if nTesting > 0
	dataTest = dataTest(1:floor(size(dataTest,1)/nTesting):end,:);
	flagsTest = flagsTest(1:floor(size(flagsTest,1)/nTesting):end,:);
end
flagsTest = flagsTest + 100; % to distinguish train and test flags

% smichani trenovacich a testovacich dat:
data = [dataTrain; dataTest];
weights = data(:,end);
data = data(:,1:end-1);

flags = [flagsTrain; flagsTest];

dataAlreadyDefined = 1;
disp('data loaded.')
end

