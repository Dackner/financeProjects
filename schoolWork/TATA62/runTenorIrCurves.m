% measurementPath = 'Z:\prog\XiFinPortfolio\matlab\measurement';
% % measurementPath = '/home/jorbl45/axel/jorbl45/prog/XiFinPortfolio/matlab/measurement';

addpath('measurement');
addpath('data');

c = 4; runOIS = 0;
if (c==1) % CHF
  currency = 'CHF'; cal = 'SWI'; curencyTimeZone = 'Europe/Paris';
  iborName = 'LIBORCHF3M'; iborCal = 'SWI,UKG'; iborCalFixing = 'UKG'; tenorIRS = '6M'; iborTimeZone = 'Europe/London'; settlementLagIRS = 2; irsBDC = 'M'; iborDCC = 'MMA0';
  onName = 'SARON.S'; onCal = 'SWI'; onCalFixing = 'SWI'; tenorON = 'ON'; onTimeZone = 'Europe/Paris'; settlementLagON = 0; onBDC = 'M'; onDCC = 'MMA0';
  irsStructure = 'PAID:FIXED LBOTH SETTLE:2WD DMC:M EMC:S CFADJ:YES REFDATE:MATURITY CLDR:SWI,UKG PDELAY:0 LFIXED FRQ:1 CCM:BB00 LFLOAT FRQ:2 CCM:MMA0'; % CHF_AB6L
  oisStructure = 'PAID:FIXED LBOTH SETTLE:2WD FRQ:1 CCM:MMA0 DMC:FOL EMC:SAME CFADJ:NO REFDATE:MATURITY CLDR:SWI PDELAY:0 LFLOAT IDX:OCHFTOIS'; % OIS_CHFTOIS
  timeToMaturityFRA = '6X12'; fraDCC = 'MMA0';
elseif (c==2) % EUR
  currency = 'EUR'; cal = 'EMU'; curencyTimeZone = 'Europe/Paris';
  iborName = 'EURIBOR6M'; iborCal = 'EMU'; iborCalFixing = 'EUR'; tenorIRS = '6M'; iborTimeZone = 'Europe/Paris'; settlementLagIRS = 2; irsBDC = 'M'; iborDCC = 'MMA0';
  onName = 'EONIA='; onCal = 'EMU'; onCalFixing = 'EMU'; tenorON = 'ON'; onTimeZone = 'Europe/Paris'; settlementLagON = 0; onBDC = 'M'; onDCC = 'MMA0';
  irsStructure = 'PAID:FIXED LBOTH SETTLE:2WD DMC:M EMC:S CFADJ:YES REFDATE:MATURITY CLDR:EMU PDELAY:0 LFIXED FRQ:1 CCM:BB00 LFLOAT FRQ:2 CCM:MMA0'; % EUR_AB6E
  oisStructure = 'PAID:FIXED LBOTH SETTLE:0WD FRQ:1 CCM:MMA0 DMC:FOL EMC:SAME CFADJ:NO REFDATE:MATURITY CLDR:EMU PDELAY:1 LFLOAT IDX:OEONIA'; % OIS_EONIA
  timeToMaturityFRA = '6X12'; fraDCC = 'MMA0';
elseif (c==3) % GBP, Check yearly time frac
  currency = 'GBP'; cal = 'UKG'; curencyTimeZone = 'Europe/London';
  iborName = 'LIBORGBP6M'; iborCal = 'UKG'; iborCalFixing = 'UKG'; tenorIRS = '6M'; iborTimeZone = 'Europe/London'; settlementLagIRS = 0; irsBDC = 'M'; iborDCC = 'MMA5';
  onName = 'SONIAOSR='; onCal = 'UKG'; onCalFixing = 'UKG'; tenorON = 'ON'; onTimeZone = 'Europe/London'; settlementLagON = 0; onBDC = 'M'; onDCC = 'MMA5';
  irsStructure = 'PAID:FIXED LBOTH SETTLE:0WD FRQ:2 DMC:M EMC:S CFADJ:YES REFDATE:MATURITY CLDR:UKG PDELAY:0 LFIXED CCM:BBA5 LFLOAT CCM:MMA5'; % GBP_SB6L (fix)
  oisStructure = 'PAID:FIXED LBOTH SETTLE:0WD FRQ:1 CCM:MMA5 DMC:FOL EMC:SAME CFADJ:NO REFDATE:MATURITY CLDR:EMU PDELAY:0 LFLOAT IDX:OSONIA'; % OIS_SONIA
  timeToMaturityFRA = '6X12'; fraDCC = 'MMA5';
