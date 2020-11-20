function [percentage] = percent_error(true, estimated)
%outputs percent error given true and estimated symbol vectors
test = abs(true - estimated);
test(test<5e-3) = 0;
test(test>5e-3) = 1;
percentage = sum(abs(test))/length(true);

end

