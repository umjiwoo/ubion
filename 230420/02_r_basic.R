df = read.csv("csv/example.csv")
df

# 상위 6개 출력
head(df)
# 상위3개
head(df,3)

# 하위 6개 출력
tail(df)
# 하위 3개
tail(df,3)

# 뷰어창에서 데이터프레임 확인(V 대문자)
View(df)

# 데이터프레임 크기 출력 함수
dim(df)


# 데이터프레임에 기초 통계정보 출력-> python describe()함수와 흡사
summary(df)


# 데이터프레임의 정보 출력 -> python info()함수와 흡사
str(df)


library(dplyr)

# 컬럼 이름 변경
rename(df,"이름" = Name)


df = read.csv("./csv/csv_exam.csv")
df

# 새로운 파생변수 생성
# 전체 점수의 합계(total_score)
# 전체 점수의 평균(mean_score)
df$total_score = df$math + df$english + df$science
df$mean_score = df$total_score / 3
df


total_s = df$math + df[["english"]] + df[[5]]
total_s


# 평균점수가 60점 이상이면 pass, 아니면 fail
# res컬럼 생성해 pass/fail 저장
# if-else 한 줄로 처리 -> ifelse(조건식,참인 경우 결과,거짓인 경우 결과)
df$res = ifelse(df$mean_score>=60,"pass","fail")
df


# 1학년 중 평균 점수가 가장 높은 사람의 정보
class_1 = df[df[["class"]]==1,]
class_1[order(-class_1$mean_score),][1,]


# dplyr 패키지 사용
df2 = read.csv("./csv/csv_exam.csv")
# filter
df2 %>% filter(class==1)

# 정렬(오름차순)
df2 %>% arrange(math)
# 정렬(내림차순)
df2 %>% arrange(-math)
df2 %>% arrange(desc(math))

# 정렬의 기준이 여러가지
df2 %>% arrange(math,english)

# class를 기준으로 내림차순, math를 기준으로 오름차순
df2 %>% arrange(-class,math)
df2 %>% arrange(desc(class),math)

# 특정 컬럼만 출력
df2 %>% select(math)
select(df2,math)

# 파이프 이용하면 변수에 담는 작업 반복 수행 필요 x
df %>% arrange(desc(class)) %>% select(math,english)

# 특정 컬럼만 삭제
df2 %>% select(-id)

# 파생변수 생성
df2 %>% mutate(total_score = math + english + science,
               mean_score = total_score / 3) -> df2

# class가 1이고 평균점수가 가장 높은 학생 추출
df2 %>% filter(class==1) %>% arrange(-mean_score) %>% head(1)


# group화 summarise
# class로 그룹화하여 그룹별 수학,영어 평균 점수 계산산
df2 %>% group_by(class) %>% 
  summarise(mean_math=mean(math),
            mean_english=mean(english))


df2 %>% group_by(class) %>% 
  summarise(mean_math=mean(math),
            mean_english=mean(english)) %>% 
  arrange(-mean_math) %>% head(1)


# join
df_1 = data.frame(id=1:5,
                  score=c(80,70,40,60,50))
df_2 = data.frame(id=1:5,
                  weight=c(80,65,70,55,90))
df_3 = data.frame(id=1:3,
                  class=c(1,1,2))

inner_join(df_1,df_2,by="id")
inner_join(df_1,df_3,by="id")

left_join(df_1,df_3,by="id")
right_join(df_1,df_3,by="id")

# union결합
# rbind는 합치려는 데이터프레임 구조(컬럼 구조)가 똑같아야 수행할 수 있음
rbind(df_1,df_2)
bind_rows(df_1,df_2)


# 결측치에 대한 계산
# 결측치는 계산이 되지 않음
# 이때 필터를 사용하면 무조건 출력됨
c1 = c(1,2,NA,NA,5)
c2 = c(1,2,3,4,5)
c3 = c(NA,2,3,4,5)

df = data.frame(c1,c2,c3)

# 결측치 확인 방법
is.na(df)
table(is.na(df))

# 특정 컬럼의 결측치 확인 방법
is.na(df$c1)

# dplyr 패키지 이용해 결측치를 제거한 데이터 확인 방법
df %>% filter(is.na(df$c1))

# 수정
# filter 적용 시 df에 적용하는 게 이미 확정됐으므로
# 컬럼명 사용 시 df$c1으로 접근하지 않아도 됨됨
df %>% filter(is.na(c1))
# 결측치가 아닌 데이터행만 추출
df %>% filter(!is.na(c1))


# 결측치 포함 데이터행 삭제제
# omit()->지정한 데이터행 완전 삭제
na.omit(df)


# 결측치를 제외하고 연산 - 원래는 결측치 있으면 연산 안됨
mean(df$c1)
mean(df$c2)
mean(df$c3)

mean(df$c1, na.rm=T)


exam = read.csv("./csv/csv_exam.csv")
# exam 데이터프레임의 세번째 컬럼의 5,7번째 데이터에 NA값 대입
exam[c(5,7),3]=NA

# 수학점수의 평균값 출력
# 결측치 값을 수학점수 평균으로 대체
# -> ifelse()함수 이용
math_mean_score = mean(exam$math, na.rm=T)
exam$math = ifelse(is.na(exam$math),math_mean_score,exam$math)
exam

outlier = data.frame(gender=c(1,2,1,2,3),
                     score=c(80,90,70,80,50))
outlier

# gender가 3인 데이터를 이상치로 체크
# -> gender가 1,2인 경우에만 데이터를 출력
# base함수를 이용하는 경우
outlier[outlier$gender==1 | outlier$gender==2,]
outlier$gender==1 | outlier$gender==2

# dplry패키지를 이용하는 경우
outlier %>% filter(gender==1 | gender==2)

# step1)gender가 1또는2가 아니면 결측치로 변경
outlier$gender = ifelse(!(outlier$gender==1 | outlier$gender==2),NA,outlier$gender)
# 조건식 한번에 쓰기
ifelse(outlier$gender %in% c(1,2),outlier$gender,NA)
# NA항목만 뽑기
outlier$gender[outlier$gender!=1 & outlier$gender!=2]<-NA

# step2)결측치를 제거
# 방법1)
outlier = outlier %>% filter(!is.na(gender))
# 방법2)
na.omit(outlier)

