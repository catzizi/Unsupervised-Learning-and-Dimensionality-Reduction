
function [] = nn ( networkconfig )

data = textread('wdbc.data', '%s', 'delimiter', ',', 'emptyvalue', 0);
data = reshape(data, 32, 569 );
A = str2double(data(3:end, :));
L = double(cell2mat ( data(2,:) ) == 'M');

[pn,meanp,stdp] = prestd(A);
[ptrans,transMat] = prepca(pn,0.001);

A = ptrans;

%reduce from 30 to 20
TestA = A(:, 1:3:end);
A = [ A(:, 2:3:end) A(:, 3:3:end) ];
TestL = L(:, 1:3:end);
L = [ L(:, 2:3:end) L(:, 3:3:end) ];

ValiA = A(:, 1:3:end);
A = [ A(:, 2:3:end) A(:, 3:3:end) ];
ValiL = L(:, 1:3:end);
L = [ L(:, 2:3:end) L(:, 3:3:end) ];

ACombined = [ A ValiA ];
LCombined = [ L ValiL ];

%% build nn
functions = {};
for j = 1:length(networkconfig)
    functions = { functions{:}, 'tansig' };
end

%functions = { functions{:}, 'purelin' };

net = newff ( minmax(A), networkconfig,functions, 'trainrp' );

validation.P = ValiA;
validation.T = ValiL;
%validation.T = ValiL;
testing.P = TestA;
testing.T = TestL;
%testing.T = TestL;
net.trainParam.show =10;
net.trainParam.epochs = 1000;

net2 = net;
net2.performFcn = 'msereg';
net2.performParam.ratio = 0.5;

keyboard;

tic;
[net,tr] = train(net, A, L, [], [], validation,testing);
display ([ 'training time: ' num2str(toc) ] );
%[net,tr] = train(net, A, L, [], [], validation,testing);

keyboard;

tic;
[net2,tr2] = train(net2, A, L, [], [], validation,testing);
display ([ 'training time with reg. : ' num2str(toc) ] );

%output graphs
figure;
semilogy(tr.epoch,tr.perf,tr.epoch,tr.vperf,tr.epoch,tr.tperf)
legend('Training','Validation','Test',-1);
ylabel('Squared Error'); xlabel('Epoch');
title ( [ 'Training Error for network ' mat2str(networkconfig)] );  

figure;
semilogy(tr2.epoch,tr2.perf,tr2.epoch,tr2.vperf,tr2.epoch,tr2.tperf)
legend('Training','Validation','Test',-1);
ylabel('Squared Error'); xlabel('Epoch');
title ( [ 'Training Error for network ' mat2str(networkconfig) ' with regularization'] );  

Y = sim ( net, TestA );
Y2 = sim (net2, TestA );

Y = Y > 0.5;
Y2 = Y > 0.5;
display ( ['class. rate for ' mat2str(networkconfig) ...
    ' : ' num2str(  sum(Y == TestL ) / length(TestL)) ] ); 

display ( ['class. rate for ' mat2str(networkconfig) ...
    ' with regularization: ' num2str( sum ( Y == TestL ) / length(TestL)) ] );