elseif (c==4) % JPY
  currency = 'JPY'; cal = 'JAP'; curencyTimeZone = 'Asia/Tokyo';
  iborName = 'LIBORJPY6M'; iborCal = 'JAP,UKG'; iborCalFixing = 'UKG'; tenorIRS = '6M'; iborTimeZone = 'Europe/London'; settlementLagIRS = 2; irsBDC = 'M'; iborDCC = 'MMA0';
  onName = 'JPONMU=RR'; onCal = 'JAP'; onCalFixing = 'JAP'; tenorON = 'ON'; onTimeZone = 'Asia/Tokyo'; settlementLagON = 0; onBDC = 'M'; onDCC = 'MMA5';
  irsStructure = 'PAID:FIXED LBOTH SETTLE:2WD FRQ:2 DMC:M EMC:S CFADJ:YES REFDATE:MATURITY CLDR:JAP,UKG PDELAY:0 LFIXED CCM:BBA5 LFLOAT CCM:MMA5'; % JPY_SB6L (fix)
  oisStructure = 'PAID:FIXED LBOTH SETTLE:2WD FRQ:1 CCM:MMA5 DMC:FOL EMC:SAME CFADJ:NO REFDATE:MATURITY CLDR:JAP PDELAY:2 LFLOAT IDX:OJPYONMU'; % OIS_JPYONMU
  timeToMaturityFRA = '6X12'; fraDCC = 'MMA0';
elseif (c==5) % KRW
  currency = 'KRW'; cal = 'KOR'; curencyTimeZone = 'Asia/Seoul';
  iborName = 'KRWCD3M'; iborCal = 'KOR'; iborCalFixing = 'KOR'; tenorIRS = '3M'; iborTimeZone = 'Asia/Seoul'; settlementLagIRS = 2; irsBDC = 'M'; iborDCC = 'MMA5';
  clear onName; % Do hot have OIS
  irsStructure = 'PAID:FIXED LBOTH SETTLE:1WD CCM:MMA5 DMC:MOD EMC:S CFADJ:YES REFDATE:MATURITY PDELAY:0 CLDR:KOR LFIXED FRQ:4 LFLOAT FRQ:4'; % KRW_QMCD
  clear oisStructure; % Do hot have OIS
  timeToMaturityFRA = '3X6'; fraDCC = 'MMA5';
elseif (c==6) % SEK
  currency = 'SEK'; cal = 'SWE'; curencyTimeZone = 'Europe/Stockholm';
  iborName = 'STIBOR3M'; iborCal = 'SWE'; iborCalFixing = 'SWE'; tenorIRS = '3M'; iborTimeZone = 'Europe/Stockholm'; settlementLagIRS = 2; irsBDC = 'M'; iborDCC = 'MMA0';
  onName = 'STISEKTNDFI='; onCal = 'SWE'; onCalFixing = 'SWE'; tenorON = 'TN'; onTimeZone = 'Europe/Stockholm'; settlementLagON = 0; onBDC = 'M'; onDCC = 'MMA0';
  irsStructure = 'PAID:FIXED LBOTH SETTLE:2WD DMC:M EMC:S CFADJ:YES REFDATE:MATURITY CLDR:SWE PDELAY:0 LFIXED FRQ:1 CCM:BB00 LFLOAT FRQ:4 CCM:MMA0'; % SEK_AB3S
  oisStructure = 'PAID:FIXED LBOTH SETTLE:2WD FRQ:1 CCM:MMA0 DMC:FOL EMC:SAME CFADJ:NO REFDATE:MATURITY CLDR:SWE PDELAY:0 LFLOAT IDX:OSEKSTI'; % OIS_SEKSTI
  timeToMaturityFRA = '3F1'; fraDCC = 'MMA0';
elseif (c==7) % USD
  currency = 'USD'; cal = 'USA'; curencyTimeZone = 'America/New_York';
