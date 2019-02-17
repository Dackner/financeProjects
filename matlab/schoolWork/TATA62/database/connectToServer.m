% We need to add the path to the JDBC driver to the java path
clc
clearvars
javaaddpath('/usr/share/java/mysql-connector-java-5.1.42.jar');

% A database named 'CDIOdata' has been created.
% An account named 'CDIO' with password 'cd!=2018' has been assigned
% privelegies to modify that database through a connection from any of the
% prodek Linux machines.

% Connect to the database (physically located on logic)
databaseString = 'CDIOdata?useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=CET';
conn = database(databaseString, 'CDIO', 'cd!=2018', 'Vendor', 'MySQL', 'Server', 'logic.ad.iei.liu.se');

clearvars databaseString