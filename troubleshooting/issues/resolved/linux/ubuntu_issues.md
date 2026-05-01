1.从 macOS 远程登录 Ubuntu 桌面 24.04黑屏
https://www.reddit.com/r/Ubuntu/comments/1fqmicf/remote_login_to_ubuntu_desktop_2404_from_macos/?tl=zh-hans
打开 Windows (RDP) 应用
右键点击无法连接的连接，选择导出。
在文本编辑器中打开导出的 .rdp 文件。
找到这一行：use redirection server name:i:0
并将其更改为：use redirection server name:i:1
保存文件。
在 Windows (RDP) 应用中，转到连接 → 从 RDP 文件导入…，然后导入修改后的文件

2.vmware workstation 17.5.2安装报错
https://blog.csdn.net/qq_40829735/article/details/141235005

错误1
使用以下命令可以查看安装失败的模块
sudo /etc/init.d/vmware start 

输出如下， 多数情况下都是这两个模块失败了

Starting VMware services:
   Virtual machine monitor                                            failed
   Virtual machine communication interface                             done
   VM communication interface socket family                            done
   Virtual ethernet                                                   failed
   VMware Authentication Daemon                                        done

使用以下命令， 查看安装版本

vmware-installer -l

Product Name         Product Version     
==================== ====================
vmware-workstation   17.5.2.23775571  

https://github.com/nan0desu/vmware-host-modules

下载对应版本的源码， 手动编译安装， 然后即可成功运行vmware-workstation

cd vmware-host-modules-workstation-17.5.2-k6.9-
sudo make && make install
sudo /etc/init.d/vmware start
