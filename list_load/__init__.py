import os
import pandas as pd

# 함수의 형태로 폴더에 있는 파일들을 결합하는 함수 생성
def load(_dir, _ext=".csv"):
        #_dir : 파일 경로
        #_ext : 파일 확장자

        if not (_dir.endswith("/")):
            _dir += "/"

        if _ext[0]!=".":
            _ext = "." + _ext

        # print(_dir,_ext)
        
        #1.파일 리스트 호출
        file_list = os.listdir(_dir)

        #2.비어있는 데이터프레임 생성
        result = pd.DataFrame()

        #3.파일 리스트에서 확장자가 같은 파일들만 결합
        for i in file_list:
            if i.endswith(_ext):
                if _ext == ".csv":
                    df = pd.read_csv(_dir+i)
                    result = pd.concat([result,df],axis="rows",ignore_index=True)

                elif _ext == ".json":
                    df = pd.read_json(_dir+i)
                    result = pd.concat([result,df],axis="rows",ignore_index=True)

                # elif _ext == ".xlsx" or _ext == ".xls":
                #     df = pd.read_excel(_dir+i)
                #     result = pd.concat([result,df],axis="rows",ignore_index=True)
                
                elif _ext in [".xlsx",".xls"]:
                    df = pd.read_excel(_dir+i)
                    result = pd.concat([result,df],axis="rows",ignore_index=True)

                else:
                    print("지원하지 않는 확장자 입니다.")


        return result
