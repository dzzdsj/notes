
## uv
```
curl -Ls https://astral.sh/uv/install.sh | sh
➜  ~ which uv
/Users/dzzdsj/.local/bin/uv

uv init my_project
cd my_project


```
```
# logs
curl -Ls https://astral.sh/uv/install.sh |sh
downloading uv 0.11.9 aarch64-apple-darwin
installing to /Users/dzzdsj/.local/bin
  uv
  uvx
everything's installed!

To add $HOME/.local/bin to your PATH, either restart your shell or run:

    source $HOME/.local/bin/env (sh, bash, zsh)
    source $HOME/.local/bin/env.fish (fish)
```

## 版本管理-pyenv
```shell
brew install pyenv
pyenv --version
pyenv install --list
pyenv install 3.14.6
# 设置全局版本/本地版本
pyenv global 3.14.6 /pyenv local 3.14.6
# 查看已安装的版本
pyenv versions
cd /path/to/project
pyenv local 3.14.6
会在项目目录下创建 .python-version 文件，并写入版本号
# 删除版本
pyenv uninstall 3.14.6
```
## 虚拟环境-venv
```shell
cd my-project
# 创建虚拟环境
python -m venv .venv
# 激活虚拟环境
source .venv/bin/activate
# 退出虚拟环境
deactivate
# 删除虚拟环境
rm -rf .venv
# 
pip install pandas requests
pip install -r requirements.txt
pip freeze > requirements.txt
```