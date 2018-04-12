function [ L ] = ALG( L )
%Divide-and-conquer algorithm, takes a sequence of x-coordinate sorted
%distinct line segments as input, returns x-coordinate sorted line segments
if size(L,1) == 1
    return
end
size_subset = ceil(size(L,1) / 2);
A = ALG(L(1 : size_subset, 1:size(L,2)));
B = ALG(L(size_subset + 1 : size(L,1), 1:size(L,2)));
L = merge(A,B);
end

