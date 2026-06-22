# Dashboard

An interactive **Streamlit** dashboard presenting the stock-sentiment and forecasting results
with **Plotly** charts.

## Run it

```bash
cd dashboard
pip install streamlit pandas plotly
streamlit run app.py
```

The app reads the processed data produced by the notebooks from
`Data/dashboard/preprocessed_data.csv` (relative to the project root), so generate that file
first by running the analysis notebooks, then launch the dashboard.

## Features

- Per-stock price and indicator views for the 10 tracked tickers.
- Sentiment overlays from the multi-model ensemble.
- Downloadable per-stock data export.
