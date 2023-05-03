# 벡터데이터 생성
a = c(1,2,3,4,5)
a
1:5 -> b
b
c=c(1,"test")
c

# 행렬
d = array(1:20,dim=c(4,5))
d

e = matrix(1:20,nrow=2)
e

# 리스트 형태 -> python의 dict형태와 흡사
f = list(name='test',age=20,phone="01012345678")
f
f["name"]

# 데이터프레임
df = data.frame(name=c("test1","test2"),
                age=c(20,30),
                phone=c("01012345678","01011112222"))
df


# 조건문(if문)
a <- 10
if(a>15){
  print("a는 15보다 크다.")
}else{
  print("a는 15보다 작다.")
}


# 조건문->조건이 여러개인 경우
a = 15
if(a>15){
  print("a는 15보다 크다.")
}else if(a==15){
  print("a는 15와 같다.")
}else{
  print("a는 15보다 작다.")
}


# which문 -> python의 find()와 흡사
name=c("test1","test2","test3")
# 찾는 값의 인덱스 반환
which(name=="test2")
which(name!="test2")
# 찾는 값이 존재하지 않으면 -> 0반환
which(name=="test4")


# 패키지 설치
# install.packages("dplyr")


# 연산자 생성
'%s%' = function(x,y){
  result = x + y
  return (result)
}

5 %s% 3

func_1 = function(){
  print("Hello World")
}

func_1()


func_2 = function(x,y){
  result = x ^ y
  return (result)
}

func_2(3,4)


# 함수 매개변수 기본값 설정
func_3 = function(x,y=3){
  result = x - y
  return (result)
}

func_3(4)
func_3(5,2)


# 데이터프레임
name = c("test1","test2","test3","test4")
grade = c(1,3,2,1)

student = data.frame(name,grade)
student


# 행렬
midterm = c(70,80,60,90)
finalterm = c(60,90,80,90)
score = cbind(midterm,finalterm)

score

total_score = midterm + finalterm
total_score

# 데이터프레임 생성 시 행렬이든 데이터프레임이든 벡터든
# 조건만 맞으면 데이터프레임으로 연결 가능
students = data.frame(student,score,total_score)
students


gender = c("F","M","M","F")
# gender 컬럼 추가하는 방법법
# 1. cbind()로로 gender 컬럼 이어주기
cbind(students,gender)
# 2. 데이터프레임을 생성하는 함수 frame()
data.frame(students,gender)
# 3. 데이터프레임에 gender 파생변수 생성
students$gender = gender
students


# 컬럼을하나만 출력하는 방법3가지
students$midterm
students[["midterm"]]
students[[3]]


# 행 추가하기
new_student = data.frame(
  name="test5",
  grade=3,
  midterm=80,
  finalterm=60,
  gender="F",
  total_score=midterm+finalterm
)
new_student

rbind(students,new_student) -> students
students

# 첫번째 항목(index=1) 추출
students[1,]
# 두번째,네번째 항목 추출
students[c(2,4),]
# 첫번째~세번째 항목 추출
students[1:3,]
# 첫번째 항목 빼고 추출
students[-1,]


# 특정한 조건을 이용해 필터링
# 학년이 2학년 이상인지 grade컬럼(하나의 벡터)에 대해
# 2학년 이상이면 True,아니면 False반환
students[["grade"]] >= 2
students[students[["grade"]]>=2,]


# 중간 성적이 70 이상이고 기말 성적이 90이상인 학생들 정보 출력
students[students[["midterm"]]>=70 & students[["finalterm"]]>=90,]

students[["midterm"]]>=70 & students[["finalterm"]]>=90 -> flag
students[flag,]

# 정렬 변경
order(students$grade)
# 오름차순 정렬
students[order(students$grade),]
# 내림차순 정렬
students[order(-students$grade),]
students[order(students$grade,decreasing=TRUE),]

