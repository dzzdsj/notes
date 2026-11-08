## 基础使用
```
from fastapi import FastAPI

app = FastAPI()

@app.get("/hello")
def hello():
    return "Hello FastAPI"
```
```
#执行main.py中的app
uvicorn main:app --host 0.0.0.0 --port 8000
```

http://127.0.0.1:8000/docs

