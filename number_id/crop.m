function [ A ] = crop( A, mask )

if nargin < 2
    mask = 255
end

[sy,sx] = size(A);

minx = 1;
miny = 1;
maxx = sx;
maxy = sy;

for i = 1:sx
    if min (A(:,i)) == mask
        minx = minx + 1;
    else
        break;
    end
end

for i = sx:-1:1
    if min (A(:,i)) == mask
        maxx = maxx - 1;
    else
        break;
    end
end

for i = 1:sy
    if ( min ( A(i,:)) == mask)
        miny = miny +1;
    else
        break;
    end
end

for i = sy:-1:1
    if ( min (A(i,:)) == mask)
        maxy = maxy -1;
    else
        break;
    end
end


A = imcrop (A, [minx, miny, maxx-minx, maxy-miny ] );