curencyTimeZone = 'Europe/Paris';  % Bugg g�r att tidszonerna inte fungerar korrekt
  iborName = 'LIBORUSD3M'; iborCal = 'USA,UKG'; iborCalFixing = 'UKG'; tenorIRS = '3M'; iborTimeZone = 'Europe/London'; settlementLagIRS = 2; irsBDC = 'M'; iborDCC = 'MMA0';
  onName = 'USONFFE='; onCal = 'USA'; onCalFixing = 'USA'; tenorON = 'ON'; onTimeZone = 'America/New_York'; settlementLagON = 0; onBDC = 'M'; onDCC = 'MMA0';
  irsStructure = 'PAID:FIXED LBOTH SETTLE:2WD CCM:MMA0 DMC:M EMC:S CFADJ:YES REFDATE:MATURITY CLDR:USA PDELAY:0 LFIXED FRQ:1 LFLOAT FRQ:4'; % USD_AM3L
  oisStructure = 'PAID:FIXED LBOTH SETTLE:2WD FRQ:1 CCM:MMA0 DMC:FOL EMC:SAME CFADJ:NO REFDATE:MATURITY CLDR:USA PDELAY:2 LFLOAT IDX:OFFER'; % 
  timeToMaturityFRA = '3X6'; fraDCC = 'MMA0';
end

populatePortfolioWithData;

% Create portfolio lexicon (pl) for constants in portfolio
pl.atIBOR = mexPortfolio('assetTypeCode', 'IBOR');
pl.atFRAG = mexPortfolio('assetTypeCode', 'FRAG');
pl.atFRA  = mexPortfolio('assetTypeCode', 'FRA');
pl.atIRSG = mexPortfolio('assetTypeCode', 'IRSG');
pl.atIRS  = mexPortfolio('assetTypeCode', 'IRS');
pl.atOISG = mexPortfolio('assetTypeCode', 'OISG');
pl.atOIS  = mexPortfolio('assetTypeCode', 'OIS');

indOIS = find(strcmp(tenorON, assetTenor));
indFRA = find(strcmp(tenorIRS, assetTenor) &  pl.atFRAG == assetType{1});
indIRS = find(strcmp(tenorIRS, assetTenor) &  pl.atIRSG == assetType{1});
indIBOR = find(strcmp(tenorIRS, iborTenor));

% modelS={'BlomvallStd'}; % Exact repricing
% modelN =  [0];
% modelP =  [0];
% modelPn = [0];

modelS={'BlomvallLSexp1E2_2_2'};
modelN=[52]; 
modelP = [1E2 ; 2 ; 2];
modelPn = [3];

accountName = 'Cash';
cashDCC = 'MMA0';
cashFrq = '1D';
cashEom = 'S';
cashBDC = 'F';
irStartDate = datenum(2010,1,1);
cashID = mexPortfolio('createCash', currency, accountName, cashDCC, cashFrq, cashEom, cashBDC, cal, irStartDate);

if (runOIS)
% OIS curve

% for k=length(times):length(times)
for k=1:length(times)
  tradeDate = floor(times(k));
%   datestr(tradeDate)
  oisID = zeros(size(indOIS));
  oisPrices = ones(3,length(indOIS))*Inf;
  for j=1:length(indOIS)
    % Retrieve data
    [timeData, data] = mexPortfolio('getValues', assetID{1}(indOIS(j)), times(k), curencyTimeZone, {'BID', 'ASK'});
    if (floor(timeData) ~= floor(times(k)))
      data = [NaN ; NaN];
    end
    oisPrices(1:2,j) = data;
    if (sum(isnan(data))==0)
      mid = mean(data);
    else
      mid = 0;
    end
    % Create OIS
    [oisID(j)] = mexPortfolio('initFromGenericInterest', assetID{1}(indOIS(j)), 100, mid, tradeDate, cashID, 1);
  end
  
  conTransf = []; % If this is not set, then the standard setting will be applied in computeForwardRates
  conType = ones(size(oisID))*6; % Unique mid price
  useEF = zeros(size(oisID)); % No deviation from market prices
  [instrOIS,removeAsset,flg] = createInstrumentsClasses(pl, tradeDate, ric{1}(indOIS), oisID, oisPrices, conType);
  if (~isempty(conTransf))
    conTransf(removeAsset) = [];
  end
  if (~isempty(useEF))
    useEF(removeAsset) = [];
  end

  if (length(instrOIS.data)<=1) % Not working for GBP with only 1 instrument
    continue;
  end
  nF = instrOIS.lastDate-instrOIS.firstDate;
  T = (0:nF)'*1/365;

  clear model;
  model.id = modelN(1);
  model.conTransf = conTransf;
  model.E = useEF;
  model.F = useEF;
  model.param = modelP(1:modelPn(1),1);

  [fOIS,rOIS,modelSol] = computeForwardRates(instrOIS, nF,T,model);
  plot(T(1:end-1), fOIS);
  title(datestr(times(k)));
  legend(strcat('OIS curve: ', currency));
  pause(0.0001);
