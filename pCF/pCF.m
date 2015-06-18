%calculate the pair correlation carpet

%option = 1: fix distance
%option = 2: fix one column
%option = 3: fix distance, reverse direction
function [G] = pCF(c1,c2,dis,option)

c1 = c1';
c2 = c2';

dim2 = size(c1,2);

%fixed distance between coloumns
if option == 1
    for i = 1:dim2-dis
        G(:,i) = single_corr(c1(:,i),c2(:,i+dis));
    end
end

%fix one column
if option == 2
    for i = 1:dim2
        G(:,i) = single_corr(c1(:,dis),c2(:,i));
    end
end

%fixed distance between coloumns
if option == 3
    for i = 1:dim2-dis
        G(:,i) = single_corr(c1(:,i+dis),c2(:,i));
    end
end

end
