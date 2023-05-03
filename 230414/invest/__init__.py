import pandas as pd
from invest import momentum as mm
from invest import buyandhold as bnh

class Invest:
    def __init__(self,_df,_col="Close",_start="20100101",_end="20230101"):
        self.df = _df
        self.col = _col
        self.start = _start
        self.end = _end


    def momentum(self):
        self.df1 = mm.momentum_1(self.df,self.col,self.start,self.end)
        self.df2 = mm.momentum_2(self.df1)
        self.result = mm.momentum_3(self.df1, self.df2)

        return self.result
    

    def buyandhold(self):
        self.result = bnh.bnh(self.df,self.col,self.start,self.end)
        
        return self.result