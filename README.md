# Big Data Stock Tweet Sentiment & Financial Forecasting

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Python](https://img.shields.io/badge/python-3.x-blue.svg)](https://www.python.org/)
[![Made with Jupyter](https://img.shields.io/badge/Jupyter-notebooks-orange.svg)](notebooks/)
[![Spark](https://img.shields.io/badge/Apache-Spark-E25A1C.svg)](https://spark.apache.org/)
[![Kafka](https://img.shields.io/badge/Apache-Kafka-231F20.svg)](https://kafka.apache.org/)
[![Dashboard: Streamlit](https://img.shields.io/badge/dashboard-Streamlit-red.svg)](dashboard/)

> MSc Data Analytics integrated project (Semester 2) — an **end-to-end big-data pipeline** that
> fuses **stock-tweet sentiment** with **financial time-series forecasting**, spanning
> distributed processing (**Spark NLP**), **SQL vs NoSQL** benchmarking (**YCSB**), **real-time
> streaming** (**Kafka**), classical & deep forecasting (**ARIMA/VARMAX/LSTM**), and an
> interactive **Streamlit dashboard**.

---

## Overview

This project builds a complete big-data analytics stack around 10 major US stocks
(**AAPL, AMZN, BA, DIS, GOOG, META, MSFT, NFLX, NVDA, TSLA**), combining what people *say* on
Twitter with what the market *does*:

- **Distributed processing** — tweets and stock prices are ingested and preprocessed at scale
  with **PySpark** and **Spark NLP**.
- **Sentiment ensemble** — five transformer/lexicon models are combined via confidence-weighted
  voting.
- **Storage benchmarking** — **MySQL** vs **Cassandra** (and MongoDB) compared under **YCSB**
  workloads A/B/C.
- **Real-time analytics** — a **Kafka** producer/consumer streaming pipeline.
- **Forecasting** — classical (**ARIMA/ARIMAX, VARMAX**) and deep-learning (**LSTM**) models.
- **Presentation** — a **Streamlit** dashboard tying the analysis together.

## Pipeline

| Stage | Notebook / asset | Highlights |
|-------|------------------|------------|
| Distributed processing & storage | [`notebooks/01-spark-preprocessing-sentiment-storage-streaming.ipynb`](notebooks/01-spark-preprocessing-sentiment-storage-streaming.ipynb) | Spark ingestion, Spark NLP preprocessing, distributed VADER/FinBERT/RoBERTa sentiment, **YCSB** A/B/C benchmarking, **Kafka** producer/consumer |
| Analytics & forecasting | [`notebooks/02-sentiment-ensemble-eda-forecasting.ipynb`](notebooks/02-sentiment-ensemble-eda-forecasting.ipynb) | 5-model **sentiment ensemble**, EDA, time-series analysis, **ARIMA/ARIMAX · VARMAX · LSTM** forecasting |
| Database schemas & benchmarks | [`scripts/`](scripts/) | MySQL & Cassandra DDL, cluster commands, YCSB benchmark script |
| Dashboard | [`dashboard/app.py`](dashboard/app.py) | Streamlit + Plotly app over the processed data |

> View the notebooks on
> [nbviewer](https://nbviewer.org/github/vituccione/bigdata-stock-tweet-sentiment-forecasting/tree/main/notebooks/)
> if GitHub does not render them inline.

---

## Components in detail

### 1. Distributed preprocessing & sentiment (Spark)
Stock prices and tweets are ingested with PySpark; text is cleaned with a regex pre-clean step
and a **Spark NLP** pipeline. Sentiment is scored with **VADER**, **FinBERT**, and **RoBERTa**,
then aggregated and joined back to stock data.

### 2. Sentiment ensemble (Python)
Five models — **VADER, RoBERTa, FinBERT, BERTweet, XLM-RoBERTa** — are combined through
**confidence-weighted voting with normalized strength** for a more robust signal.

### 3. SQL vs NoSQL storage (YCSB)
**MySQL** and **Cassandra** schemas ([`scripts/`](scripts/)) are benchmarked with the Yahoo!
Cloud Serving Benchmark across three workloads:

| Workload | Mix |
|----------|-----|
| A | 50% read / 50% update |
| B | 95% read / 5% update |
| C | 100% read |

### 4. Real-time streaming (Kafka)
A Kafka producer/consumer pipeline (topic `reddit-posts`) demonstrates a real-time analytics use
case on top of the batch results.

### 5. Time-series forecasting
After stationarity tests, decomposition, differencing, ACF/PACF analysis, and Granger-causality
checks, prices are forecast with **ARIMA/ARIMAX**, **VARMAX** (multivariate, across tech stocks),
and an **LSTM** neural network.

---

## Repository structure

```
.
├── notebooks/
│   ├── 01-spark-preprocessing-sentiment-storage-streaming.ipynb
│   └── 02-sentiment-ensemble-eda-forecasting.ipynb
├── scripts/
│   ├── MySQL_DDL.sql            # relational schema
│   ├── Cassandra_DDL.sql        # wide-column schema
│   ├── commands.sh              # Spark / Kafka / DB cluster commands
│   └── ycsb_benchmarkABC.sh     # YCSB workload runner
├── dashboard/
│   └── app.py                   # Streamlit dashboard
├── report/                      # written report (PDF)
├── LICENSE                      # MIT (code)
└── README.md
```

## Running it

This is a multi-service big-data project. The notebooks assume access to **Spark**, and the
relevant stages assume **Kafka**, **MySQL**, and **Cassandra** are reachable (see
[`scripts/commands.sh`](scripts/commands.sh) for the cluster/service commands used).

```bash
# dashboard (after producing the processed data via the notebooks)
cd dashboard
pip install streamlit pandas plotly
streamlit run app.py
```

> **Datasets and trained models are not tracked** in this repository (see `.gitignore`); the
> notebooks ingest and generate them. Expected input paths live under `Data/` (e.g.
> `Data/stocktweet/stocktweet.csv`) and the dashboard reads
> `Data/dashboard/preprocessed_data.csv`.

## Report

A written academic report accompanies the project — see [`report/`](report/).

## Tech stack

`Python` · `Apache Spark` / `PySpark` · `Spark NLP` · `Transformers` (FinBERT, RoBERTa, BERTweet,
XLM-RoBERTa) · `VADER` · `Apache Kafka` · `MySQL` · `Apache Cassandra` · `MongoDB` · `YCSB` ·
`statsmodels` (ARIMA/VARMAX) · `TensorFlow`/`Keras` (LSTM) · `Plotly` · `Streamlit` · `Jupyter`

## Author

**Marco Vitucci** — MSc in Data Analytics.

## License

Code, notebooks, scripts, and dashboard are released under the [MIT License](LICENSE). The
written report and its figures are © 2025 Marco Vitucci, all rights reserved. Datasets (stock
prices and tweets) remain subject to the terms of their original providers; tweet content
belongs to its respective authors and is used for academic, non-commercial purposes.
