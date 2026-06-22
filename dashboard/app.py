import streamlit as st
import pandas as pd
import plotly.graph_objects as go

# Set page configuration
st.set_page_config(
    page_title="Stock Prices Dashboard",
    page_icon="📈",
    layout="wide")

# Add custom CSS styling
st.markdown("""
<style>

/* Customize slider number */
div.stSlider > div[data-baseweb="slider"] > div > div > div > div {
    font-weight: bold;
    font-size: 20px;
}

/* Adjust padding for block container */
[data-testid="stMainBlockContainer"] {
    padding-top: 2rem;
}

/* Adjust spacing and alignment for vertical blocks */
[data-testid="stVerticalBlock"] {
    padding-left: 0rem;
    padding-right: 0rem;
    padding-top: 1rem;
}

/* Attach radio buttons like tabs */
[data-testid="stRadio"] label {
    border-radius: 0px !important;
    margin: 0px !important;
    height: 40px;
    font-size: 16px;
    padding: 6px 12px;
    color: white;
    background-color: #0E1117; /* dark background */
}

/* Highlight hovered radio button */
[data-testid="stRadio"] label:hover {
    background-color: #00796B !important;
    color: white !important;
}

/* Remove margin above the chart */
div[data-testid="stPlotlyChart"] {
    padding-top: 0rem !important;
    margin-top: -1rem !important;
}

.plot-container .svg-container {
    height: calc(100vh - 500px) !important;
    min-height: 400px !important;
}

</style>
""", unsafe_allow_html=True)

company_names = {
    'TSLA': 'Tesla, Inc.',
    'BA': 'The Boeing Company',
    'DIS': 'The Walt Disney Company',
    'AAPL': 'Apple Inc.',
    'AMZN': 'Amazon.com, Inc.',
    'MSFT': 'Microsoft Corporation'
}

filename='Data/dashboard/preprocessed_data.csv'
preprocessed_df = pd.read_csv(filename)
preprocessed_df['Date'] = pd.to_datetime(preprocessed_df['Date'])

# Main Title for Context
st.markdown("""
## 📊 Stock Price and Prediction Dashboard

This dashboard visualizes recent historical stock prices and short-term future predictions for **TSLA, BA, DIS, AAPL, AMZN and MSFT** stock tickers.
Users can seamlessly switch between these stocks using the selector below to view individual trends, performance metrics, and forecasted values over customizable time periods.
""")

# Select stock
stock = st.selectbox("Choose Stock", preprocessed_df['Ticker'].unique())
company_name = company_names.get(stock, stock)  # fallback if not found
stock_data = preprocessed_df[preprocessed_df['Ticker'] == stock]

# Time Range section
col1, col2 = st.columns([4, 2])

with col1:
    st.subheader(f"{company_name} ({stock})")

with col2:
    period = st.radio(
        " ",
        options=["1D", "5D", "1M", "6M", "1Y", "All"],
        index=2,
        horizontal=True,
        label_visibility="collapsed"  # Hide the default label
    )


hist_data = stock_data[stock_data['Type'] == 'historical']
pred_data = stock_data[stock_data['Type'] == 'prediction']

def filter_by_period(df, period_choice):
    if period_choice == "All":
        return df
    else:
        last_date = df['Date'].max()
        if period_choice == "1D":
            start_date = last_date - pd.Timedelta(days=1)
        elif period_choice == "5D":
            start_date = last_date - pd.Timedelta(days=5)
        elif period_choice == "1M":
            start_date = last_date - pd.DateOffset(months=1)
        elif period_choice == "6M":
            start_date = last_date - pd.DateOffset(months=6)
        elif period_choice == "1Y":
            start_date = last_date - pd.DateOffset(years=1)
        else:
            start_date = df['Date'].min()

        return df[df['Date'] >= start_date]

hist_data_filtered = filter_by_period(hist_data, period)
latest_close = hist_data['Close'].iloc[-1] if not hist_data.empty else None

