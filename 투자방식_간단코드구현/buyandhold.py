import numpy as np
from datetime import datetime

def bnh(df, col, start, end):
    start = datetime.strptime(start,"%Y%m%d").isoformat()
    end = datetime.strptime(end,"%Y%m%d").isoformat()

    df = df.loc[start:end]

    df = df.loc[~df.isin([np.nan, np.inf, -np.inf]).any(axis="columns")]

    df = df[[col]]

    df["daily_rtn"] = df[col].pct_change()

    df["st_rtn"] = (1 + df["daily_rtn"]).cumprod()

    return df