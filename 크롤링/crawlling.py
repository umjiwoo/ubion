from bs4 import BeautifulSoup as bs
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from datetime import datetime
import pandas as pd


path = "C:/Users/umjiwoo/OneDrive/문서/금융빅데이터 과정/ubion/chromedriver.exe"

driver = webdriver.Chrome(path)

code = "005380"
driver.get("https://navercomp.wisereport.co.kr/v2/company/c1010001.aspx?cmp_cd="+code)


element = driver.find_element(By.CLASS_NAME, "menu")
element2 = element.find_elements(By.TAG_NAME, "a")[3]
element2.click()

soup = bs(driver.page_source, "html.parser")

data = soup.find_all("table", 
                    attrs={"class":"gHead01 all-width data-list"})[1]


_list = data.find_all('th')


col_list = []
for i in _list:
    i = i.get_text().replace("\n","").replace("\t", "")
    i = i.replace("연간컨센서스보기", "").replace("연간컨센서스닫기","")
    col_list.append(i)


data2 = data.find("tbody")

data3 = data2.find_all("tr")


val_list = []

for i in data3:
    _list = i.find_all('td')
    sample_list = []
    for j in _list:
        sample_list.append(j.get_text())

    val_list.append(sample_list)

df = pd.DataFrame(val_list, columns=col_list)

def change(x):
    result = x.replace("\n", "")
    result = result.replace("\t","")
    result = result.replace("펼치기", "")
    return result

df['항목'] = df['항목'].apply(change)

df.columns = ['항목', '2018/12(IFRS연결)', '2019/12(IFRS연결)', '2020/12(IFRS연결)','2021/12(IFRS연결)', '2022/12(IFRS연결)', '2023/12(E)(IFRS연결)', '전년대비(2022)','전년대비(2022)']

now = datetime.now()
now = now.strftime("%Y%m%d%H%M%S")


df.to_csv(f'C:/crawlling_data/test{str(now)}.csv', index=False)