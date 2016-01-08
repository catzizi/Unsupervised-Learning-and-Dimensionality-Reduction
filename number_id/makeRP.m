function [] = makeRP ()

dimensions = [7 10 37 91 154 228 319 472];

DigitRP = cell(4, length(dimensions));

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

ALL = pn';
minr = 0;
bestQ =[];
err = zeros(1, 10);
maxruns = 12000;

for i=1:length(dimensions)
    for runs=1:maxruns
       if mod(runs,100) == 0
           display (['dim: ' num2str(dimensions(i)) ' - run ' num2str(runs) ' of 2000']);
       end
       tic
       A = rand ( dimensions(i), size(ALL,1));
       [Q,R] = qr(A',0);
       Q = Q';
       %Q holds projection matrix
       %cals error;
       B = Q*ALL;
       E = ALL - Q'*B;
       err(i) = sum(sum(E.*E));
       
       if runs ==1
           DigitRP{1,i} = toc*maxruns;
           minr = err(i);
           bestQ = Q;
           DigitRP{2,i} = dimensions(i);
           DigitRP{3,i} = B;
       else
          if  minr > err(i) 
           DigitRP{1,i} = toc*maxruns;
           minr = err(i);
           bestQ = Q;
           DigitRP{2,i} = dimensions(i);
           DigitRP{3,i} = B;
          end           
       end
    end
    
    DigitRP{4,i} = err;
    
    % show examples of pictures
    figure;
    colormap gray;
    imagesc ( reshape(bestQ(1,:),28,28)' );
    title (['Sample for random projection base vector (dim=' num2str(dimensions(i)) ')']);
    print ('-dpng', ['rp_sample1_' num2str(dimensions(i)) '.png']);
    figure;
    colormap gray;
    imagesc ( reshape(bestQ(2,:),28,28)' );
    title (['Sample for random projection base vector (dim=' num2str(dimensions(i)) ')']);
    print ('-dpng', ['rp_sample2_' num2str(dimensions(i)) '.png']);
    figure;
    colormap gray;
    imagesc ( reshape(bestQ(3,:),28,28)' );
    title (['Sample for random projection base vector (dim=' num2str(dimensions(i)) ')']);
    print ('-dpng', ['rp_sample3_' num2str(dimensions(i)) '.png']);
    
    %reconstruct 5th picture
    B = DigitRP{3,i};
    figure;
    colormap gray;
    imagesc ( reshape ( bestQ'*B(:,5) ,28,28)' );
    title (['Sample projected on ' num2str(dimensions(i)) ' random base vectors']);
    print ('-dpng', ['rp_proj_' num2str(dimensions(i)) '.png']);
    
    save DigitRP.mat DigitRP

end

save DigitRP.mat DigitRP