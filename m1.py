# 평균을 구하는 함수
# 인자 수 가변

def calc_avg(*args):
    d=len(args)
    total=sum(args)
    return total/d