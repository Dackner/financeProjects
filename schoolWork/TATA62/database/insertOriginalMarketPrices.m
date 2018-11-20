function insertOriginalMarketPrices( ric, timeStamp, qBid, qAsk, database )

%INSERTMARKETPRICES Inserts quoted market prices in database.

mid = (qBid+qAsk)/2;
price = mid;
error = price - mid;

quotes = table(ric, timeStamp, qBid, qAsk, price, error, 'VariableNames', ...
    {'ric', 'timeStamp', 'quotedBid', 'quotedAsk', 'price', 'error'});

datainsert(database, 'market_price', quotes.Properties.VariableNames, quotes);


end

