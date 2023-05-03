install.packages("foreign")
install.packages("readxl")

library(foreign)
library(readxl)

welfare =read.spss(file="./csv/Koweps_hpc10_2015_beta1.sav",
                   to.data.frame = T)


welfare = rename(welfare,
                 gender=h10_g3,
                 birth=h10_g4,
                 marriage=h10_g10,
                 religion=h10_g11,
                 income=p1002_8aq1,
                 code_job=h10_eco9,
                 code_region=h10_reg7)

welfare %>% select(gender,birth,marriage,religion,income,code_job,code_region) -> welfare_copy
welfare_copy


# 성별 컬럼 데이터 확인
table(welfare_copy$gender)
ifelse(welfare_copy$gender==1, "male","female") -> welfare_copy$gender


# 성별을 기준으로 월급 평균이 어떻게 되는가??
# income이 0이면 수익이 존재하지 않음 -> 결측치로 변경해주기
# income이 9999면 극단치로 보고 결측치로 변경해주기
ifelse(welfare_copy$income==0 | welfare_copy$income==9999,NA,welfare_copy$income) -> welfare_copy$income

table(is.na(welfare_copy$income))

# income의 결측치를 제외하고
# 성별로 그룹화해서
# 월급의 평균을 출력
# 시각화
welfare_copy %>% filter(!is.na(income)) %>% group_by(gender) %>% summarise(income_mean=mean(income)) -> gender_income
# or
welfare_copy %>% group_by(gender) %>% summarise(income_mean=(mean(income,na.rm=T)))

ggplot(data=gender_income,
       aes(x=gender,y=income_mean)) + geom_col()


# 나이별 월급의 차이가 존재하는가?
welfare_copy$age = 2023 - welfare_copy$birth

welfare_copy %>% filter(!is.na(income)) %>%
  group_by(age) %>%
  summarise(income_mean=mean(income)) -> age_income


ggplot(data=age_income,
       aes(x=age,y=income_mean))+geom_line()

age_income %>% arrange(-income_mean) %>% head(5) -> age_income_top_5

ggplot(data=age_income_top_5,
       aes(x=age,y=income_mean))+geom_col()


# 연령대 추가
# age가 30미만이면 "young"
# 30이상 60미만이면 "middle"
# 60이상이면 "old"
# 연령대별 월급의 평균이 어떻게 되는가
# 시각화
welfare_copy$age_level = ifelse(welfare_copy$age<30,"young",ifelse(welfare_copy$age<60,"middle","old"))

welfare_copy %>% filter(!is.na(income)) %>% group_by(age_level) %>% summarise(income_mean=mean(income)) -> age_level_income

ggplot(data=age_level_income,
       aes(x=age_level,y=income_mean)) + geom_col()


# 연령대, 성별 월급 평균
welfare_copy %>% 
  filter(!is.na(income)) %>% 
  group_by(age_level,gender) %>% 
  summarise(income_mean=mean(income)) -> age_level_gender_income


ggplot(data=age_level_gender_income,
       aes(x=age_level,y=income_mean,fill=gender))+
  geom_col(position="dodge")+
  scale_x_discrete(limits=c("young","middle","old"))


# 나이, 셩별 월급 평균 비교
welfare_copy %>% 
  filter(!is.na(income)) %>% 
  group_by(age,gender) %>% 
  summarise(income_mean=mean(income)) -> age_gender_income

ggplot(data=age_gender_income,
       aes(x=age,y=income_mean,color=gender))+geom_line()



# 다른 데이터 가져와서 합치기
# 직업별 평균 월급 계산하기-월급이 결측치인 경우 제외
# Koewps_Codebook.xlsx에 시트 2개 포함되어있음; 몇번째 시트 사용할 것인지 옵션으로 지정
list_job = read_excel("./csv/Koweps_Codebook.xlsx", sheet=2, col_names=T)
View(list_job)

left_join(welfare_copy,list_job,by="code_job") -> welfare_copy2

welfare_copy2 %>% filter(!is.na(code_job) & !is.na(income)) %>% 
  group_by(job) %>% 
  summarise(income_mean=mean(income)) %>% arrange(-income_mean) -> job_income

View(job_income)

job_income %>% head(10) -> job_income_top10
job_income %>% tail(10) -> job_income_bottom10

# 그래프 방향 가로로 돌리기 -> coord_flip()
ggplot(data=job_income_top10,
       aes(x=job,y=income_mean)) + geom_col() + coord_flip()

# income_mean값으로 정렬해서 그래프 그리기 -> reorder() 사용
ggplot(data=job_income_top10,
       aes(x=reorder(job, -income_mean),y=income_mean)) + geom_col() + coord_flip()

ggplot(data=job_income_bottom10,
       aes(x=reorder(job, -income_mean),y=income_mean)) + geom_col() + coord_flip()


# 한번에 10개 잘라서 data옵션에 넣어줌
ggplot(data=head(job_income,10),
       aes(x=job,y=income_mean)) + geom_col()



# 성별 직업의 빈도수를 체크해 상위 10개 출력
welfare_copy2 %>% filter(!is.na(job) & gender=="male") %>% 
  group_by(job) %>% 
  summarise(count=n()) %>% 
  arrange(-count) %>% 
  head(10) -> male_job_10

View(male_job_10)


welfare_copy2 %>% filter(!is.na(job) & gender=="female") %>% 
  group_by(job) %>% 
  summarise(count=n()) %>% 
  arrange(-count) %>% 
  head(10) -> female_job_10

View(female_job_10)


# marriage가 3인 경우 ; 이혼
# 새로운 파생변수 생성 -> group_marriage
# marriage가 3이면 group_marriage값="divorce"
# marriage가 1이면 group_marriage값="marriage"

# 연령대별 이혼율 시각화
welfare %>% select(gender,birth,marriage,religion,income,code_job,code_region) -> welfare_copy3
welfare_copy3$age = 2023 - welfare_copy$birth
welfare_copy3$age_level = ifelse(welfare_copy3$age<30,"young",ifelse(welfare_copy3$age<60,"middle","old"))


ifelse(welfare_copy3$marriage==1,
       "marriage",ifelse(welfare_copy3$marriage==3,
                         "divorce",NA)) -> welfare_copy3$group_marriage


welfare_copy3 %>% filter(!is.na(group_marriage)) %>% 
  group_by(age_level,group_marriage) %>% 
  summarise(count=n()) %>% 
  mutate(total_count=sum(count)) %>% 
  mutate(divorce_rate=count/total_count*100)

