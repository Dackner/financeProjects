disp('Dropping tables...');
exec(conn, 'DROP TABLE market_price, smoothed_OIS, smoothed_FRA_IRS, smoothed_TENOR_PREMIUM, smoothed_IBOR, original_OIS, original_FRA_IRS, original_TENOR_PREMIUM, original_IBOR'); % execute in R2018
disp('Tables dropped.');

disp('Creating tables...');
createQuery = ['CREATE TABLE market_price ('...
               'ric             VARCHAR(20),' ...
               'timeStamp       INTEGER,' ...
               'quotedBid       DOUBLE,' ...
               'quotedAsk       DOUBLE,' ...
               'price           DOUBLE,' ...
               'error           DOUBLE,' ...
               'PRIMARY KEY (ric, timeStamp));'];
exec(conn, createQuery);

createQuery = ['CREATE TABLE smoothed_OIS ('...
               'timeStamp       INTEGER,' ...
               'maturity        DOUBLE,' ...
               'yield           DOUBLE,' ...
               'currency        VARCHAR(3),' ...
               'PRIMARY KEY (timeStamp, maturity, currency));'];
exec(conn, createQuery);

createQuery = ['CREATE TABLE smoothed_FRA_IRS ('...
               'timeStamp       INTEGER,' ...
               'maturity        DOUBLE,' ...
               'yield           DOUBLE,' ...
               'currency        VARCHAR(3),' ...
               'PRIMARY KEY (timeStamp, maturity, currency));'];
exec(conn, createQuery);

createQuery = ['CREATE TABLE smoothed_TENOR_PREMIUM ('...
               'timeStamp       INTEGER,' ...
               'maturity        DOUBLE,' ...
               'yield           DOUBLE,' ...
               'currency        VARCHAR(3),' ...
               'PRIMARY KEY (timeStamp, maturity, currency));'];
exec(conn, createQuery);

createQuery = ['CREATE TABLE smoothed_IBOR ('...
               'timeStamp       INTEGER,' ...
               'maturity        DOUBLE,' ...
               'yield           DOUBLE,' ...
               'currency        VARCHAR(3),' ...
               'PRIMARY KEY (timeStamp, maturity, currency));'];
exec(conn, createQuery);

createQuery = ['CREATE TABLE original_OIS ('...
               'timeStamp       INTEGER,' ...
               'maturity        DOUBLE,' ...
               'yield           DOUBLE,' ...
               'currency        VARCHAR(3),' ...
               'PRIMARY KEY (timeStamp, maturity, currency));'];
exec(conn, createQuery);

createQuery = ['CREATE TABLE original_FRA_IRS ('...
               'timeStamp       INTEGER,' ...
               'maturity        DOUBLE,' ...
               'yield           DOUBLE,' ...
               'currency        VARCHAR(3),' ...
               'PRIMARY KEY (timeStamp, maturity, currency));'];
exec(conn, createQuery);

createQuery = ['CREATE TABLE original_TENOR_PREMIUM ('...
               'timeStamp       INTEGER,' ...
               'maturity        DOUBLE,' ...
               'yield           DOUBLE,' ...
               'currency        VARCHAR(3),' ...
               'PRIMARY KEY (timeStamp, maturity, currency));'];
exec(conn, createQuery);

createQuery = ['CREATE TABLE original_IBOR ('...
               'timeStamp       INTEGER,' ...
               'maturity        DOUBLE,' ...
               'yield           DOUBLE,' ...
               'currency        VARCHAR(3),' ...
               'PRIMARY KEY (timeStamp, maturity, currency));'];
exec(conn, createQuery);

disp('Tables created. Database successfully set up and ready for use.');
%tables = tables(conn, 'CDIOdata')