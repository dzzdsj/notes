
### website
https://openrouter.ai/chat
https://chatgpt.com/
https://codeassist.google#available-in-your-terminal-favorite-ides-and-platforms
https://claude.ai/chat/69af4208-9768-4aa1-9ab2-47b22ce58c62?onboarding=1
https://groq.com/?utm_source=chatgpt.com
模型下载：
https://huggingface.co


### install
```
https://console.cloud.google.com/apis/api/geminicloudassist.googleapis.com/metrics?project=dzzdsj-project&authuser=1&supportedpurview=project

brew install gemini-cli
export https_proxy=http://127.0.0.1:7897
export http_proxy=http://127.0.0.1:7897
export GEMINI_API_KEY="Default Gemini API Key"
AIzaSyCbh5yCJREZE85DwDngAmzXJTpVDs_UU_Q
gemini
```

### mcp
```
Gemini CLI 深度集成并支持 Model Context Protocol
  (MCP)，允许大模型通过标准协议访问外部数据库、API、本地文件和工具。

  以下是详细的使用指南：

  1. 配置 MCP 服务
  你可以通过修改 settings.json（位于 ~/.gemini/settings.json 或项目根目录下的
  .gemini/settings.json）来配置 MCP 服务。

  在 mcpServers 对象中添加服务配置：

    1 {
    2   "mcpServers": {
    3     "my-tools": {
    4       "command": "npx",
    5       "args": ["-y", "@modelcontextprotocol/server-everything"],
    6       "env": {
    7         "API_KEY": "your_secret_key"
    8       }
    9     }
   10   }
   11 }
   * Stdio 传输： 使用 command 和 args（如上面的例子）。
   * SSE (HTTP) 传输： 使用 url 指向远程服务。
   * 权限控制： 设置 "trust": true 可以跳过工具调用的确认弹窗。

  2. 核心功能
   * 工具发现 (Tools)： Gemini 会自动识别服务器提供的工具，并将其重命名为 mcp_服务名_工具名。
   * 资源访问 (Resources)： 可以在对话中使用 @ 语法引用资源，例如 @mysql://db/table。
   * 提示词模板 (Prompts)： MCP 服务预设的 Prompt 会变成斜杠命令，例如 /analyze-logs。
   * 安全： 支持 OAuth 2.0 认证，可以通过 /mcp auth <name> 触发授权。

  3. 常用命令
  为了方便管理，Gemini CLI 提供了内置的 gemini mcp 命令：

   * 添加服务：

   1     gemini mcp add my-db-tool npx -y @modelcontextprotocol/server-postgres
     "postgresql://localhost/mydb"
   * 查看状态：

   1     gemini mcp list
   * 启用/禁用：

   1     gemini mcp enable <name>
   2     gemini mcp disable <name>
   * 移除服务：
   1     gemini mcp remove <name>

  4. 在对话中使用
  配置好后，在 Gemini CLI 的对话界面：
   1. 输入 /mcp reload 强制重新加载配置。
   2. 输入 /mcp status 查看当前激活的 MCP 服务及其提供的工具。
   3. 直接向 Gemini 提出需求，它会自动判断并调用对应的 MCP 工具。

  总结： Gemini 将 MCP 作为一种“外挂知识库和工具箱”的标准化方式，通过简单的配置即可让 AI
  具备操作本地环境或访问特定 API 的能力。
  ```
## ollama
```shell
curl -X POST \
-H "Content-Type: application/json" \
-H "Accept: text/event-stream" \
-d '{
  "model": "deepseek-r1:8b",
  "prompt": "What is the meaning of life?"
  }' \
http://localhost:11434/api/generate
  
# 允许远程访问 需配置环境变量 OLLAMA_HOST=0.0.0.0
curl -X POST \
-H "Content-Type: application/json" \
-H "Accept: text/event-stream" \
-d '{
  "model": "deepseek-r1:8b",
  "prompt": "What is the meaning of life?"
  }' \
http://192.168.50.50:11434/api/generate  



```
## llama.cpp
```
#pip install llama-cpp-python
```

## google antigravity 替代gemini
https://antigravity.google/download

Skills
1 skills

Create new skills
  Workspace: ~/git/dzzdsj-git/github/CodeRepo/.agents/skills/{skill_name}/SKILL.md
  Global:    ~/.gemini/antigravity-cli/skills/{skill_name}/SKILL.md
  Shared:    ~/.gemini/skills/{skill_name}/SKILL.md

/Users/dzzdsj/.gemini/antigravity-cli/builtin/skills · From ~/.gemini/antigravity-cli/skills.json
› antigravity-guide: Provides a comprehensive guide, quick reference, and sitemap for Google Antigravity (AGY), includi...

### 向量数据库


1. 入门阶段：使用 Chroma，快速理解 Embedding、向量检索和 RAG 的基本流程。
2. 进阶阶段：切换到 Qdrant，学习集合（Collection）、索引、元数据过滤、持久化和生产环境部署。
3. 企业实践：进一步学习 Milvus，了解分布式架构、海量向量管理和性能优化。
4. 企业搜索方向：补充学习 Elasticsearch 的混合检索（BM25 + Vector Search），这是很多企业知识库的常见方案。