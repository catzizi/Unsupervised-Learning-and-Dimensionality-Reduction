function [ A, L ] = readData( readTest, maxNum )
% reads the Database of digits

labelFile = 'train-labels.idx1-ubyte';
imgFile = 'train-images.idx3-ubyte';    

if ( nargin > 0 && readTest == 1)
labelFile = 't10k-labels.idx1-ubyte';
imgFile = 't10k-images.idx3-ubyte';
end

labelId = fopen (labelFile);
imgId = fopen (imgFile);

% read labels
%skip magic number
fread( labelId, 1, 'int32' );
numElems = fread (labelId, 1, 'int32');
% convert endian
numElems = endian32 (numElems);

if nargin >1 % max specified ?
    numElems = min (maxNum, numElems);
end

L = fread ( labelId, numElems, 'uchar' );

%read images
fread (imgId, 1, 'int32' );
numElems2 = endian32 (fread (imgId, 1, 'int32' ));

numElems = min(numElems, numElems2);

sx = endian32 (fread (imgId, 1, 'int32' ));
sy = endian32 (fread (imgId, 1, 'int32' ));

A =  reshape (255 - fread(imgId, numElems*sx*sy, 'uchar' )', ...
        sx, sy, numElems );

%access images via A(:,:,i)'




