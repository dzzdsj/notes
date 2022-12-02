

## adrci清理日志

```
$ adrci
adrci> show home
adrci> set homepath diag/rdbms/orcl/orcl1
adrci> help purge     # 可根据清理多少分钟前的数据，也可以show problem查看日志中错误信息
adrci> purge -age 14400 -type incident #14400的单位是分钟
adrci> purge -age 14400 -type trace

```

## usage

```
Usage: PURGE [-i {<id1> | <id1> <id2>} ] |
               [-problem {<id1> | <id1> <id2>} ] |
               [[-age <mins>] |
                [-size <bytes>] |
                [-type {ALERT|INCIDENT|TRACE|CDUMP|HM|UTSCDMP|LOG} ]]

  Purpose: Purge the diagnostic data in the current ADR home. If no
           option is specified, the default purging policy will be used.

  Options:
    [-i id1 | id1 id2]: Purge a single specified incident, or a range
    of incidents.

    [-problem id1 | id1 id2]: Purge a single specified problem, or a range
    of problems.

    [-age <mins>]: Purge diagnostic data older than <mins> from the
    ADR home, if the data is purgable.

    [-size <bytes>]: Purge diagnostic data from the ADR home until the size
    of the home reaches <bytes> bytes.

    [-type ALERT|INCIDENT|TRACE|CDUMP|HM|UTSCDMP|LOG]: Purge a specific
    type of data.

  Notes:
    When purging by size, only INCIDENT, TRACE, CDUMP and UTSCDMP data
    is considered.

    Some data can not be purged (such as incidents in the 'tracked' state),
    which means that the specified target size may not be reached in all cases.

  Examples:
    purge
    purge -i 123 456
    purge -age 60 -type incident
    purge -size 10000000

```



## 报错处理

### DIA-48448: This command does not support multiple ADR homes

```
adrci> show control
DIA-48448: This command does not support multiple ADR homes

adrci> show homepath
ADR Homes:
diag/rdbms/dzzdsjdb/dzzdsjdb
diag/tnslsnr/dev/listener

adrci> set homepath diag/rdbms/dzzdsjdb/dzzdsjdb
```

## incident日志

每当一个错误发生的时候，oracle会创建一个incident，并且分配一个INCIDENT_ID号，同时在ADR HOME的INCIDENT目录中创建相应的INCIDENT 目录，每个错误号一个INCIDENT目录，目录被命名为incdir_<INCIDENT_ID>。在incident 目录下含有相应的DUMP文件。

