%Upper Line Removal
%eleminate vertical and duplicate lines first
%Get the nuber of lines from input
LARGE_NUMBER = 1000;
%num_lines = input('Input the number of lines: ');
figure (1);
X = [];
Y = [];
P = [];
set(gcf,'currentchar',' ')         % set a dummy character
while get(gcf,'currentchar')==' '  % which gets changed when key is pressed
    [x_pair,y_pair] = ginput(2);
    if isempty(x_pair) 
        break;
    end
    %eliminate vertical line
    if x_pair(1) == x_pair(2)
        fprintf('Vertical line eliminated.');
        continue;
    end
    p_single = polyfit(x_pair,y_pair,1);
    P = [P;p_single];
    X = [X; x_pair];
    Y = [Y; y_pair];
    x_pair = [-1 ; 2];
    y_pair(1) = x_pair(1)*p_single(1) + p_single(2);
    y_pair(2) = x_pair(2)*p_single(1) + p_single(2);
    line(x_pair,y_pair);
    
    axis([0 1 0 1]);
    hold on;  
end
hold off;

%input('Press any key to continue: ');
%eliminate duplicate lines
if size(P,1) > 1
    for i = 2 : 1 : size(P,1)
        if P(i, :) == P(i-1, :)
            P(i, :) = [];
            i = i - 1;
        end
    end
end
L = zeros(size(P,1),6);
L(1:size(L,1), 1:2) = P;
for i = 1 : 1 : size(L,1)
    if L(i,1) < 0
        L(i,3:6) = [-Inf, Inf, Inf, -Inf];
    elseif L(i,1)> 0
        L(i,3:6) = [-Inf, -Inf, Inf, Inf];
    else
        L(i,3:6) = [-Inf, 0, Inf, 0];
    end
end


Result = ALG(L);

%To plot line segments, replace Inf and -Inf with large numbers.
%only the first and last line segments need to be checked.
i = 1;
if isinf(Result(i,3))
    if Result(i,3) > 0
        Result(i,3) = LARGE_NUMBER;
    else
        Result(i,3) = -LARGE_NUMBER;
    end
    Result(i,4) = Result(i,3) * Result(i,1) + Result(i,2);
end
i = size(Result,1);
if isinf(Result(i,5))
    if Result(i,5) > 0
        Result(i,5) = LARGE_NUMBER;
    else
        Result(i,5) = -LARGE_NUMBER;
    end
    Result(i,6) = Result(i,5) * Result(i,1) + Result(i,2);
end

figure(2);
for i = 1 : 1 : size(Result,1)
    x_p = [Result(i,3), Result(i,5)];
    y_p = [Result(i,4), Result(i,6)];
    line(x_p,y_p);
    axis([0 1 0 1]);
    hold on;  
end
    hold off;

