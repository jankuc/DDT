function D=divergence(sp1,sp2,beta)
%self-blendovana Helingerova divergence
if size(sp1)~=size(sp2)
    error('nesedej ti rozmery spekter');
end
D=0;
[x,y]=size(sp1);

for ii=1:x
    for jj=1:y
        
        D=D+(sqrt(abs(sp1(ii,jj)))+sqrt(abs((sp2(ii,jj)))))*(sqrt(abs(beta*sp1(ii,jj)+(1-beta)*sp2(ii,jj))));
    end
end
D=8-4*D;