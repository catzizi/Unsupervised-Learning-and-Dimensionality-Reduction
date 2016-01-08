function [] = makeClusters ()

testK = [ 2 3 4 5 ];
NucleusKmean = cell(3,length(testK));

data = textread('wdbc.data', '%s', 'delimiter', ',', 'emptyvalue', 0);
data = reshape(data, 32, 569 );
A = str2double(data(3:end, :));
L = double(cell2mat ( data(2,:) ) == 'M');

A = A';

for i=1:length(testK)
    my_var =0;
    for run=1:10
        tic;
        [ IDX, C, sumd ] =  kmeans(A,testK(i));
        if run==1
            myvar = var(sumd);

            NucleusKmean{1,i} = testK(i);
            NucleusKmean{2,i} = toc
            NucleusKmean{3,i} = IDX;
            NucleusKmean{4,i} = C;
        else
            if var(sumd) < myvar
                myvar = var(sumd);
                NucleusKmean{1,i} = testK(i);
                NucleusKmean{2,i} = toc
                NucleusKmean{3,i} = IDX;
                NucleusKmean{4,i} = C;
            end
        end

    end
    %normalize sumd
    for j=1:testK(i)
        sumd(j) = sumd(j) ./ sum(IDX==j);
    end

    sumd = sort(sumd);

    figure;
    bar(sumd);
    title(['mean cluster distance (k=' num2str(testK(i)) ')']);
end;

save NucleusKmean.mat NucleusKmean;
