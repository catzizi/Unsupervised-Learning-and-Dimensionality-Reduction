function [] = makePCA ()

teststd = [ 100 99.9 99 97.5 95 90 75 33 ];
teststd = teststd / 100;
DigitPCA = cell(4, length(teststd));
data = textread('wdbc.data', '%s', 'delimiter', ',', 'emptyvalue', 0);
data = reshape(data, 32, 569 );
A = str2double(data(3:end, :));
L = double(cell2mat ( data(2,:) ) == 'M');
ALL = A';

% normalize
%[pn,meanp,stdp] = prestd(ALL');
% discard any components with 0 stdev --> no information
%pn = pn( stdp ~= 0, : );

% principal component analysis to reduce dimension
%    [ptrans,transMat] = prepca(pn,100-curstd);
tic;
[COEFF,SCORE,latent] = princomp(ALL);
toc;

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
xlabel ('dimension')
ylabel('eigenvalue');
%mark marker std :)
for i=1:length(teststd)
   ylim = get(gca,'ylim');
   line( DigitPCA{1,i} * ones(1,2), ylim, 'Color', 'b' );
   text ( DigitPCA{1,i} + 0.1, ylim(1) + (ylim(2)-ylim(1)) * ( 0.15 + 0.7 * (i-1) / length(teststd)), ...
       num2str(teststd(i)), 'FontWeight', 'bold');
end


save DigitPCA.mat DigitPCA