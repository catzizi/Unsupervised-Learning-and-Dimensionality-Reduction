function [] = makeEM ()

testK = [ 5 10 20 ];

NucleusKEM = cell(7,length(testK));
testK = 2:10;

data = textread('wdbc.data', '%s', 'delimiter', ',', 'emptyvalue', 0);
data = reshape(data, 32, 569 );
A = str2double(data(3:end, :));
L = double(cell2mat ( data(2,:) ) == 'M');

A = A';

for i=1:length(testK)
    
    my_var =0;
    for run=1:10
        tic;
        [c,z,pi,w,Q] = mixtureEM(A', testK(i),1.0);
        if run==1
            myvar = Q;

            NucleusKEM{1,i} = testK(i);
            NucleusKEM{2,i} = toc
            NucleusKEM{3,i} = c;
            NucleusKEM{4,i} = z;
            NucleusKEM{5,i} = w;
            NucleusKEM{6,i} = pi;
        else
            if Q > myvar
                myvar = Q;
                NucleusKEM{1,i} = testK(i);
                NucleusKEM{2,i} = toc
                NucleusKEM{3,i} = c;
                NucleusKEM{4,i} = z;
                NucleusKEM{5,i} = w;
                NucleusKEM{6,i} = pi;
            end
        end

    end
    
    %reconstruct
    B = (z*w)';
    NucleusKEM{7,i} = sum(sqrt(sum ((A-B) .* (A-B),2)));
    
end;

save NucleusKEM.mat NucleusKEM;
