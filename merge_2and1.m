function [ L ] = merge_2and1( A, B )
% |A| = 2, and |B| = 1
L = [];
D = [];
C = [A; B];
Slope_up = [];
%store sorted lines into D
Slope_up = [Slope_up; min(C(:,1))];
for i = 1: 1: size(C,1)
    if Slope_up(1) == C(i,1)
        C(i,:) = [];
        break;
    end
end
Slope_up = [Slope_up; min(C(:,1))];
Slope_up = [Slope_up; max(C(:,1))];
C = [A; B];
for i = 1: 1 : 3
    for j = 1 : 1 : 3
        if C(j, 1) == Slope_up(i)
            D = [D; C(j,:)];
            continue;
        end
    end
end
        
%intersection of line 1 with line2
[x12,y12] = line_intersect(D(1,1), D(1,2), D(2,1), D(2,2));
%intersection of line 1 with line 3
[x13,y13] = line_intersect(D(1,1), D(1,2), D(3,1), D(3,2)); 

if x13 <= x12
    %line 1 intersect with line 3 first
    L = [L; D(1,1), D(1,2), D(1,3), D(1,4), x13, y13];
    L = [L; D(3,1), D(3,2), x13, y13, D(3,5), D(3,6)];
else
    [x23,y23] = line_intersect(D(3,1), D(3,2), D(2,1), D(2,2));
    L = [L; D(1,1), D(1,2), D(1,3), D(1,4), x12, y12];
    L = [L; D(2,1), D(2,2), x12, y12, x23, y23];
    L = [L; D(3,1), D(3,2), x23, y23, D(3,5), D(3,6)];
end
    

end

