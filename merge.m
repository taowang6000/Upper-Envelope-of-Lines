function [ L ] = merge( A, B )
%Merge two line(segment) list into one
%   If a line could be expressed as y = ax + b, and two end points expressed
%   as {(x0,y0), (x1, y1)}, then each row stores the line information as
%   [a,b,x0,y0,x1,y1]; 
%   If the value of end point is infinity, the value of "Inf" would be
%   used. "isinf()" function could be used as judgement
LARGE_VALUE = 1000;
intrsct = 0;                          %If lines intesect
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
    %use two points to represent all the line segments, if the coordinate 
    %is Inf or -Inf, turn them int large numbers
    x1 = A(idx_A,3);
    x2 = A(idx_A,5);
    x3 = B(idx_B,3);
    x4 = B(idx_B,5);
    y1 = A(idx_A,4);
    y2 = A(idx_A,6);
    y3 = B(idx_B,4);
    y4 = B(idx_B,6);
    if isinf(x1) || isinf(x2)
        if isinf(x1)
            if x1 > 0
                x1 = LARGE_VALUE;
            else
                x1 = -LARGE_VALUE;
            end
            y1 = x1 * A(idx_A,1) + A(idx_A,2);
        end
        if isinf(x2)
            if x2 > 0
                x2 = LARGE_VALUE;
            else
                x2 = -LARGE_VALUE;
            end
            y2 = x2 * A(idx_A,1) + A(idx_A,2);
        end
    end
    if isinf(x3) || isinf(x4)
        if isinf(x3)
            if x3 > 0
                x3 = LARGE_VALUE;
            else
                x3 = -LARGE_VALUE;
            end
            y3 = x3 * B(idx_B,1) + B(idx_B,2);
        end
        if isinf(x4)
            if x4 > 0
                x4 = LARGE_VALUE;
            else
                x4 = -LARGE_VALUE;
            end
            y4 = x4 * B(idx_B,1) + B(idx_B,2);
        end
    end
    x=[x1 x2 x3 x4];
    y=[y1 y2 y3 y4];
    dt1=det([1,1,1;x(1),x(2),x(3);y(1),y(2),y(3)])*det([1,1,1;x(1),x(2),x(4);y(1),y(2),y(4)]);
    dt2=det([1,1,1;x(1),x(3),x(4);y(1),y(3),y(4)])*det([1,1,1;x(2),x(3),x(4);y(2),y(3),y(4)]);

    if(dt1<=0 && dt2<=0)
        intrsct=1;         %If lines intesect
    else
        intrsct=0;
    end
    if intrsct == 1
        [xx,yy] = line_intersect(A(idx_A,1), A(idx_A,2), B(idx_B,1), B(idx_B,2));
        %two segments intersected
        if current_list == 1
            L = [L; A(idx_A,1), A(idx_A,2), A(idx_A,3), A(idx_A,4), xx, yy];
            current_list = 2;
        else
            L = [L; B(idx_B,1), B(idx_B,2), B(idx_B,3), B(idx_B,4), xx, yy];
            current_list = 1;
        end  
        %replace two lists' first element's start point
        A(idx_A,3) = xx;
        A(idx_A,4) = yy;
        B(idx_B,3) = xx;
        B(idx_B,4) = yy;
        
        %will not intersect again
        %compare two segments' ending points' x coordinate value
        if A(idx_A,5) < B(idx_B,5)
            idx_A = idx_A + 1;
                if current_list == 1
                    L = [L; A((idx_A - 1), :)];
                end
        elseif A(idx_A,5) > B(idx_B,5)
            idx_B = idx_B + 1;
                if current_list == 2
                    L = [L; B((idx_B - 1), :)];
                end
        else
            % A(idx_A,5) == B(idx_B,5)
            idx_A = idx_A + 1;
            idx_B = idx_B + 1;
            if idx_A > size(A,1)
                if current_list == 1
                    L = [L; A((idx_A - 1), :)];
                end
            end
            if idx_B > size(B,1)
                if current_list == 2
                    L = [L; B((idx_B - 1), :)];
                end
            end
        end        
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

