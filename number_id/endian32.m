function [ res ] = endian32( in )

%assume in to be 32 bit
l1 =  bitshift ( bitand ( in, hex2dec ('000000ff') ), 24 );
l2 =  bitshift ( bitand ( in, hex2dec ('0000ff00') ), 8);
l3 =  bitshift ( bitand ( in, hex2dec ('00ff0000') ), -8 );
l4 =  bitshift ( bitand ( in, hex2dec ('ff000000') ), -24 );

res = bitor ( l1, bitor(l2, bitor(l3, l4)));