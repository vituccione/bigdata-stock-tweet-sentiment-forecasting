SHOW DATABASES;

CREATE DATABASE s2ca2;
USE s2ca2;

CREATE TABLE stock_prices (
    ticker VARCHAR(10) NOT NULL,
    date DATE NOT NULL,
    open DOUBLE,
    high DOUBLE,
    low DOUBLE,
    close DOUBLE,
    adj_close DOUBLE,
    volume BIGINT,
    PRIMARY KEY (ticker, date)
);

CREATE TABLE stock_tweets (
    ticker VARCHAR(10) NOT NULL,
    id BIGINT NOT NULL,
    date DATE,
    tweet TEXT,
    PRIMARY KEY (ticker, id)
);

TRUNCATE TABLE stock_prices;
TRUNCATE TABLE stock_tweets;
