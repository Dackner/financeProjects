function [inSampleData, outSampleData, evaluationSampleData] = splitData()
%1splitData
%   trello 1
%   Splits data into in-sample (64%) data and out-of-sample data (36%)
%   prices.mat must be in directory
%   prices in ascending date order; earliest data first
prices = load('prices.mat');
tmp = prices.inS;
inSampleData = tmp(1:floor(size(tmp,1)/2),:);
outSampleData = tmp(floor(size(tmp,1)/2) + 1:end,:);
evaluationSampleData = prices.outS;
end



