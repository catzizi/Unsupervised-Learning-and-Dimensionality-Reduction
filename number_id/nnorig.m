
function [] = nnorig ( networkconfig )

%read training data
trainSize = 3000;
testSize = 500;

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

ALL = [ A, TestA ];

% normalize
[pn,meanp,stdp] = prestd(ALL');

% seperate training and dataset
ptrans = pn';
A = ptrans(:, 1:size(A,2));
TestA = ptrans(:, size(A,2)+1:end);

% devide A in further to obtain Validation set
% 1/3 to 2/3
ValiA = A(:, 1:3:end);
A = [ A(:, 2:3:end) A(:, 3:3:end) ];
ValiLBin = LBin(:, 1:3:end);
LBin = [ LBin(:, 2:3:end) LBin(:, 3:3:end) ];
ValiL = L(:, 1:3:end);
LCur = [ L(:, 2:3:end) L(:, 3:3:end) ];

% build nn
functions = {};
for j = 1:length(networkconfig)
    functions = { functions{:}, 'tansig' };
end

net = newff ( minmax(A), networkconfig,functions, 'trainrp' );
net.trainParam.show = 500; % no display
net.trainParam.epochs = 1000;

net2 = newff ( minmax(A), networkconfig,functions, 'trainrp' );
net2.performFcn = 'msereg';
net2.performParam.ratio = 0.5;
net2.trainParam.show = 500; % no display
net2.trainParam.epochs = 1000;

validation.P = ValiA;
validation.T = ValiLBin;
testing.P = TestA;
testing.T = TestLBin;

tic;
[net,tr] = train(net, A, LBin, [], [], validation,testing);
toc

tic;
[net2,tr2] = train(net2, A, LBin, [], [], validation,testing);
toc

Y = sim ( net, TestA );
Y2 = sim (net2, TestA );

[k,l] = max(Y);
1 - sum ( l-1 ~= TestL ) / testSize
[k,l] = max(Y2);
1 - sum ( l-1 ~= TestL ) / testSize