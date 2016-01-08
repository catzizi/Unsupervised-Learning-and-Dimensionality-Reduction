load ResultsKmean_NN;
RKmean = Results;
dims = [ 5 10 15 ];
load ResultsKEM_NN;
RKEM = Results;

plot ( dims, RKmean(1,:), '-b+', dims, RKmean(2,:), '-k*', dims, RKEM(1,:), '-gx', ...
    dims,  RKEM(2,:), '-r.');
xlim = get(gca,'xlim');
line( xlim, 103.07 * ones(1,2), 'Color', 'b' );
legend( {'k-means', 'k-means reg.', 'EM', 'EM reg.'} );
title('classification times for clustered data');
xlabel ('dimension');
ylabel ('time');

figure;
plot( dims, RKmean(3,:), '-b+', dims, RKmean(4,:), '-k*', dims, RKEM(3,:), '-gx', ...
    dims,  RKEM(4,:), '-r.');
xlim = get(gca,'xlim');
line( xlim, 0.742 * ones(1,2), 'Color', 'b' );
legend( {'k-means', 'k-means reg.', 'EM', 'EM reg.'} );
xlabel ('dimension');
ylabel ('accuracy');
title('classification accuracy for clustered data');