fig = go.Figure()

# Plot Historical Close Prices
fig.add_trace(go.Scatter(
    x=hist_data_filtered['Date'],
    y=hist_data_filtered['Close'],
    mode='lines+markers',
    name='Historical Close Price',
    line=dict(color='rgb(0, 121, 107)'),
    marker=dict(
        size=6,
        color='lime',
        line=dict(width=2, color='rgb(0, 121, 107)')
    ),
    hovertemplate=
        '<b>Open:</b> %{customdata[0]:.2f}<br>'+
        '<b>High:</b> %{customdata[1]:.2f}<br>'+
        '<b>Low:</b> %{customdata[2]:.2f}<br>'+
        '<b>Close:</b> %{y:.2f}<br>'+
        '<b>Volume:</b> %{customdata[3]:,.0f}<extra></extra>',
    customdata=hist_data_filtered[['Open', 'High', 'Low', 'Volume']].values
))


# Plot Predictions
fig.add_trace(go.Scatter(
    x=pred_data['Date'],
    y=pred_data['Close'],
    mode='markers+text',
    name='Future Predictions',
    text=["t+1", "t+3", "t+7"],
    textposition="top center",
    textfont=dict(size=16, color='white'),
    marker=dict(size=12, color='red', symbol='x'),
    hovertemplate='<b>Predicted Close:</b> %{y:.2f}<extra></extra>'
))

# Add latest price line and label
if latest_close:
    fig.add_shape(
        type="line",
        x0=hist_data_filtered['Date'].min(),
        x1=hist_data_filtered['Date'].max() + pd.Timedelta(days=30),
        y0=latest_close,
        y1=latest_close,
        line=dict(color="rgb(0, 121, 107)", width=2, dash="dash"),
        xref='x',
        yref='y'
    )
    fig.add_annotation(
        x=hist_data_filtered['Date'].max() + pd.Timedelta(days=10),
        y=latest_close,
        text=f"{latest_close:.2f}",
        showarrow=False,
        font=dict(color="white", size=14),
        bgcolor="rgb(0, 121, 107)",
        bordercolor="black",
        borderwidth=1,
        xanchor="left"
    )

# Config
fig.update_layout(
    xaxis=dict(
        title="Date",
        titlefont=dict(size=20),
        tickfont=dict(size=16),
        showgrid=True,
        gridcolor='lightgray'
    ),
    yaxis=dict(
        title="Price",
        titlefont=dict(size=20),
        tickfont=dict(size=16),
        showline=True,
        gridcolor='lightgray'
    ),
    hoverlabel=dict(
        font_size=14
    ),
    legend=dict(
        font=dict(size=14),
    ),
    autosize=True,
)

fig.update_layout(
    margin=dict(t=20, b=40, l=40, r=20)
)

visible_min = hist_data_filtered['Close'].min()
visible_max = hist_data_filtered['Close'].max()

# Add Max/Min annotation
fig.add_annotation(
    xref='paper',
    yref='paper',
    x=1.02,
    y=0.4,
    text=f"Max: {visible_max:.2f}<br>Min: {visible_min:.2f}",
    showarrow=False,
    font=dict(size=14, color="black"),
    align="center",
    bgcolor="white",
    bordercolor="black",
    borderwidth=1,
    opacity=0.9
)

st.plotly_chart(fig, use_container_width=True, use_container_height=True)

# Table data section
with st.expander("Show Table Data"):
    col1, col2 = st.columns([9, 1])

    with col1:
        st.subheader(f"{stock} Full Data")

    with col2:
        full_table = stock_data.copy()
        csv = full_table.to_csv(index=False).encode('utf-8')
        st.download_button(
            label="Download",
            data=csv,
            file_name=f"{stock}_full_data.csv",
            mime='text/csv'
        )

    full_table['Date'] = full_table['Date'].dt.strftime('%Y-%m-%d')
    st.dataframe(full_table)
