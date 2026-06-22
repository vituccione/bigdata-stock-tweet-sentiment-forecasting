describe cluster;
DESCRIBE KEYSPACES;

CREATE KEYSPACE s2ca2 WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };
USE s2ca2;

CREATE TABLE stock_prices (
    ticker TEXT,
    date DATE,
    open DOUBLE,
    high DOUBLE,
    low DOUBLE,
    close DOUBLE,
    adj_close DOUBLE,
    volume BIGINT,
    PRIMARY KEY ((ticker), date)
);

CREATE TABLE stock_tweets (
    ticker TEXT,
    id BIGINT,
    date DATE,
    tweet TEXT,
    PRIMARY KEY ((ticker), id)
);

CREATE TABLE stock_sentiment (
    ticker text,
    date timestamp,
    open double,
    high double,
    low double,
    close double,
    adj_close double,
    volume bigint,
    avg_sentiment_score double,
    tweet_count bigint,
    PRIMARY KEY (ticker, date)
);

truncate stock_prices;
truncate stock_tweets;
truncate stock_sentiment;