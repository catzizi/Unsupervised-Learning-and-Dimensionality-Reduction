function [] = makeICA ()

dimensions = [2 3 5];
DigitICA = cell (4,length(dimensions));

data = textread('wdbc.data', '%s', 'delimiter', ',', 'emptyvalue', 0);
data = reshape(data, 32, 569 );
A = str2double(data(3:end, :));
L = double(cell2mat ( data(2,:) ) == 'M');
ALL = A';
pn = ALL;

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

    % plot distribution of kurtosis
    figure;
    hist(kurtosis( icasig'));
    title(['Distribution of kurtosis for ' num2str(dimensions(i)) ' dimensions']);
end

save DigitICA.mat DigitICA

end