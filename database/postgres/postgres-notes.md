
## 安装
### rpm方式
dnf install  postgresql-server.x86_64
/usr/bin/postgresql-setup --initdb
systemctl start postgresql

## 常用命令
sudo -u postgres psql
psql -d mydb -U myuser
psql -h 127.0.0.1 -p 5432 -U myuser mydb

postgres=# \conninfo
You are connected to database "postgres" as user "postgres" via socket in "/var/run/postgresql" at port "5432".