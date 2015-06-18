K = 0.1;
sigma = 5;
theta = 0;

for i = 1:5000
    R(i) = gprnd(K,sigma,theta);
end

hist(R,20)