end
end

% FRA/IRS single curve

for k=1:length(times)
  tradeDate = floor(times(k));
%   datestr(tradeDate)

  % IBOR
  % Retrieve data
  [timeData, data] = mexPortfolio('getValues', assetID{3}(indIBOR), times(k), iborTimeZone, 'LAST');
  if (floor(timeData) ~= floor(times(k)))
    iborPrices = [NaN ; NaN ; Inf];
  else
    iborPrices = [data ; data ; Inf];
  end
  % Create IBOR
  [iborID] = mexPortfolio('initFromGenericInterest', assetID{3}(indIBOR), 100, data, tradeDate, cashID, 1);
  
  % FRA
  fraID = zeros(size(indFRA));
  fraPrices = ones(3,length(indFRA))*Inf;
  for j=1:length(indFRA)
    % Retrieve data
    [timeData, data] = mexPortfolio('getValues', assetID{1}(indFRA(j)), times(k), curencyTimeZone, {'BID', 'ASK'});
    if (floor(timeData) ~= floor(times(k)))
      data = [NaN ; NaN];
    end
    fraPrices(1:2,j) = data;
    if (sum(isnan(data))==0)
      mid = mean(data);
    else
      mid = 0;
    end
    % Create FRA
    [fraID(j)] = mexPortfolio('initFromGenericInterest', assetID{1}(indFRA(j)), 100, mid, tradeDate, cashID, 1);
  end
  % IRS
  irsID = zeros(size(indIRS));
  irsPrices = ones(3,length(indIRS))*Inf;
  for j=1:length(indIRS)
    % Retrieve data
    [timeData, data] = mexPortfolio('getValues', assetID{1}(indIRS(j)), times(k), curencyTimeZone, {'BID', 'ASK'});
    if (floor(timeData) ~= floor(times(k)))
      data = [NaN ; NaN];
    end
    irsPrices(1:2,j) = data;
    if (sum(isnan(data))==0)
      mid = mean(data);
    else
      mid = 0;
    end
    % Create IRS
    [irsID(j)] = mexPortfolio('initFromGenericInterest', assetID{1}(indIRS(j)), 100, mid, tradeDate, cashID, 1);
  end
  indFRAIRS = [indFRA ; indIRS];
  frairsID = [fraID ; irsID];
  frairsPrices = [fraPrices irsPrices];
  
  conTransf = []; % If this is not set, then the standard setting will be applied in computeForwardRates
  conType = ones(size(frairsID))*6; % Unique mid price
  useEF = zeros(size(frairsID)); % No deviation from market prices
  [instrFRAOIS,removeAsset,flg] = createInstrumentsClasses(pl, tradeDate, ric{1}(indFRAIRS), frairsID, frairsPrices, conType);
  if (~isempty(conTransf))
    conTransf(removeAsset) = [];
  end
  if (~isempty(useEF))
    useEF(removeAsset) = [];
  end

  if (length(instrFRAOIS.data)==0)
    continue;
  end
  nF = instrFRAOIS.lastDate-instrFRAOIS.firstDate;
  T = (0:nF)'*1/365;

  clear model;
  model.id = modelN(1);
  model.conTransf = conTransf;
  model.E = useEF;
  model.F = useEF;
  model.param = modelP(1:modelPn(1),1);

  [fFRAIRS,rFRAIRS,modelSol] = computeForwardRates(instrFRAOIS, nF,T,model);
  plot(T(1:end-1), fFRAIRS);
  title(datestr(times(k)));
  legend(strcat('FRA/IRS curve: ', currency));
  pause(0.0001);
end


rmpath(measurementPath)





return;

mexPortfolio('clear')
mexPortfolio('init', currency);

% Example to check if dates are holidays

