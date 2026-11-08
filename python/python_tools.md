## uv
```
brew install uv
cd dev-assistant
mkdir backend
cd backend
uv init
uv add "fastapi[standard]"
```

from fastapi import FastAPI

app = FastAPI(
    title="DevAssistant API",
    description="开发助手后端服务",
    version="0.1.0"
)


@app.get("/")
async def root():
    return {"message": "Hello DevAssistant"}


uv run fastapi dev main.py