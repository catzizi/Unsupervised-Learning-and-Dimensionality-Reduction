load ResultsICA_NN;
RICA = Results;
RICAdims = [ 5 7 10 25 37 50 91 154 228 319 472 784];
load ResultsPCA_NN;
RPCA = Results;
RPCAdims = [ 784 472 319 228 154 91 37 7 ];
load ResultsRP_NN;
RRP = Results;
RRPdims = [ 5 10 37 91 154 228 319 472];
load ResultsMean_NN
RM = Results;
RMdims = [2];
load ResultsDown_NN
RD = Results;
RDdims = [49];

semilogx ( RICAdims, RICA(1,:), '-b+', RPCAdims, RPCA(1,:), '-k*', RRPdims, RRP(1,:), '-gx', ...
    RMdims,  RM(1), '-r.', RDdims, RD(1), '-mo');
xlim = get(gca,'xlim');
line( xlim, 103.07 * ones(1,2), 'Color', 'b' );
legend( {'ICA', 'PCA', 'RP', 'Color Mean', 'Downsample by 4'} );
title('classification times for dimension reduction algorithms');
xlabel ('dimension');
ylabel ('time');

figure;
semilogx ( RICAdims, RICA(2,:), '-b+', RPCAdims, RPCA(2,:), '-k*', RRPdims, RRP(2,:), '-gx', ...
    RMdims,  RM(2), '-r.', RDdims, RD(2), '-mo');
xlim = get(gca,'xlim');
line( xlim, 207.17 * ones(1,2), 'Color', 'b' );
legend( {'ICA', 'PCA', 'RP', 'Color Mean', 'Downsample by 4'}, 'Location', 'NorthWest');
title('classification times for dimension reduction algorithms with regulation');
xlabel ('dimension');
ylabel ('time');

figure;
semilogx ( RICAdims, RICA(3,:), '-b+', RPCAdims, RPCA(3,:), '-k*', RRPdims, RRP(3,:), '-gx', ...
    RMdims,  RM(3), '-r.', RDdims, RD(3), '-mo');
xlim = get(gca,'xlim');
line( xlim, 0.742 * ones(1,2), 'Color', 'b' );
legend( {'ICA', 'PCA', 'RP', 'Color Mean', 'Downsample by 4'}, 'Location', 'SouthWest');
title('classification accuracy for dimension reduction algorithms');
xlabel ('dimension');
ylabel ('accuracy');


figure;
semilogx ( RICAdims, RICA(4,:), '-b+', RPCAdims, RPCA(4,:), '-k*', RRPdims, RRP(4,:), '-gx', ...
    RMdims,  RM(4), '-r.', RDdims, RD(4), '-mo');
xlim = get(gca,'xlim');
line( xlim, 0.86 * ones(1,2), 'Color', 'b' );
legend( {'ICA', 'PCA', 'RP', 'Color Mean', 'Downsample by 4'}, 'Location', 'SouthWest');
title('classification accuracy for dimension reduction algorithms with regulation');
xlabel ('dimension');
ylabel ('accuracy');