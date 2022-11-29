

## 工具安装

```
#autoscan命令未安装
yum install -y autoconf
#aclocal命令未安装
yum install -y automake  
```

## 操作步骤

### 编辑源代码

```
vi helloworld.c
```

```
#include <stdio.h>
int main(int argc, char** argv){
     printf("%s", "Hello, Linux World!\n");
     return 0;
}
```

### 生成configure.scan

```
autoscan
```
```

[dzzdsj@dev c_test]$ ls
autoscan.log  configure.scan  helloworld.c
```

编辑configure.in或 configure.ac

https://www.gnu.org/software/automake/manual/automake.html#Modernize-AM_005fINIT_005fAUTOMAKE-invocation

```
mv configure.scan configure.ac
```
```
[dzzdsj@dev c_test]$ cat configure.in
#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT([FULL-PACKAGE-NAME], [VERSION], [BUG-REPORT-ADDRESS])
AC_CONFIG_SRCDIR([helloworld.c])
AC_CONFIG_HEADERS([config.h])

# Checks for programs.
AC_PROG_CC

# Checks for libraries.

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.

AC_OUTPUT
```

```
vi  configure.ac
修改 AC_INIT(helloworld.c)
加入AM_INIT_AUTOMAKE(helloworld, 1.0)
修改 AC_OUTPUT(Makefile)
```

```
[dzzdsj@dev c_test]$ cat configure.in
#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])
AC_INIT(helloworld.c)
AM_INIT_AUTOMAKE(helloworld)
AC_CONFIG_SRCDIR([helloworld.c])
AC_CONFIG_HEADERS([config.h])

# Checks for programs.
AC_PROG_CC

# Checks for libraries.

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.

# Checks for library functions.

AC_OUTPUT(Makefile)
```

### 执行 aclocal 生成aclocal.m4

```
aclocal

[dzzdsj@dev c_test]$ ls
aclocal.m4  autom4te.cache  autoscan.log  configure.ac  helloworld.c

```

### 执行 autoconf 生成autoconf

```
autoconf

[dzzdsj@dev c_test]$ ls
aclocal.m4  autom4te.cache  autoscan.log  configure  configure.ac  helloworld.c

```

### 新建Makefile.am文件

```
vi Makefile.am

AUTOMAKE_OPTIONS=foreign
bin_PROGRAMS=helloworld
helloworld_SOURCES=helloworld.c
```

### autoheader

```
解决configure.ac:8: error: required file 'config.h.in' not found
```

### automake --add-missing

### ./configure

### make





## 命令详解
### autoscan


```
autoscan扫描源代码目录生成configure.scan,configure.scan包含了系统配置的基本选项,里面都是一些宏定义.我们需要将它改名为configure.in或者configure.ac,
configure.in文件的内容是一些宏,这些宏经过autoconf处理后会变成检查系统特性.环境变量.软件必须的参数的shell脚本.configure.in文件中的宏的顺序并没有规定,但是你必须在所有宏的最前面和最后面分别加上AC_INIT宏和AC_OUTPUT宏
```

### aclocal

```
aclocal是一个perl脚本程序.aclocal根据configure.in文件的内容自动生成aclocal.m4文件
```

### autoconf

```
autoconf是用来产生configure文件的 .configure是一个脚本,它能设置源程序来适应各种不同的操作系统平台,并且根据不同的 系统来产生合适的 Makefile,从而可以使你的源代码能在不同的操作系统平台上被编译出来
```

