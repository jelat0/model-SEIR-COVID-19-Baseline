function LHSmatrix = Model_LHS(xminlist,xmaxlist,...
                        nsample,distrib,threshold)

%% The results should be compared to the PRCC results section in
%% Supplementary Material D and Table D.1 for different N (specified by
%% "runs" in the script below
% if nargin<7
%     threshold = 1e20;
% end

%% Sample size N
runs = nsample;

dummymean = 0;
dummysd = 0;
LHSmatrix = zeros(runs, length(xminlist));
if distrib == 'unif'
    for i = 1:length(xminlist)
        xminparam = xminlist(i);
        xmaxparam = xmaxlist(i);
        LHSmatrix(:, i) = LHS_Call(xminparam, dummymean, xmaxparam, dummysd, ...
                                    runs, distrib, threshold);
end

%% Save the workspace
save('Model_LHS.mat', 'LHSmatrix');
end