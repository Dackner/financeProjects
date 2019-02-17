
connectToServer; %create conn : connection to database
conn.message;

setupDatabase;

%%
clc
tables(conn, 'CDIOdata')

%%

%exec(conn, createQuery);

rics    = ['USD1MOIS=';'USD2MOIS='];
dates   = ['2018-10-24';'2018-10-25'];
qBid    = [0.234;0.241];
qAsk    = [0.235;0.242];
price   = (qBid + qAsk)/2;
error   = [0;0];

% quotes = table(rics, dates, qBid, qAsk, price, error, 'VariableNames', ...
%     {'ric', 'timeStamp', 'quotedBid', 'quotedAsk', 'price', 'error'});
% 
% % sqlwrite(conn, 'data', data); % in R2018b
% datainsert(conn, 'market_price', quotes.Properties.VariableNames, quotes);

insertOriginalMarketPrices(rics, dates, qBid, qAsk, conn);

selectQuery = 'SELECT * FROM market_price';

tic
allQuotes = fetch(conn, selectQuery);
toc
fetch(conn, 'SELECT timeStamp, quotedBid FROM market_price WHERE ric = "EUREON1Y="')

