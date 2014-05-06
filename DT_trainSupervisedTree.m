function [indeces prispevky]=DT_trainSupervisedTree(data, weights, nHist,maxNClusters,nMin, flags)
%
%[indeces prispevky]=DT_trainTree(data,nHist,maxNClusters,nMin)
%
%   data ......... data, ktera budeme delit
%   nHist ........ prednastaveni deleni histogramu. 2D histogram bude mit nHist*nHist binu 
%   maxNClusters . maximalni pocet shluku, ktery chceme obdrzet
%   nMin ......... minimalni pocet bodu ve shluku, abychom ho jeste delili.
%
%   indeces ...... vektor priuslusnosti dat k jednotlivym shlukum (podle indexu)
%                       size = (n,1)                   
%   prispevky .... vektor prispevku jednotlivych shluku k vysledne divergenci
%                       size = (maxNClusters,1)
%   flags flagy prislusnosti data k signalu


plot(data(:,1),data(:,2),'r+')
title('data')

divMin = 0; % pokud nastavim nenulovou hodnotu, shluky s hodnotou prispevky < divMin nebudou dale deleny.
n = size(data,1);
indeces=ones(n,1); % vektor indexu znacicich, ke kteremu shluku dane datum patri
prispevky= - Inf * ones(maxNClusters,1); % vektor hodnot divergenci danych shluku
prispevky(1) = 1; % delime vzdy shluk s nejvyssim prispevkem a ted chceme delit 1.

odlozeneShluky=zeros(maxNClusters,1); % vektor priznaku {0,1} jestli je shluk s timto indexem zakazano stepit.
odkladame = 1; % nastavime na 1, pokud nektere shluky nechceme dale delit. toto kriterium se tam ale pak musi pridat

for cDeleni = 1:maxNClusters-1
    
    prispevkyTmp = prispevky; % na prispevkyTmp budu delat nejake osklive upravy a prispevky si necham nezmenene.
    [~, index] = max(prispevkyTmp); %najde shluk s nejvetsim prispevkem
    while odlozeneShluky(index) == 1 || sum(indeces == index) < nMin % pokud je tento shluk v odlozenych, nebo ma malo dat najdu si dalsi s nejvetsim atd.
        prispevkyTmp(index) = -inf;
        [~, index] = max(prispevkyTmp);
        if prispevkyTmp(index) == -inf
            break
        end
    end
    
    if max(prispevkyTmp) == -inf
        disp('Vsechny shluky uz jsou odlozene nebo maji malo dat, takze koncime.');
        break;
    end
    disp(strcat('delim shluk c._',num2str(index)))
    % ted mam index shluku s nejvetsim prispevkem
    [indeces, prispevek1, prispevek2]=DT_divideNode(data(indeces == index,:), weights(indeces == index,:) ,indeces, index ,nHist, flags(indeces == index,:)); %deleni prvniho shluku
    prispevky(index) = prispevek1; % v prispevcich musim zmenit  hodnoty stepeneho clusteru
    prispevky(max(indeces)) = prispevek2; % a noveho clusteru
    
    if odkladame
        for k = 1:length(odlozeneShluky)
             if var(flags(indeces==k))==0 %  shluk je homogenni
                odlozeneShluky(k) = 1;
             else
                 odlozeneShluky(k) = 0;
             end
        end
    end
    figure;
    scatter(data(:,1), data(:,2),10*indeces,indeces,'+');
    colormap(jet(maxNClusters))
    title(strcat('po deleni na ', num2str(cDeleni+1), ' shluk{y/u}.'));
    colorbar
end