calDefDates = datenum(2000,1,1):datenum(2000,12,31); % Date when calendar is defined
calDates = datenum(2000,1,1):datenum(2000,12,31); % Date to check if holiday
isHoliday = mexPortfolio('isHoliday', cal, calDefDates, calDates); % Note that projected holidays may change over time (holidays are added and removed, hence the date when the calendar is defined is important)

% Create an IBOR rate that is used together with IRS
iborID = mexPortfolio('createIBOR', currency, iborName, tenorIRS, iborTimeZone, settlementLagIRS, irsBDC, iborDCC, iborCal, iborCalFixing);

accountName = 'Cash';
cashDCC = 'MMA0';
cashFrq = '1D';
cashEom = 'S';
cashBDC = 'F';
irStartDate = datenum(2000,1,1);
cashID = mexPortfolio('createCash', currency, accountName, cashDCC, cashFrq, cashEom, cashBDC, cal, irStartDate);

% Exempel f�r IRS

notionalAmount = 1; 
fixedRate = 0.03; 
tradeDate = datenum(2010,1,4); 
timeToMaturity = '10Y';
irsID = mexPortfolio('createIRS', currency, notionalAmount, fixedRate, tradeDate, timeToMaturity, irsStructure, iborID, cashID);

[tradeDate, settlementDate, maturityDate, floatCouponFixingTimes, floatCouponStartDates, floatQuasiDates, floatCouponDates, floatTimeFrac, fixedQuasiDates, fixedCouponDates, fixedTimeFrac] = mexPortfolio('cashFlowsIRS', irsID);

fprintf('IRS Trade date = %s Maturity date = %s\n', datestr(tradeDate), datestr(maturityDate));
for i=1:length(floatCouponFixingTimes)
  fprintf('%2d: %s %s %s %s %f\n', i, datestr(floatCouponFixingTimes(i)), datestr(floatCouponStartDates(i)), datestr(floatQuasiDates(i)), datestr(floatCouponDates(i)), floatTimeFrac(i));  
end
for i=1:length(fixedQuasiDates)
  fprintf('%2d: %s %s %f\n', i, datestr(fixedQuasiDates(i)), datestr(fixedCouponDates(i)), fixedTimeFrac(i));  
end

% Exempel f�r OIS

% Create an ON rate that is used together with OIS
onID = mexPortfolio('createIBOR', currency, onName, tenorON, onTimeZone, settlementLagON, onBDC, onDCC, onCal, onCalFixing);

notionalAmount = 1; 
fixedRate = 0.03; 
tradeDate = datenum(2010,1,4); 
timeToMaturity = '10Y';
irsID = mexPortfolio('createIRS', currency, notionalAmount, fixedRate, tradeDate, timeToMaturity, oisStructure, iborID, cashID);

[tradeDate, settlementDate, maturityDate, floatCouponFixingTimes, floatCouponStartDates, floatQuasiDates, floatCouponDates, floatTimeFrac, fixedQuasiDates, fixedCouponDates, fixedTimeFrac] = mexPortfolio('cashFlowsIRS', irsID);

fprintf('OIS Trade date = %s Maturity date = %s\n', datestr(tradeDate), datestr(maturityDate));
for i=1:length(floatCouponFixingTimes)
  fprintf('%2d: %s %s %s %s %f\n', i, datestr(floatCouponFixingTimes(i)), datestr(floatCouponStartDates(i)), datestr(floatQuasiDates(i)), datestr(floatCouponDates(i)), floatTimeFrac(i));  
end
for i=1:length(fixedQuasiDates)
  fprintf('%2d: %s %s %f\n', i, datestr(fixedQuasiDates(i)), datestr(fixedCouponDates(i)), fixedTimeFrac(i));  
end

% Exempel FRA
fraID = mexPortfolio('createFRA', currency, notionalAmount, fixedRate, tradeDate, settlementLagIRS, timeToMaturityFRA, fraDCC, cal, iborID, cashID);

[startDate, endDate, timeFrac] = mexPortfolio('cashFlowsFRA', fraID);

fprintf('Coupon start date = %s Coupon end date = %s Time fraction = %f\n', datestr(startDate), datestr(endDate), timeFrac);

% Exempel IBOR (f�r deposits etc.)

[startDate, endDate, timeFrac] = mexPortfolio('cashFlowsIBOR', iborID, tradeDate);

fprintf('Coupon start date = %s Coupon end date = %s Time fraction = %f\n', datestr(startDate), datestr(endDate), timeFrac);

