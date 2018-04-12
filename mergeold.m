function [ L ] = merge( A, B )
%Merge two line(segment) list into one
%   If a line could be expressed as y = ax + b, and two end points expressed
%   as {(x0,y0), (x1, y1)}, then each row stores the line information as
%   [a,b,x0,y0,x1,y1]; 
%   If the value of end point is infinity, the value of "Inf" would be
%   used. "isinf()" function could be used as judgement
L = [];
if (size(A,1) + size(B,1) <= 3)
    if size(A,1) == 1 && size(B,1) == 1
        [x,y] = line_intersect(A(1,1), A(1,2), B(1,1), B(1,2));
        if A(1,1) == 0 || B(1,1) == 0
            fprintf('Line slope can not be zero');
            return;
        end
        if A(1,1) < 0 && B(1,1) > 0
            L = [L; A(1,1), A(1,2), -Inf, Inf, x, y];
            L = [L; B(1,1), B(1,2), x, y, Inf, Inf];
            return;
        end
        if B(1,1) < 0 && A(1,1) > 0
            L = [L; B(1,1), B(1,2), -Inf, Inf, x, y];
            L = [L; A(1,1), A(1,2), x, y, Inf, Inf];
            return;
        end
        if (A(1,1) < 0 && B(1,1) < 0) && (A(1,1) < B(1,1))
            L = [L; A(1,1), A(1,2), -Inf, Inf, x, y];
            L = [L; B(1,1), B(1,2), x, y, Inf, -Inf];
            return;
        end
        if (A(1,1) < 0 && B(1,1) < 0) && (A(1,1) > B(1,1))
            L = [L; B(1,1), B(1,2), -Inf, Inf, x, y];
            L = [L; A(1,1), A(1,2), x, y, Inf, -Inf];
            return;
        end
        if (A(1,1) > 0 && B(1,1) > 0) && (A(1,1) < B(1,1))
            L = [L; A(1,1), A(1,2), -Inf, -Inf, x, y];
            L = [L; B(1,1), B(1,2), x, y, Inf, Inf];
            return;
        end
        if (A(1,1) > 0 && B(1,1) > 0) && (A(1,1) > B(1,1))
            L = [L; B(1,1), B(1,2), -Inf, -Inf, x, y];
            L = [L; A(1,1), A(1,2), x, y, Inf, Inf];
            return;
        end
    else
        % |A| + |B| == 3
        if size(A,1) == 2 && size(B,1) == 1
            L = merge_2and1(A,B);
        else
            L = merge_2and1(B,A);
        end
        return;       
    end
end
idx_A = 1;      %current pointer
idx_B = 1;
% current_list = 1: point to A, current_list = 2: point to B
current_list = 1;
if A(1,1) > B(1,1)
    current_list = 2;
end

while idx_A <= size(A,1) && idx_B <= size(B,1)
    [x,y] = line_intersect(A(idx_A,1), A(idx_A,2), B(idx_B,1), B(idx_B,2)); 
    Endpoints_x = [A(idx_A,3), A(idx_A,5), B(idx_B,3), B(idx_B,5)];
    Endpoints_y = [A(idx_A,4), A(idx_A,6), B(idx_B,4), B(idx_B,6)];
    Sorted_x = sort(Endpoints_x);
    Sorted_y = sort(Endpoints_y);
    if x >= Sorted_x(2) && x <= Sorted_x(3) && y >= Sorted_y(2) && y <= Sorted_y(3)
        %two segments intersected
        if current_list == 1
            L = [L; A(idx_A,1), A(idx_A,2), A(idx_A,3), A(idx_A,4), x, y];
            current_list = 2;
        else
            L = [L; B(idx_B,1), B(idx_B,2), B(idx_B,3), B(idx_B,4), x, y];
            current_list = 1;
        end  
        %replace two lists' first element's start point
        A(idx_A,3) = x;
        A(idx_A,4) = y;
        B(idx_B,3) = x;
        B(idx_B,4) = y;
    else
        if A(idx_A,5) > B(idx_B,5)
            if current_list == 2
                L = [L; B(idx_B,:)];
            end
            idx_B = idx_B + 1;
        elseif A(idx_A,5) < B(idx_B,5)
            if current_list == 1
                L = [L; A(idx_A,:)];
            end
            idx_A = idx_A + 1;
        else
            %two segments' ending points' X coordinates are the same
            %the last step must be this
            if current_list == 1
                L = [L; A(idx_A,:)];
            end
            if current_list == 2
                L = [L; B(idx_B,:)];
            end
            idx_A = idx_A + 1;
            idx_B = idx_B + 1;     
        end
    end
end

end

