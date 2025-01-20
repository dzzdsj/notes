### 安装

```
yum install vsftpd
systemctl start vsftpd
systemctl status vsftpd
```

### 简易自动化传输

```shell
ftp dev-local <<EOF
#用户名密码
user yourusername password yourpassword
pwd
mkdir yourdir
cd yourdir
lcd yourlocaldir
bin     #支持二进制方式传输
prompt  #关闭交互，否则多文件会提示选择
mput *
mget *
EOF
```

### ssl支持配置

```
1、检查 vsftpd 是否支持 SSL 模块
ldd $(which vsftpd) | grep ssl
2、创建证书
(1) 进入证书存放的位置
[root@centos7 ~]# cd /etc/pki/tls/certs
(2) 生成密钥文件
[root@centos7 certs]# make vsftpd.pem
(3) 复制证书到vsftpd目录
[root@centos7 certs]# cp -a vsftpd.pem /etc/vsftpd
(4) 查看一下被复制到了/etc/vsftpd证书的详细资料
[root@centos7 certs]# ls -l /etc/vsftpd/vsftpd.pem
3、为vsftpd配置证书
(1) 打开vsftpd配置文件
[root@centos7 certs]# vi /etc/vsftpd/vsftpd.conf
(2) 在文件后面加入以下配置
ssl_enable=YES
allow_anon_ssl=YES
force_anon_data_ssl=YES
force_anon_logins_ssl=YES
force_local_data_ssl=YES
force_local_logins_ssl=YES
ssl_tlsv1=YES
rsa_cert_file=/etc/vsftpd/vsftpd.pem
3、重启vsftpd服务
[root@centos7 certs]# systemctl restart vsftpd.service
```

