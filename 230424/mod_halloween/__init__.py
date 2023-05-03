# class 선언 ; Halloween
# 생성자 함수에서 데이터프레임, 시작년도, 종료년도 매개변수로 받음
# self변수 생성, self.acc_rtn 변수는 1로 고정
import pandas as pd
from datetime import datetime
from dateutil.relativedelta import relativedelta

class Halloween():
    def __init__(self,df,start,end):
        self.df = df
        self.start = start
        self.end = end
        self.acc_rtn = 1

    def accrtn(self):
        if "Date" in self.df.columns:
            self.df["Date"] = pd.to_datetime(self.df["Date"],format="%Y-%m-%d")
            self.df.set_index("Date", inplace=True)

        for i in range(self.start,self.end):
            self.buy_mon = str(i) + "-11"
            self.sell_mon = str(i+1) + "-04"

            self.buy = self.df.loc[self.buy_mon].iloc[0]["Open"]
            self.sell = self.df.loc[self.sell_mon].iloc[-1]["Adj Close"]

            self.rtn = (self.sell - self.buy) / self.buy + 1
            self.acc_rtn *= self.rtn


        return self.acc_rtn
    
    def cagr(self):
        self.due = self.end - self.start
        self.CAGR = self.acc_rtn ** (1/self.due) - 1
        
        return self.CAGR * 100