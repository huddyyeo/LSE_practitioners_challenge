# LSE Statistics Department Practitioners Challenge 2020

This is the GitHub repository for a research project on establishing a robust methodology to forecast the correlations between the risk factors most likely to impact Aviva UK’s balance sheet over a 1-year period. This project was hosted by the London School of Economics and Political Science's Department of Statistics, in collaboration with Aviva UK.

We identified a total of five risk factors which we sought to model, namely interest rates, the yield on high-quality corporate bonds, the risk-free rate, inflation, and Gross Domestic Product (GDP). In addition, two statistical models were used to forecast rolling correlations among pairs of risk factors: 1) an ARMA model based on a rolling window, and 2) the DCC-GARCH model. We found the DCC-GARCH model to be the superior method to forecast these correlations.

Team members: Hudson Yeo, Jeria Kua, Nicholas Hutter, Gábor Ratkovics, Zain Hussein

Awarded Overall Champion of the Challenge.

The final results are in 'Final_Report.pdf'

## Directories

```
LSE Practitioners Challenge
├── Code
│   ├── DCC_Forecasts.R
│   ├── corrfx.py
│   ├── notebooks
│   │   ├── arma_testing.ipynb
│   │   ├── data_environment_and_testing.ipynb
│   │   └── forecast_errors.ipynb
│   └── stationarity_test.R
├── Data
│   ├── FTSE100_closing_data.csv
│   ├── UK_GDP_data.csv
│   ├── UK_gilt_yield_data.csv
│   ├── UK_inflation_data.csv
│   ├── UK_risk_free_rate_data.csv
│   ├── forecasts.csv
│   ├── forecasts_t.csv
│   ├── processed_data.csv
│   └── processed_linear.csv
├── Papers
│   ├── DCC Paper 4.pdf
│   ├── DCC Paper 5.pdf
│   ├── Dynamic Conditional Correlation.pdf
│   ├── GARCC paper.pdf
│   ├── Giovannini2006_Article_ConditionalCorrelationsInTheRe.pdf
│   ├── PwC Solvency II
Capital Model
Survey.pdf
│   ├── Ten Things You Should Know About the
Dynamic Conditional Correlation Representation.pdf
│   ├── Time Series Analysis.djvu
│   └── _LCP Solvency II report 2019.pdf
├── README.md
└── Writeups
    ├── Final_Report.pdf
    └── Working Reports
        ├── Practitioners challenge (PC) : risk factors.pdf
        ├── Risk Factors final choice (AutoRecovered).docx
        └── Risk Factors final.pdf
