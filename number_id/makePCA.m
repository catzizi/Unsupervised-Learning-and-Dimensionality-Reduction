function [] = makePCA ()

teststd = [ 100 99.9 99 97.5 95 90 75 33 ];
teststd = teststd / 100;
DigitPCA = cell(4, length(teststd));

%read training data
trainSize = 3000;
testSize = 500;
%trainSize = 1200;
%testSize = 200;

[A,L] = readData(0,trainSize);
L = L';
[TestA, TestL] = readData(1,testSize);
TestL = TestL';

% convert outcomes to 10 boolean representation
TestLBin = zeros ( 10, length(TestL) );
LBin = zeros ( 10, length(L) );

for i = 1:length(TestL)
    TestLBin ( TestL(i)+1 ,i) = 1;
end

for i = 1:length(L)
    LBin ( L(i)+1 ,i) = 1;
end

%reformat A
A = reshape (A, size(A,1)*size(A,2), size(A,3) );
TestA = reshape (TestA, size(TestA,1)*size(TestA,2), size(TestA,3) );

% A is 784 by 5000 matrix

% pack all data into one matrix to reduce dataset
ALL = [ A, TestA ];

% normalize
[pn,meanp,stdp] = prestd(ALL');
% discard any components with 0 stdev --> no information
%pn = pn( stdp ~= 0, : );

% principal component analysis to reduce dimension
%    [ptrans,transMat] = prepca(pn,100-curstd);
tic;
[COEFF,SCORE,latent] = princomp(pn);
toc;

% show examples of pictures
figure;
colormap gray;
imagesc ( reshape(COEFF(:,1),28,28)' );
title ('1st eigen-image');
figure
colormap gray;
imagesc ( reshape(COEFF(:,10),28,28)' );
title ('10th eigen-image');
figure
colormap gray;
imagesc ( reshape(COEFF(:,100),28,28)' );
title ('100st eigen-image');
imagesc ( reshape(COEFF(:,500),28,28)' );
title ('500st eigen-image');

magnitude = sum(latent);
cursum = magnitude;

for i =1:length(teststd)
DigitPCA{1,i} = size(COEFF,1);
DigitPCA{2,i} = teststd(i);
end

%find borders
for i=size(COEFF,1):-1:1
    cursum = cursum - latent(i);
    j=0;
    
    for curstd = teststd
        j= j+1;
        if cursum / magnitude > curstd
            DigitPCA{1,j} = i;
        end
    end
end

%get Data
for i=1:length(teststd)
    DigitPCA{3,i} = SCORE(:,1:DigitPCA{1,i});
    DigitPCA{4,i} = latent(1:DigitPCA{1,i});
end

% plot distribution of eigenvalues
figure;
bar(latent);
%mark marker std :)
for i=1:length(teststd)
   ylim = get(gca,'ylim');
   line( DigitPCA{1,i} * ones(1,2), ylim, 'Color', 'b' );
   text ( DigitPCA{1,i} - 10, ylim(1) + (ylim(2)-ylim(1)) * ( 0.15 + 0.7 * (i-1) / length(teststd)), ...
       num2str(teststd(i)), 'FontWeight', 'bold');
end

%reconstruct first image
for i = 1:length(teststd)
    figure;
    colormap gray;
    B = DigitPCA{3,i}(5,:);
    R = COEFF(:,1:length(B)) * B';
    imagesc ( reshape(R, 28,28)');
    title (['Projected on ', num2str(teststd(i)*100) ' % of principal vectors']);
end


save DigitPCA.mat DigitPCA