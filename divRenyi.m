function D = divRenyi(H1,H2,a)
% D = divRenyi(H1,H2,a)
%
% Renyi diveregnce from histograms
%
% H1, H2..histograms of the two distributions
%
% a........ Renyi parameter alpha. With greater value comes bigger robustness.
%           a > 0, a ~= 1. Optimal parameters are in <0.3 , 1>

% D = (sp1.^a) .* (sp2.^(1-a));
% D = sum(sum(D));
% D = log(D);
% D = D/(a-1);
%H1 = H1(:);
%H2 = H2(:);
D = 0;
for k = 1:prod(size(H1))
    if H1(k) && H2(k)
        D = D + (H1(k)^a) * (H2(k)^(1-a));
    end
end
D = log(D)/(a-1);
%divs = (H1.^a) .* (H2.^(1-a));
%D = log(sum(divs(:)))/(a-1);