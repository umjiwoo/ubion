import pandas as pd
import numpy as np
from datetime import datetime

class Invest:
    # 생성자 함수
    def __init__(self,_df,_col):
        self.df = _df
        self.col = _col


    def create_band(self, start, end):
        self.df.index = pd.to_datetime(self.df.index)

        start = datetime.strptime(start,"%Y%m%d").isoformat()
        end = datetime.strptime(end,"%Y%m%d").isoformat()

        self.df = self.df.loc[start:end]

        self.df = self.df.loc[(~self.df.isin((np.nan, np.inf, -np.inf)).any(axis="columns")),[self.col]]

        self.df["center"] = self.df[self.col].rolling(20).mean()
        self.df["ub"] = self.df["center"] + (2 * self.df[self.col].rolling(20).std())
        self.df["lb"] = self.df["center"] - (2 * self.df[self.col].rolling(20).std())

        return self.df


    def add_trade(self):
        self.df["trade"]=""

        for i in self.df.index:
            if self.df.loc[i,self.col] > self.df.loc[i,"ub"]:
                if self.df.shift(1).loc[i,"trade"] == "buy":
                    self.df.loc[i,"trade"] = ""
                else:
                    self.df.loc[i,"trade"] = ""
            
            elif self.df.loc[i,self.col] < self.df.loc[i,"lb"]:
                if self.df.shift(1).loc[i,"trade"] == "buy":
                    self.df.loc[i,"trade"] = "buy"
                else:
                    self.df.loc[i,"trade"] = "buy"

            else:
                if self.df.shift(1).loc[i,"trade"] == "buy":
                    self.df.loc[i,"trade"] = "buy"
                else:
                    self.df.loc[i,"trade"] = ""

        print("거래내역\n",self.df["trade"])

        return self.df


    def cal_rtn(self):
        rtn = 1.0
        acc_rtn = 1.0
        self.df['return'] = 1
        buy = 0.0
        sell = 0.0

        for i in self.df.index:
            if (self.df.shift(1).loc[i, 'trade'] == '') and (self.df.loc[i, 'trade'] == 'buy'):
                buy = self.df.loc[i, self.col]
                print('진입일 :', i, '구매 가격 :', buy)
            elif (self.df.shift(1).loc[i, 'trade'] == 'buy') and (self.df.loc[i, 'trade'] == ''):
                sell = self.df.loc[i, 'Adj Close']
                rtn = (sell - buy) / buy + 1
                self.df.loc[i, 'return'] = rtn
                print('판매일 :', i, '판매 가격 :', sell, '수익율 :', rtn)

            if self.df.loc[i, 'trade'] == '':
                buy = 0.0
                sell = 0.0

        for i in self.df.index:
            _rtn = self.df.loc[i,"return"]
            acc_rtn *= _rtn
            self.df.loc[i,"acc_rtn"] = acc_rtn

        print("누적 수익률 : ", acc_rtn)

        return