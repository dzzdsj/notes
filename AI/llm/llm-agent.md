## claude code
### setup
需要开启tun模式
```shell
curl -fsSL https://claude.ai/install.sh | bash
```
 如果你需要同时访问多个项目目录，用 /add-dir 命令把另一个目录加进来：

  /add-dir /另一个/项目目录
### usage
进入一个项目文件夹后，执行 /init 命令，它就会扫描整个项目文件夹，生成一个 CLAUDE.md 文件


## codex
```
curl -fsSL https://chatgpt.com/codex/install.sh | sh
```

## cc switch
website：
https://ccswitch.io/zh/
doc：
https://ccswitch.io/zh/docs?section=getting-started&item=quickstart

Claude Code 首次安装提示
如果 Claude Code 首次启动时提示需要登录或显示初始化引导，请在 CC Switch 中开启「跳过 Claude Code 初次安装确认」选项：

打开 CC Switch「设置 → 应用配置」，找到 Claude Code 一块
开启「跳过 Claude Code 初次安装确认」开关
重新启动 Claude Code
<!-- TODO(v4 截图): 设置 → 应用配置 → Claude Code 里的「跳过 Claude Code 初次安装确认」开关 -->
⚠️ 注意：此选项会在 ~/.claude.json 中写入 hasCompletedOnboarding: true，跳过官方的初次安装确认流程。

