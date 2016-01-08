%read trainign data
trainSize = 6000;
testSize = 1000;

[A,L] = readData(0,trainSize);
L = L';
[TestA, TestL] = readData(1,testSize);
TestL = TestL';

%reformat A
A = reshape (A, size(A,1)*size(A,2), size(A,3) );
TestA = reshape (TestA, size(TestA,1)*size(TestA,2), size(TestA,3) );

% A is 784 by 5000 matrix

% pack all data into one matrix to reduce dataset
ALL = [ A, TestA ];

% normalize 
[pn,meanp,stdp] = prestd(ALL);
% discard any components with 0 stdev --> no information 
pn = pn( stdp ~= 0, : );

% principal component analysis to reduce dimension
% conservative: keep 99.9% of variation
[ptrans,transMat] = prepca(pn,0.001);

% seperate training and dataset
A = ptrans(:, 1:size(A,2));
TestA = ptrans(:, size(A,2)+1:end);

ValiA = A(:, 1:3:end);
A = [ A(:, 2:3:end) A(:, 3:3:end) ];

ValiL = L(:, 1:3:end);
L = [ L(:, 2:3:end) L(:, 3:3:end) ];

ACombined = [ A ValiA ];
LCombined = [ L ValiL ];

%grid search
gRange = 2.^[-15:2:3];
cRange = 2.^[-5:2:15];

[G,C] = meshgrid(gRange, cRange);

AccRes = G;

% limit size to 1000 train and 500 validation
ValiLSearch = ValiL(:,1:min(100, size(ValiL,2) ));
LSearch = L(:,1:min(300, size(L,2) ));
ValiASearch = ValiA(:,1:min(100, size(ValiA,2) ));
ASearch = A(:,1:min(300, size(A,2) ));

for g = 1:length(gRange)
    for c = 1:length(cRange)
        modelSVM = svmtrain ( LSearch', ASearch', [ '-t 2 -c ' num2str(cRange(c)) ' -g ' ...
            num2str(gRange(g)) ] ) ;
        
        [plabel, acc] = svmpredict(ValiLSearch', ValiASearch', modelSVM); % test the training data        
        AccRes(c,g) = acc(1);
    end
    display ( [ 'run ' num2str(g) ' of ' num2str(length(gRange)) ' finished']);
end

G = log(G) ./ log(2);
C = log(C) ./ log(2);

[C,h]= contour (interp2(G,4),interp2(C,4),interp2(AccRes,4));
set(h,'ShowText','on','TextStep',get(h,'LevelStep')*2)
ylabel('ld(C)'); xlabel('ld(gamma)');
text_handle = clabel(C,h);
set(text_handle,'BackgroundColor',[1 1 .6], 'Edgecolor',[.7 .7 .7]);
title ( 'Classification rate for different (C,gamma) pairs');

%[k,l] = max ( AccRes);
%[k,gSel] = max (k);
%cSel = l(gSel);

m = max(max(AccRes));
[X,Y] = meshgrid(1:length(gRange), 1:length(cRange));

gSel = mean(X(AccRes == m));
cSel = mean(Y(AccRes == m));

c = interp1 (cRange, cSel);
g = interp1 (gRange, gSel);

display ( ['using C= ' num2str(c) ' and gamma= ' num2str(g) ] );

%train model with whole dataset
tic
modelSVM = svmtrain ( LCombined', ACombined', [ '-t 2 -c ' num2str(c) ' -g ' ...
            num2str(g) ] ) ;
display ([ 'training time: ' num2str(toc) ] );

tic
[plabel, acc] = svmpredict(TestL', TestA', modelSVM); % test the training data    
display ([ 'testing time: ' num2str(toc) ] );
