function [] = makeICA ()

dimensions = [5 7 10 25 37 50 91 154 228 319 472 784];
DigitICA = cell (4,length(dimensions));

%read training data
trainSize = 3000;
testSize = 500;
%trainSize = 300;
%testSize = 10;

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
%load DigitPCA
%eigenVecs = DigitPCA{3,1};
%eigenVals = diag ( DigitPCA{4,1} );
%clear DigitPCA;

% normalize
[pn,meanp,stdp] = prestd(ALL');

for i = 1:length(dimensions)
    display (['processing dimension ' num2str(dimensions(i))]);

    % principal component analysis to reduce dimension
    %    [ptrans,transMat] = prepca(pn,100-curstd);
    tic;
 %   [icasig, A, W] = fastica (pn, 'lastEig', dimensions(i), 'pcaE', eigenVecs(:,1:dimensions(i)), ...
 %               'pcaD', eigenVals(1:dimensions(i),1:dimensions(i)), 'verbose', 'off');
  
    [icasig, A, W] = fastica (pn, 'lastEig', dimensions(i));
   
    clear W;
    DigitICA{3,i} = toc;
    DigitICA{1,i} = dimensions(i);
    DigitICA{2,i} = A;
    DigitICA{4,i} = max(max (corr(icasig')-eye(size(icasig,1))));

    %reconstruct 5th picture
    figure;
    colormap gray;
    imagesc ( reshape (A(5,:)*icasig,28,28)' );
    title (['Sample projected on ' num2str(dimensions(i)) ' independent vectors']);
    print ('-dpng', ['ica_proj_' num2str(dimensions(i)) '.png']);

    % show examples of pictures
    figure;
    colormap gray;
    imagesc ( reshape(icasig(1,:),28,28)' );
    title (['Independet image for dimension ' num2str(dimensions(i)) ]);
    print ('-dpng', ['ica_sample_' num2str(dimensions(i)) '.png']);
    % figure;
    % colormap gray;
    % imagesc ( reshape(icasig(3,:),28,28)' );
    % title (['Independet image for dimension ' num2str(dimensions(i)) ]);

    % plot distribution of kurtosis
    figure;
    hist(kurtosis( icasig'));
    title(['Distribution of kurtosis for ' num2str(dimensions(i)) ' dimensions']);
    print ('-dpng', ['ica_kurt_' num2str(dimensions(i)) '.png']);
end

save DigitICA.mat DigitICA

end