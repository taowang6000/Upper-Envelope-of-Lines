function [ x_intersect, y_intersect ] = line_intersect( a1,b1,a2,b2 )
%Calculate intersection of two lines: y = a1x + b1 and y = a2x +b2
p1 = [a1,b1];
p2 = [a2,b2];
%calculate intersection
x_intersect = fzero(@(x) polyval(p1-p2,x),3);
y_intersect = polyval(p1,x_intersect);

end

