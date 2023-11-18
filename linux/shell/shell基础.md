# 一、基础知识点

## 1.配置文件

### 配置文件加载顺序

```shell
#先执行
/etc/profile
#再依次执行（只会执行按顺序找到的第一个文件，同时存在时后面的不会执行）
~/.bash_profile
~/.bash_login
~/.profile
```

### 指定别名

```shell
#指定别名
alias cp='cp -i'
alias mv='mv -i'
#列出已有别名
alias
#取消别名
unalias cmd_name
```

### 环境变量

```shell
#添加PATH
PATH=newpathdirectory:${PATH}
```

## 2.帮助手册

### man/info/help

```shell
# man section_num command
man 5 ls

       1   Executable programs or shell commands
       2   System calls (functions provided by the kernel)
       3   Library calls (functions within program libraries)
       4   Special files (usually found in /dev)
       5   File formats and conventions eg /etc/passwd
       6   Games
       7   Miscellaneous (including macro packages and conventions), e.g. man(7), groff(7)
       8   System administration commands (usually only for root)
       9   Kernel routines [Non standard]

#编程语法、内建命令
help while
#info
info ls
```

## 3. shell执行

### bash/sh/source/.

source和. 点号执行：是在当前shell进程执行

bash、sh：在当前shell下创建子shell执行

脚本赋予执行权限后，可以直接执行 =>也是创建子shell执行，（如果有定义，会使用指定的shell程序来执行，如#!/bin/bash）

使用export导出变量，能够传递给子shell使用



# 二、文件和目录

## 1.常用命令

```shell
#展示类型提示信息
ls -F
#时间倒序
ls -lrt
#显示逻辑上的路径，包含符号链接
pwd -L
#显示物理上的路径
pwd -P
#
cd -P
cd -L
cd
cd -

#basename/dirname  获取文件名/目录
[dzzdsj@localhost shell]$ basename /home/dzzdsj/test/shell/test.sh
test.sh
#还能去除指定的文件名后缀
[dzzdsj@localhost shell]$ basename /home/dzzdsj/test/shell/test.sh .sh
test
[dzzdsj@localhost shell]$ dirname /home/dzzdsj/test/shell/test.sh
/home/dzzdsj/test/shell

#显示目录结构（需要另行安装）
tree

#cat
cat -n xxx.sh #打印行号
cat -b xxx.sh #行号不统计空行
#more less
more xxx.sh (支持空格翻页)
less xxx.sh (支持pageup/pagedown/上下方向键)
#head tail
head -n xxx #行数
tail -n xxx
head -c xxx #字节数
tail -c xxx
#wc 统计行数、字数、字节数
wc -l 
wc -w
wc -c

#touch 更新文件访问时间/创建文件
-t -d #指定时间
-a #访问时间
-m #修改时间
#
mkdir -p -v

#符号链接 -s建符号链接（软链接）
ln -s source linkfile

#cp
-L, --dereference            always follow symbolic links in SOURCE 复制符号链接所指向的文件
-P, --no-dereference       never follow symbolic links in SOURCE （默认）只复制符号链接，不复制指向的文件

#chmod 权限设置
Each MODE is of the form '[ugoa]*([-+=]([rwxXst]*|[ugo]))+|[-+=][0-7]+'
#chown 属组
chown owner:owner_group filename
-R

#权限位s ，使得命令的执行者能够获得文件owner或groupowner的权限
[root@localhost ~]# ls -l /bin/passwd
-rwsr-xr-x. 1 root root 27856 Apr  1  2020 /bin/passwd
#黏着位（只对目录生效）只有root、file_owner、dir_owner才能删除文件（用于共享目录，ftp目录等）
[dzzdsj@localhost shell]$ mkdir tmp
[dzzdsj@localhost shell]$ ll
total 4
-rwxrw-r--. 1 dzzdsj dzzdsj 26 Mar  7 23:45 test.sh
drwxrwxr-x. 2 dzzdsj dzzdsj  6 Mar  8 21:14 tmp
[dzzdsj@localhost shell]$ chmod o+t tmp/
[dzzdsj@localhost shell]$ ll
total 4
-rwxrw-r--. 1 dzzdsj dzzdsj 26 Mar  7 23:45 test.sh
drwxrwxr-t. 2 dzzdsj dzzdsj  6 Mar  8 21:14 tmp
#可以使用额外的八进制数（在最前面）指定SUID/SGID/黏着位 （4代表SUID，2代表SGID，1代表黏着位）
[dzzdsj@localhost shell]$ chmod o-t tmp
[dzzdsj@localhost shell]$ ll
total 4
-rwxrw-r--. 1 dzzdsj dzzdsj 26 Mar  7 23:45 test.sh
drwxrwxr-x. 2 dzzdsj dzzdsj  6 Mar  8 21:14 tmp
[dzzdsj@localhost shell]$ chmod 1755 tmp
[dzzdsj@localhost shell]$ ll
total 4
-rwxrw-r--. 1 dzzdsj dzzdsj 26 Mar  7 23:45 test.sh
drwxr-xr-t. 2 dzzdsj dzzdsj  6 Mar  8 21:14 tmp


```

# 三、输入、输出、重定向、管道

## 1.常用命令

```shell
#
set -o noclobber #打开选项，不覆盖已有文件，如有会报错，防止意外覆盖文件内容
set +o noclobber
echo  xx >| xxxfile # >| 可以忽略noclobber的保护

#
0 标准输入
1 标准输出
2 错误输出
>  输出重定向 
>>  输出重定向
< 输入重定向
#错误输出流重定向到标准输出
2>&1
/dev/null

#语句块 多个命令需要用;分割 花括号要带空格，不能和命令紧挨，且最后一个命令需要带空格
{ cmd1;cmd2;..cmdN; } >outputfile  
# 开启一个子shell执行命令
(cmd1;cmd2;..cmdN)

#here document
command << delimiter
  something
delimiter

#usage 
cat <<EOF
echo "balabala"
EOF



```

## 2. 文件描述符

```shell
#通过文件描述符可以把一个数字和文件关联起来，使用这个数字来对文件进行读写()
exec fd >outputfile  #绑定文件描述符和文件（作为输出）
exec fd >>outputfile  #绑定文件描述符和文件（不覆盖）
exec fd <inputfile  #绑定文件描述符和文件(作为输入)
exec fd <>file #作为输入输出
exec 3>xxxfile  #0,1,2已被占用
exec fd2>&fd1 #文件描述符间可以关联
# 文件描述符的使用
command > &fd 
echo "xxx" > &3
#关闭fd
exec fd>&-
exec 3>&-  


```









