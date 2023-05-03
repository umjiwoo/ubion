library(dplyr)
library(ggplot2)

# 극단치 확인
View(mpg)

# 극단치 시각화
boxplot(mpg$hwy)

# 극단치를 수치로 표현
boxplot(mpg$cty)$stats

# ggplot2 라이브러리에 있는 mpg를 가져옴
mpg = ggplot2::mpg

# 이상치->26 초과이거나 9미만인 경우
# 이상치를 결측치로 변환
mpg[mpg[["cty"]] > 26 | mpg[["cty"]] < 9,]

mpg$cty = ifelse(mpg$cty >26 | mpg$cty < 9,NA,mpg$cty)

View(mpg)

# 결측치 개수 확인 -> table();지정한 컬럼or데이터프레임에 대한 요약정보 출력
table(is.na(mpg$cty))

# dplyr 패키지를 이용해
# 결측치를 제거하고 제조사별(manufacturer)로 그룹화하여 도심연비(cty)의 평균 구하기
# 도심연비가 좋은 상위 5개 제조사 확인
group_m = mpg %>% group_by(manufacturer) %>% summarise(mean_cty=mean(cty,na.rm=T))
group_m = group_m[order(-group_m$mean_cty),]
head(group_m,5)



mpg = ggplot2::mpg

# total 파생변수 생성 - (cty + hwy) / 2 값을 가짐
# total = (mpg$cty + mpg$hwy) / 2
# 1) mpg$total= total
# 2) data.frame(mpg,total)
# 3) cbind(mpg,total)
# 4) mpg %>% mutate(total = (cty + hwy) / 2) -> mpg

# test 파생변수 생성
# total이 30 이상이면 'A',20 이상이고 30 미만이면 'B', 20 미만이면 'C' 값을 가짐

mpg$total = (mpg$cty + mpg$hwy) / 2

mpg$test = ifelse(mpg$total>=30,"A",ifelse(mpg$total>=20 & mpg$total < 30,"B","C"))

# 이미 첫번째 조건에서 걸리는 경우 두번째 조건까지 않기때문에
#두번째 ifelse문에 mpg$total < 30 조건 지정해주지 않아도 됨
mpg$test = ifelse(mpg$total>=30,"A",
                  ifelse(mpg$total>=20,"B","C"))



midw=ggplot2::midwest
View(midw)

# 컬럼 이름 변경 -> rename()사용 ; rename(데이터프레임명, 새 컬럼 이름=변경이 될 컬럼의 이름(즉,기존 컬럼 이름))
# popasian 컬럼 -> asian , poptotal 컬럼-> total로 변경
# ratio 파생변수 생성(전체 인구수 대비 아시아 인구수-백분율로)
# group 파생변수 생성
# ratio 평균보다 ratio 값이 큰 데이터에 대해서는 "large", 아니면 "small"
midw = rename(midw,asian=popasian)
midw = rename(midw,total=poptotal)

# way1)
midw$ratio = (midw$asian / midw$total) * 100
# way2)
midw %>% mutate(ratio=asia/total*100) -> midw

midw$group = ifelse(midw$ratio>mean(midw$ratio),"large","small")

qplot(midw$group)
