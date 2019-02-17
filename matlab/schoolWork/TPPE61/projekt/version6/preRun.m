function [Corr, XOPT, Variance, Df] = preRun(data, simLength, estPeriod)

estLength = estPeriod*252; %days
Corr = cell(simLength, 1);
XOPT = Corr;
Variance = zeros(simLength, size(data,2));
Df = zeros(simLength, 1);
v = zeros(estLength,size(data,2));

for date = 1:simLength

    estData = data(end-simLength-estLength + date:end-simLength -1 + date, :);
    
    %Kalman
    [rK, PK] = kalmanFilter(estData);
    
    %Inference for Margins
    [xOpt, ~, ~] = mlEWMAandGARCH(rK, rK, 2); %GARCH StudT = 2
    
    dt = 1/252;
    xi = zeros(size(rK));
    for i=1:size(rK,2)
        v(:,i) = varGARCH(xOpt(:,i),rK(:,i),dt);
        xi(:,i) = (rK(:,i)-xOpt(1,i)*dt)./(sqrt(v(1:end-1,i))*sqrt(dt));
    end
    
    DFm = repmat(xOpt(end, 1:end), size(xi,1) ,1);
    U     = tcdf(xi, DFm);
    [rhoStudT, df]  = copulafit('t', U, 'Method', 'ApproximateML');
    
    %Save data
    Variance(date, :)  = (1/dt)*v(end, :); 
    Df(date)           = df;
    XOPT{date}         = xOpt;
    Corr{date}         = rhoStudT;
    disp([num2str(date) '/' num2str(simLength)]);

end

end