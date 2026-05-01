
### Scoop
```
# 安装 Scoop
# 设置 PowerShell 执行策略
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
# 下载安装脚本
irm get.scoop.sh -outfile 'install.ps1'
# 执行安装, --ScoopDir 参数指定 Scoop 安装路径
.\install.ps1 -ScoopDir 'D:\Scoop'

# 卸载 Scoop
scoop uninstall scoop

# 安装某个软件包
scoop install <软件包名>
```