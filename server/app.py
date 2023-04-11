## Flask
# - 웹 전용 라이브러리
# - 최소한의 구성요소와 요구사항 제공 ; 사용 용이

from flask import Flask, render_template, request, redirect, jsonify
import pandas as pd

# Flask 클래스 생성
# __name__ : 현재 파일의 이름
app = Flask(__name__)

# api 생성
# router() -> 네비게이션 함수; 해당 주소로 요청이 들어왔을 때 아래 함수 실행
# localhost:3000/
# localhost 대신 127.0.0.1 으로 대체 가능
@app.route("/")
def index():
    return render_template('index.html')


@app.route("/second/")
def second():
    return render_template("second.html")


@app.route("/login/", methods=["post"])
def login():
    #유저가 보낸 데이터를 변수에 대입
    #_id는 html의 input 안 name 속성의 값
    _id = request.form["_id"]
    _password = request.form["_pass"]
    print(_id,_password)

    if (_id=="test") and (_password=="1234"):
        return render_template("main.html", id=_id, password=_password)
    else:
        return redirect("/")


@app.route("/corona/")
def corona():
    servicekey = request.args["servicekey"]
    print("서비스 인증 키",servicekey)
    
    if servicekey=="aaa":
        df = pd.read_csv("../csv/corona.csv")
        json_data = df.to_json()
        return jsonify(json_data)
    else:
        return "servicekey error"

app.run(port=3000)