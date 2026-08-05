
## 环境配置
```shell
ipaddr='192.168.50.231'
cp /etc/sysconfig/network-scripts/ifcfg-ens33 /etc/sysconfig/network-scripts/ifcfg-ens33.bak
sed -i "s/192.168.50.99/${ipaddr}/g" /etc/sysconfig/network-scripts/ifcfg-ens33
systemctl restart network
```
```shell
sudo mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
sudo curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
#sudo curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.tuna.tsinghua.edu.cn/repo/Centos-7.repo
sudo yum clean all
sudo yum makecache

```