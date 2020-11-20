function [percentage] = percentage_correct(true, estimated)
test = true == estimated;
percentage = sum(test)/length(true);
end

