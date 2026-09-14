# Stock Market Data Mining

Final project for Data Programming 2 (Georgian College, Big Data Analytics).

A desktop tool that pulls daily stock data from Alpha Vantage and runs a set of analyses: moving averages, monthly overview, ROI, beta, rolling volatility and frequency trends for monthly highs and lows.

## Files

- `stock_analysis.ipynb` – the analysis logic on its own, saved with its outputs so the charts show on GitHub.
- `sample_data/` – daily AAPL, MSFT and SPY prices from Alpha Vantage (2023-01-03 to 2024-07-19). The notebook uses these when no API key is set.
- `investinsight_app.py` – the full Tkinter desktop app.
- `Symbol.txt` – list of tickers shown in the app dropdown (one per line).
- `assets/800x600.jpg` – background image for the app.
- `.env.example` – template for your own API key.

## Running the notebook

No API key needed. The notebook uses `sample_data/` by default (`USE_SAMPLE_DATA = True` in the first code cell). Requires pandas 2.2 or newer.

```
pip install -r requirements.txt
jupyter notebook stock_analysis.ipynb
```

## Live data (optional)

To pull fresh data, set `USE_SAMPLE_DATA = False` in the notebook. For that, or to run the desktop app, get a free key from https://www.alphavantage.co, then copy `.env.example` to `.env` and paste your key in:

```
ALPHAVANTAGE_API_KEY=your_key
```

`.env` is gitignored, so your key never gets committed. Run the app with `python investinsight_app.py`.

The free tier allows 25 requests per day, so the notebook caches each downloaded symbol in `data/` (also gitignored).

## Team

- Kifah Owda – technical design document, data pipeline, cleaning and all analysis functions
- Pitchaporn Keenaphan – Tkinter UI/UX
