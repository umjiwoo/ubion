import pandas as pd
import numpy as np
from datetime import datetime


def momentum_1(df, col="Close", start="20100101", end="20230101"):
    # 인덱스가 Date가 아닌 경우 -> Date 컬럼을 인덱스로 변경
    if "Date" in df.columns:
        df.set_index("Date", inplace=True)

    # start,end 시계열 변경
    start = datetime.strptime(start,"%Y%m%d").isoformat()
    end = datetime.strptime(end,"%Y%m%d").isoformat()
    

    df = df.loc[~df.isin((np.nan, np.inf, -np.inf)).any(axis="columns")]
    print(type(df))

    ## 여기서 df1 = df["Adj Close"] 대괄호 하나만 치면
    ## Series 형태로 반환
    ## -> 데이터프레임 사용하려고 할 때 오류남
    # df1 = df[["Adj Close"]]
    df1 = df[[col]]

    df1.index = pd.to_datetime(df1.index, format="%Y-%m-%d")

    df1 = df1.loc[start:end]

    df1["STD-YM"] = list(map(lambda x: datetime.strftime(x,"%Y-%m"),df1.index))
    print(df1)
    print(type(df1))

    return df1


def momentum_2(df):
    col = df.columns[0]

    # # 월별 마지막 날 데이터만 추출하기

    # # 방법1) -df2> for문 이용
    # df2 = pd.DataFrame()

    # # for문 돌기 위해 df["STD-YM"] 행 정보의 중복값을 제거
    # _list = df["STD-YM"].unique()

    # for i in _list:
    #     # 년-월 별 데이터프레임들로 쪼갠 후 가장 마지막 행을 df2에 추가
    #     last_df = df.loc[df["STD-YM"] == i].tail(1)
    #     df2 = pd.concat([df2,last_df])

    # 방법2)
    df2 = df.loc[df["STD-YM"]!=df["STD-YM"].shift(-1)]

    df2["BF_1M"] = df2[col].shift(1).fillna(0)
    df2["BF_12M"] = df2[col].shift(12).fillna(0)

    return df2


def momentum_3(df1,df2):
    col = df1.columns[0]

    # 수익률 계산을 위한 변수
    buy = 0
    sell = 0

    df1["trade"] = ""
    df1["return"] = 1

    for i in df2.index:
        signal = ""
        momentum_index = (df2.loc[i,"BF_1M"] / df2.loc[i,"BF_12M"]) - 1

        flag = True if ((momentum_index>0) and (momentum_index!=np.inf) and (momentum_index!=-np.inf)) else False

        if flag:
            signal = "buy"

        df1.loc[i,"trade"] = signal

    for i in df1.index:
        ## 매수한 경우
        if (df1.loc[i,"trade"] == "buy" and  df1.shift(1).loc[i,"trade"] == ""):
            buy = df1.loc[i,col]
    
        ## 매도한 경우
        elif (df1.loc[i,"trade"] == "" and  df1.shift(1).loc[i,"trade"] == "buy"):
            sell = df1.loc[i,col]
            rtn = (sell - buy) / buy + 1

            df1.loc[i,"return"] = (sell - buy) / buy + 1
    
    df1["acc_rtn"] = df1["return"].cumprod()

    print("누적수익률\n",df1.tail(1)["acc_rtn"])

    return df1
