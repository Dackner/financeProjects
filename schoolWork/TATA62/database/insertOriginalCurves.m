function insertOriginalCurves(timeStamps, tenors, curves, curveType, currency)

%INSERTORIGINALCURVES Inserts yieldcurves into SQL tables
%original_[curveType]. Currency can be of values
%['CHF', 'EUR', 'GBP', 'JPY', 'KRW', 'SEK', 'USD'] and curveType
%['OIS', 'FRA_IRS', 'TENOR_PREMIUM', 'IBOR']

tableName = ['original_' curveType];

%TODO, loop over rows of curves and insert

end

