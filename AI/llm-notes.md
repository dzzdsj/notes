
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

Usage:
  ollama [flags]
  ollama [command]

Available Commands:
  serve        Start Ollama
  create       Create a model
  show         Show information for a model
  run          Run a model
  stop         Stop a running model
  pull         Pull a model from a registry
  push         Push a model to a registry
  signin       Sign in to ollama.com
  signout      Sign out from ollama.com
  list         List models
  ps           List running models
  cp           Copy a model
  rm           Remove a model
  launch       Launch the Ollama menu or an integration
  help         Help about any command

Flags:
  -h, --help         help for ollama
      --nowordwrap   Don't wrap words to the next line automatically
      --verbose      Show timings for response
  -v, --version      Show version information

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

https://www.datacamp.com/tutorial/how-to-use-claude-code-for-free

# lm studio
```
curl http://0.0.0.0:1234/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "deepseek/deepseek-r1/deepseek-r1-distill-qwen-14b-q4_k_m.gguf",
    "messages": [
      {
        "role": "system",
        "content": "You are a helpful jokester."
      },
      {
        "role": "user",
        "content": "Tell me a joke."
      }
    ],
    "response_format": {
      "type": "json_schema",
      "json_schema": {
        "name": "joke_response",
        "strict": "true",
        "schema": {
          "type": "object",
          "properties": {
            "joke": {
              "type": "string"
            }
          },
        "required": ["joke"]
        }
      }
    },
    "temperature": 0.7,
    "max_tokens": 50,
    "stream": false
  }'

## 
curl http://0.0.0.0:1234/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "deepseek/deepseek-r1/deepseek-r1-distill-qwen-14b-q4_k_m.gguf",
    "messages": [
      {
        "role": "system",
        "content": "You are a helpful programmer."
      },
      {
        "role": "user",
        "content": "Tell me about java hello world."
      }
    ],
    "response_format": {
      "type": "json_schema",
      "json_schema": {
        "name": "joke_response",
        "strict": "true",
        "schema": {
          "type": "object",
          "properties": {
            "joke": {
              "type": "string"
            }
          },
        "required": ["joke"]
        }
      }
    },
    "temperature": 0.7,
    "max_tokens": 5000,
    "stream": false
  }'

  curl http://localhost:1234/api/v1/chat \
  -H "Content-Type: application/json" \
  -d '{
    "model": "deepseek/deepseek-r1/deepseek-r1-distill-qwen-14b-q4_k_m.gguf",
    "system_prompt": "You answer only in rhymes.",
    "input": "What is your favorite color?"
}'

```
## claude code
```
curl -fsSL https://claude.ai/install.sh | bash
```

## 价格对比
1.claude:
Free
Try Claude

$0

Free for everyone

Try Claude
Chat on web, iOS, Android, and on your desktop
Generate code and visualize data
Write, edit, and create content
Ability to search the web
Memory across conversations
Create files and execute code
Unlock more from Claude with desktop extensions
Connect Slack and Google Workspace services
Integrate any context or tool through connectors with remote MCP
Extended thinking for complex work
Pro
For everyday productivity

$17

Per month with annual subscription discount ($200 billed up front). $20 if billed monthly.

Try Claude
Everything in Free, plus:

More usage*
Includes Claude Code
Includes Claude Cowork
Includes Claude Design
Includes Claude Science
Access to unlimited projects to organize chats and documents
Ability to use more Claude models
Claude for Microsoft 365
Max
Get the most out of Claude

From $100

Per month

Try Claude
Everything in Pro, plus:

Choose 5x or 20x more usage than Pro*
Higher output limits for all tasks
Early access to advanced Claude features
Priority access at high traffic times

2.codex:
Free
Try ChatGPT

See how AI can help find answers, explore ideas, and get things done in life and work.

$0
$
0
/ month


Your current plan
Start with the basics:
Unlimited everyday text chats
Limited access to image creation
Limited memory and storage
Limited voice chats
Ad supported
Have an existing plan? See billing help
ChatGPT Plus
RECOMMENDED
Your AI assistant

Unlock advanced intelligence that adapts to your preferences the more you use it.

$20
$
20
/ month


Upgrade to Plus
Everything in Free, and:
Advanced intelligence for complex work
Higher quality image creation
Work agent to act across apps and files
Codex to automate coding
Expanded memory and 20 GB of storage
Email and calendar connections
Larger projects to organize your work
Tools for personal finance and data analysis
No ads

3.cursor:
Hobby
Free

Includes:

✓
No credit card required
✓
Limited Agent requests
✓
Access to Composer
Try Cursor
Pro
$20
 / mo.

Everything in Hobby, plus:

✓
Extended limits on Agent
✓
Generous limits for Grok
✓
Access to frontier models
✓
Grok Bot access
✓
MCPs, skills, and hooks
✓
Cloud agents
✓
Bugbot on usage-based billing
Get Pro
Pro+
$60
 / mo.

Everything in Pro, plus:

