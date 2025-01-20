### dirname

去除最后一个/之后的内容，如果原来不带/，输出.号

```
DIRNAME(1)                                          
NAME
       dirname - strip last component from file name
SYNOPSIS
       dirname [OPTION] NAME...
DESCRIPTION
       Output  each NAME with its last non-slash component and trailing slashes removed; if NAME contains no /'s, out‐put '.' (meaning the current directory).
	  
       -z, --zero
              separate output with NUL rather than newline
       --help display this help and exit
       --version
              output version information and exit

EXAMPLES
       dirname /usr/bin/
              -> "/usr"
       dirname dir1/str dir2/str
              -> "dir1" followed by "dir2"
       dirname stdio.h
              -> "."
```

### basename

从给定的文件名中删除目录和后缀（可选）

```
BASENAME(1) 
NAME
       basename - strip directory and suffix from filenames

SYNOPSIS
       basename NAME [SUFFIX]
       basename OPTION... NAME...

DESCRIPTION
       Print NAME with any leading directory components removed.  If specified, also remove a trailing SUFFIX.

       Mandatory arguments to long options are mandatory for short options too.
	   支持多个参数
       -a, --multiple
              support multiple arguments and treat each as a NAME
       指定后缀
       -s, --suffix=SUFFIX
              remove a trailing SUFFIX
       -z, --zero
              separate output with NUL rather than newline
       --help display this help and exit
       --version
              output version information and exit

EXAMPLES
       basename /usr/bin/sort
              -> "sort"
       basename include/stdio.h .h
              -> "stdio"
       basename -s .h include/stdio.h
              -> "stdio"
       basename -a any/str1 any/str2
              -> "str1" followed by "str2"
```



