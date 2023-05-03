import pandas as pd
import numpy as np
from datetime import datetime

def create_band(df, column_name, start, end):
    df.index = pd.to_datetime(df.index)

    start = datetime.strptime(start,"%Y%m%d").isoformat()
    end = datetime.strptime(end,"%Y%m%d").isoformat()

    df = df.loc[start:end]

    price_df = df.loc[(~df.isin((np.nan, np.inf, -np.inf)).any(axis="columns")),[column_name]]

    price_df["center"] = price_df[column_name].rolling(20).mean()
    price_df["ub"] = price_df["center"] + (2 * price_df[column_name].rolling(20).std())
    price_df["lb"] = price_df["center"] - (2 * price_df[column_name].rolling(20).std())

    return price_df


def add_trade(df):
    df["trade"]=""

    column_name = df.columns[0]

    for i in df.index:
        if df.loc[i,column_name] > df.loc[i,"ub"]:
            if df.shift(1).loc[i,"trade"] == "buy":
                df.loc[i,"trade"] = ""
            else:
                df.loc[i,"trade"] = ""
        
        elif df.loc[i,column_name] < df.loc[i,"lb"]:
            if df.shift(1).loc[i,"trade"] == "buy":
                df.loc[i,"trade"] = "buy"
            else:
                df.loc[i,"trade"] = "buy"

        else:
            if df.shift(1).loc[i,"trade"] == "buy":
                df.loc[i,"trade"] = "buy"
            else:
                df.loc[i,"trade"] = ""

    print("거래내역\n",df["trade"])

    return df


def cal_rtn(df):
    rtn = 1.0
    acc_rtn = 1.0
    df['return'] = 1
    buy = 0.0
    sell = 0.0

    column_name = df.columns[0]

    for i in df.index:
        if (df.shift(1).loc[i, 'trade'] == '') and (df.loc[i, 'trade'] == 'buy'):
            buy = df.loc[i, column_name]
            print('진입일 :', i, '구매 가격 :', buy)
        elif (df.shift(1).loc[i, 'trade'] == 'buy') and (df.loc[i, 'trade'] == ''):
            sell = df.loc[i, 'Adj Close']
            rtn = (sell - buy) / buy + 1
            df.loc[i, 'return'] = rtn
            print('판매일 :', i, '판매 가격 :', sell, '수익율 :', rtn)

        if df.loc[i, 'trade'] == '':
            buy = 0.0
            sell = 0.0

    for i in df.index:
        _rtn = df.loc[i,"return"]
        acc_rtn *= _rtn
        df.loc[i,"acc_rtn"] = acc_rtn

    print("누적 수익률 : ", acc_rtn)

    return