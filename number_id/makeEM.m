function [] = makeEM ()

testK = [ 5 10 20 ];
DigitKEM = cell(6,length(testK));

%read training data
trainSize = 3000;
testSize = 500;
%trainSize = 1200;
%testSize = 200;

[A,L] = readData(0,trainSize);
L = L';
[TestA, TestL] = readData(1,testSize);
TestL = TestL';

A = reshape (A, size(A,1)*size(A,2), size(A,3) );
TestA = reshape (TestA, size(TestA,1)*size(TestA,2), size(TestA,3) );

% A is 784 by 5000 matrix

% pack all data into one matrix to reduce dataset
ALL = [ A, TestA ];

% normalize
[pn,meanp,stdp] = prestd(ALL');
A = pn(1:size(A,2),:);
TestA = pn(size(A,2)+1:end,:);

for i=1:length(testK)
    
    my_var =0;
    for run=1:3
        tic;
        [c,z,pi,w,Q] = mixtureEM(A', testK(i),1.0);
        if run==1
            myvar = Q;

            DigitKEM{1,i} = testK(i);
            DigitKEM{2,i} = toc
            DigitKEM{3,i} = c;
            DigitKEM{4,i} = z;
            DigitKEM{5,i} = w;
            DigitKEM{6,i} = pi;
        else
            if Q > myvar
                myvar = Q;
                DigitKEM{1,i} = testK(i);
                DigitKEM{2,i} = toc
                DigitKEM{3,i} = c;
                DigitKEM{4,i} = z;
                DigitKEM{5,i} = w;
                DigitKEM{6,i} = pi;
            end
        end

    end

    %cluster samples
    figure;
    colormap gray;
    imagesc ( reshape(z(:,1),28,28)' );
    title (['1st mean (k=' num2str(testK(i)) ')']);
    figure
    colormap gray;
    imagesc ( reshape(z(:,2),28,28)' );
    title (['2nd mean (k=' num2str(testK(i)) ')']);
    figure
    colormap gray;
    imagesc ( reshape(z(:,3),28,28)' );
    title (['3rd mean (k=' num2str(testK(i)) ')']);
    
    %reconstruct
    B = z*w;
    figure
    colormap gray;
    imagesc ( reshape(B(:,5),28,28)' );
    title (['K-means sample (k=' num2str(testK(i)) ')']);
    
    save DigitKEM.mat DigitKEM;
    
end;

save DigitKEM.mat DigitKEM;
