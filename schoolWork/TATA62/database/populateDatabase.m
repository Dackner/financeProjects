%Before running this script, the .mat files for every currency need to be created.

addpath('../data');

currencies = ['CHF'; 'EUR'; 'GBP'; 'JPY'; 'KRW'; 'SEK'; 'USD'];

for k = 1:length(currencies)
    
    disp(['Inserting ' currencies(k, 1:end) ' data...']);
    
    load([currencies(k, 1:end) '.mat']);
    
    timeStamps  = cell2mat(dates(1));
    timeStampsIBOR = cell2mat(dates(3));
    qBids = cell2mat(data(1));
    qAsks = cell2mat(data(2));
    qIBORs = cell2mat(data(3));
    rics = ric{1}';
    ricsIBOR = ric{3}';%ricsIBOR{1}
    
    %clean NaN TODO: = what??
    ind = isnan(qBids);
    qBids(ind) = 0;
    ind = isnan(qAsks);
    qAsks(ind) = 0;
    ind = isnan(qIBORs);
    qIBORs(ind) = 0;
    
    m = length(timeStamps);
    n = length(rics);
    mIBOR = length(timeStampsIBOR);
    nIBOR = length(ricsIBOR);
    
    disp(['Inserting ' currencies(k, 1:end) ' OIS, FRA and IRS instruments...']);
    for i = 1:n
        insertOriginalMarketPrices( repmat(rics{i}, m, 1), timeStamps, qBids(:,i), qAsks(:,i), conn );
        disp(strcat(rics{i}, '(', num2str(i), '/', num2str(n), ')'));
    end
    
    disp(['Inserting' currencies(k, 1:end) ' IBOR data...']);
    for i = 1:nIBOR
        insertOriginalMarketPrices( repmat(ricsIBOR{i}, m, 1), timeStampsIBOR, qIBORs(:,i), qIBORs(:,i), conn );
        disp(strcat(ricsIBOR{i}, '(', num2str(i), '/', num2str(nIBOR), ')'));
    end
    
    disp([currencies(k, 1:end) ' data successfully inserted.']);
    
end

disp('All data successfully inserted');
rmpath('../data');

%% old code
% addpath('../data')
%EURO data
disp('Inserting Euro data...');
load EUR;

timeStamps  = cell2mat(dates(1));
timeStampsIBOR = cell2mat(dates(3));
qBids = cell2mat(data(1));
qAsks = cell2mat(data(2));
qIBORs = cell2mat(data(3));
rics = ric{1}';
ricsIBOR = ric{3}';%ricsIBOR{1}

%clean NaN TODO: = what??
ind = isnan(qBids);
qBids(ind) = 0;
ind = isnan(qAsks);
qAsks(ind) = 0;
ind = isnan(qIBORs);
qIBORs(ind) = 0;

m = length(timeStamps);
n = length(rics);
mIBOR = length(timeStampsIBOR);
nIBOR = length(ricsIBOR);

disp('Inserting OIS, FRA and IRS...');
for i = 1:n
    insertOriginalMarketPrices( repmat(rics{i}, m, 1), timeStamps, qBids(:,i), qAsks(:,i), conn );
    disp(strcat(rics{i}, '(', num2str(i), '/', num2str(n), ')'));
end
disp('OIS, FRA and IRS inserted.');

disp('Inserting EURIBOR...');
for i = 1:nIBOR
    insertOriginalMarketPrices( repmat(ricsIBOR{i}, m, 1), timeStampsIBOR, qIBORs(:,i), qIBORs(:,i), conn );
    disp(strcat(ricsIBOR{i}, '(', num2str(i), '/', num2str(nIBOR), ')'));
end
disp('EURIBOR inserted.');

disp('Euro data successfully inserted.');

%TODO all other currencies.

disp('All data successfully inserted.');
