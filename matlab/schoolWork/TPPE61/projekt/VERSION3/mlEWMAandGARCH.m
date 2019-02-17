function [xOpt,outOfSampleLogLikelihood,ll] = mlEWMAandGARCH(r, rOut,model)
%MLEWMAANDGARCH Trello 2a.
% Model nr: 1 - Gaussian GARCH
%           2 - Student T GARCH
%           3 - Gaussian EWMA
%           4 - Student T EWMA
%   r is logaritmich Kalman-filtered returns
[n_returns, n_assets]=size(r);
n_returnsOut = size(rOut,1);
dt = 1/252;
ll = zeros(n_returnsOut, n_assets);
outOfSampleLogLikelihood = zeros(1,n_assets);
% xi=zeros(n_returns, n_assets); % For QQ-plot

if model == 1   % Gussian GARCH
    % nu     = xOpt(1);
    % beta0  = xOpt(2);
    % beta1  = xOpt(3);
    % beta2  = xOpt(4);
    % df     = xOpt(5) = 0;
    xOpt = zeros(5,n_assets);
    for i=1:n_assets
        [xOpt(:,i)] = mlGARCH(r(:,i),dt,@likelihoodNormal);
        ll(:,i) = likelihoodNormal(xOpt(:,i), rOut(:,i), dt, @varGARCH);
        outOfSampleLogLikelihood(i) = sum(ll(:,i));
    end
    
% % For QQ-plot
%     for i=1:n_assets
%         v = varGARCH(xOpt(:,i),r(:,i),dt);
%         xi(:,i) = (r(:,i)-xOpt(1,i)*dt)./(sqrt(v(1:end-1))*sqrt(dt));
%         figure(i);
%         qqplot(xi(:,i)); 
%         title(['QQ plot GARCH(1,1) Gaussian normalized logarithmic returns, asset: ', num2str(i)]);
%     end
    
elseif model == 2 % Student T GARCH
    % nu     = xOpt(1);
    % beta0  = xOpt(2);
    % beta1  = xOpt(3);
    % beta2  = xOpt(4);
    % df     = xOpt(5);
    xOpt = zeros(5,n_assets);
    for i=1:n_assets
        [xOpt(:,i)] = mlGARCH(r(:,i),dt,@likelihoodStudentst);
        ll(:,i) = likelihoodStudentst(xOpt(:,i), rOut(:,i), dt, @varGARCH);
        outOfSampleLogLikelihood(i) = sum(ll(:,i));
    end

% % For QQ-plot
%     for i=1:n_assets
%         v = varGARCH(xOpt(:,i),r(:,i),dt);
%         xi(:,i) = (r(:,i)-xOpt(1,i)*dt)./(sqrt(v(1:end-1))*sqrt(dt));
%         figure(i);
%         df = xOpt(5,i);
%         pd = makedist('tLocationScale', 'mu', 0, 'sigma', 1, 'nu', df);
%         qqplot(xi(:,i), pd); 
%         title(['QQ plot GARCH(1,1) Student T logarithmic returns, asset: ', num2str(i)]);
%     end
    
elseif model == 3 % Gaussian EWMA
    % nu     = xOpt(1);
    % lambda = xOpt(2);
    % df     = xOpt(3) = 0;

    xOpt = zeros(3,n_assets);
    for i=1:n_assets
        [xOpt(:,i)] = mlEWMA(r(:,i),dt,@likelihoodNormal);
        ll(:,i) = likelihoodNormal(xOpt(:,i), rOut(:,i), dt, @varEWMA);
        outOfSampleLogLikelihood(i) = sum(ll(:,i));
    end
    
% % For QQ-plot
%     for i=1:n_assets
%         v = varEWMA(xOpt(:,i),r(:,i),dt);
%         xi(:,i) = (r(:,i)-xOpt(1,i)*dt)./(sqrt(v(1:end-1))*sqrt(dt));
%         figure(i);
%         qqplot(xi(:,i)); 
%         title(['QQ plot EWMA Gaussian normalized logarithmic returns, asset: ', num2str(i)]);
%     end

elseif model == 4 % Student T EWMA
    % nu     = xOpt(1);
    % lambda = xOpt(2);
    % df     = xOpt(3);

    xOpt = zeros(3,n_assets);
    for i=1:n_assets
        [xOpt(:,i)] = mlEWMA(r(:,i),dt,@likelihoodStudentst);
        ll(:,i) = likelihoodStudentst(xOpt(:,i), rOut(:,i), dt, @varEWMA);
        outOfSampleLogLikelihood(i) = sum(ll(:,i));
    end
    
% % For QQ-plot
%     for i=1:n_assets
%         v = varEWMA(xOpt(:,i),rK(:,i),dt);
%         xi(:,i) = (rK(:,i)-xOpt(1,i)*dt)./(sqrt(v(1:end-1))*sqrt(dt));
%         figure(i);
%         df = xOpt(3,i);
%         pd = makedist('tLocationScale', 'mu', 0, 'sigma', 1, 'nu', df);
%         qqplot(xi(:,i), pd); 
%         title(['QQ plot EWMA Student T logarithmic returns, asset: ', num2str(i)]);
%     end

else
    error('Please chose a model for likelihood');
    
end
end

