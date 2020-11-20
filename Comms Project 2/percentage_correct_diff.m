function [percentage] = percentage_correct_diff(true, estimated)
test = true == estimated;
percentage = sum(angle(test))/(length(true) - 1);
end