✓
3x Pro limits on Agent
✓
Generous limits for Grok
✓
Access to frontier models
✓
Higher Grok Bot usage limits
✓
MCPs, skills, and hooks
✓
Cloud agents
✓
Bugbot on usage-based billing
Get Pro+
Ultra
$200
 / mo.

Everything in Pro, plus:

✓
20x Pro limits on Agent
✓
Generous limits for Grok
✓
Access to frontier models
✓
Highest Grok Bot usage limits
✓
MCPs, skills, and hooks
✓
Cloud agents
✓
Bugbot on usage-based billing
✓

4.glm:
Lite
日常使用

¥
94.4
/月
¥
118
/月
立即订阅
每周 10,000 积分

逐步开放最新旗舰模型及功能

支持 ZCode、Claude Code 等 20+ 编程工具

Pro
最受欢迎
高频使用

¥
430.4
/月
¥
538
/月
立即订阅
6倍 Lite 用量额度

Lite 全部权益

优先体验最新旗舰模型及功能

覆盖多款精选 MCP 工具

更快生成速度

Max
深度使用

¥
862.4
/月
¥
1078
/月
立即订阅
14倍 Lite 用量额度

Pro 全部权益

首发接入最新旗舰模型及功能

高峰期专属资源优先保障

5.deepseek:
Model Details
MODEL	deepseek-v4-flash	deepseek-v4-pro	deepseek-v4-flash-vision-exp
BASE URL (OpenAI Format)	https://api.deepseek.com
BASE URL (Anthropic Format)	https://api.deepseek.com/anthropic
MODEL VERSION	DeepSeek-V4-Flash-0731	DeepSeek-V4-Pro-0813	DeepSeek-V4-Flash-Vision-Exp
THINKING MODE	Supports both non-thinking and thinking (default) modes
See Thinking Mode for how to switch
CONTEXT LENGTH	1M
MAX OUTPUT	MAXIMUM: 384K
FEATURES	Json Output	✓	✓	✓
Tool Calls	✓	✓	✓
Responses API	✓	✓	✓
Anthropic API	✓	✓	✓
Chat Prefix Completion（Beta）	✓	✓	✓
FIM Completion（Beta）	Non-thinking mode only	Non-thinking mode only	Not supported
PRICING(1)(2)	1M INPUT TOKENS
(CACHE HIT)	OFF-PEAK	$0.007	$0.022	$0.007
PEAK	$0.014	$0.044	$0.014
1M INPUT TOKENS
(CACHE MISS)	OFF-PEAK	$0.22	$0.66	$0.22
PEAK	$0.44	$1.32	$0.44
1M OUTPUT TOKENS	OFF-PEAK	$0.66	$1.98	$0.66
PEAK	$1.32	$3.96	$1.32
Concurrency Limit(3)	2500	500	2500

6.code buddy:
Free
$0
/mo
Start for Free

100 credits/month

Daily active reward: 30 credits/day

Auto model routing

5,000 code completions

3 automated tasks

Experts, skills & connectors

Cross-file understanding

Generate code from comments
7-day free trial · 500 base credits included
Pro
$10
/mo
20/mo
Start 7-day free trial

1,000 base credits/month

1,000 bonus credits/month

Daily active reward: 50 credits/day

Access to all models

Unlimited code completions

15 automated tasks

Experts, skills & connectors

Cross-file understanding

Generate code from comments

国内版：

体验版

限时免费
00/月

免费试用

每月 500 积分

Auto模型调度（限免全模型）

5000次代码实时补全（限免无限次）

3个自动任务（限免99个）

创建5个项目

每项目3人协作（限免5人）

5GB资料库容量
部分功能限免生效中

标准版

￥ 70
/月
99/月

立即购买

每月基础2000积分

每月赠送2000积分

全部模型可选

无限次代码实时补全

15个自动任务（限免99个）

创建10个项目

每项目5人协作

10GB资料库容量

7.trae
免费 Free
 
¥
0
每月 500 积分
所有功能均可免费使用
支持 2 个云端任务同时执行

免费使用
会员 Lite
仅TraeWork专属使用
首月优惠
低至
¥
29.9
/月
¥49
包含免费版功能与积分，以及
2,000 Work 专属积分/月
会员签到多得 1550 积分
Doubao-Seed模型享2.5折
高峰期优先响应
2个云端任务同时执行

立即升级
会员 Pro
 
首月优惠
低至
¥
69
/月
¥99
包含免费版功能与积分，以及
4,000 积分/月
会员签到多得 1550 积分
Doubao-Seed模型享2.5折
高峰期优先响应
10个云端任务同时执行

立即升级
会员 Pro+
 
低至
¥
219
/月
¥239
包含免费版功能与积分，以及
12,000 积分/月
会员签到多得 1550 积分
Doubao-Seed模型享2.5折
高峰期优先响应
10个云端任务同时执行

立即升级
会员 Ultra
 
低至
¥
629
/月
¥699
包含免费版功能与积分，以及
40,000 积分/月
会员签到多得 1550 积分
Doubao-Seed模型享2.5折
高峰期优先响应
新模型优先使用
20个云端任务同时执行

8.workbuddy:
