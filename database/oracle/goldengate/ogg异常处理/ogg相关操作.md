# OGG相关操作

## 跳过当前事务

```shell
#ggsci查询trail、rba值
GGSCI (dev1) 1> dblogin userid ogg,password ogg
Successfully logged into database.

GGSCI (dev1 as ogg@orcl) 2> info all

Program     Status      Group       Lag at Chkpt  Time Since Chkpt

MANAGER     RUNNING
EXTRACT     RUNNING     EFZOG001    00:00:00      00:00:05
EXTRACT     RUNNING     PFZOG001    00:00:00      00:00:07
REPLICAT    RUNNING     RFZOG201    00:00:00      00:00:02


GGSCI (dev1 as ogg@orcl) 3> info rfzog201,detail

REPLICAT   RFZOG201  Last Started 2021-05-19 11:28   Status RUNNING
INTEGRATED
Checkpoint Lag       00:00:00 (updated 00:00:07 ago)
Process ID           30815
Log Read Checkpoint  File /ogg/dirdat/ra000000001
                     2021-07-13 17:31:59.568260  RBA 519123

#使用logdump查询下一rba值
logdump

Oracle GoldenGate Log File Dump Utility for Oracle
Version 19.1.0.0.4 OGGCORE_19.1.0.0.0_PLATFORMS_191017.1054
Copyright (C) 1995, 2019, Oracle and/or its affiliates. All rights reserved.

Logdump 1 >open /ogg/dirdat/ra000000001
Current LogTrail is /ogg/dirdat/ra000000001
Logdump 2 >pos 519123
Reading forward from RBA 519123
Logdump 3 >detail data
Logdump 4 >ggstoken detail
Logdump 5 >ghdr on
Logdump 6 >n
Logdump 7 >sfet
Logdump 8 >n
___________________________________________________________________
Hdr-Ind    :     E  (x45)     Partition  :     L  (x4c)
UndoFlag   :     .  (x00)     BeforeAfter:     A  (x41)
RecLength  :   952  (x03b8)   IO Time    : 2021/07/13 17:35:19.000.275
IOType     :   135  (x87)     OrigNode   :   255  (xff)
TransInd   :     .  (x03)     FormatType :     R  (x52)
SyskeyLen  :     0  (x00)     Incomplete :     .  (x00)
AuditRBA   :         59       AuditPos   : 118633340
Continued  :     N  (x00)     RecCount   :     1  (x01)

2021/07/13 17:35:19.000.275 GGSUnifiedPKUpdate   Len   952 RBA 521250
#ggsci跳过rba
ggsci>alter replicat rshog201,extseqno 1(trail文件名的数字序号部分),extrba 521250(下一事务rba地址)
```

## 表结构变更（确认同步是否完成）

```shell
#先停抽取进程，查看seqno和rba
GGSCI (dev1 as ogg@orcl) 19> stop EFZOG001
GGSCI (dev1 as ogg@orcl) 19> info efzog001,detail

EXTRACT    EFZOG001  Last Started 2021-05-13 20:02   Status STOPPED
Checkpoint Lag       00:00:00 (updated 00:00:15 ago)
Log Read Checkpoint  Oracle Integrated Redo Logs
                     2021-07-14 14:10:17
                     SCN 0.2623161 (2623161)

  Target Extract Trails:

  Trail Name                                       Seqno        RBA     Max MB Trail Type

  ./dirdat/la                                          0    4562355        500 EXTTRAIL 
  
  #查看投递进程的读检查点和写检查点（读检查点需要和抽取进程一致，写检查点需要和目标端的复制进程一致）
  GGSCI (dev1 as ogg@orcl) 20> info PFZOG001,showch

EXTRACT    PFZOG001  Last Started 2021-07-11 18:53   Status RUNNING
Checkpoint Lag       00:00:00 (updated 00:00:00 ago)
Process ID           13873
Log Read Checkpoint  File /ogg/dirdat/la000000000
                     2021-07-14 14:09:52.000000  RBA 4562355


Current Checkpoint Detail:

Read Checkpoint #1

  GGS Log Trail

  Startup Checkpoint (starting position in the data source):
    Sequence #: 0
    RBA: 3495622
    Timestamp: 2021-05-23 12:23:52.000000
    Extract Trail: /ogg/dirdat/la
    Seqno Length: 9

  Current Checkpoint (position of last record read in the data source):
    Sequence #: 0
    RBA: 4562355
    Timestamp: 2021-07-14 14:09:52.000000
    Extract Trail: /ogg/dirdat/la
    Seqno Length: 9

Write Checkpoint #1

  GGS Log Trail

  Current Checkpoint (current write position):
    Sequence #: 1
    RBA: 1090657
    Timestamp: 2021-07-14 14:11:44.454592
    Extract Trail: ./dirdat/ra
    Seqno Length: 9
    Flip Seqno Length: No
    Trail Type: RMTTRAIL

Header:
  Version = 2
  Record Source = A
  Type = 1
  # Input Checkpoints = 1
  # Output Checkpoints = 1

Configuration:
  Data Source = 0
  Transaction Integrity = 1
  Task Type = 0

Status:
  Start Time = 2021-07-11 18:53:18
  Last Update Time = 2021-07-14 14:11:44
  Stop Status = A
  Last Result = 400
#等待检查点一致后关闭投递进程
#至目标端查看复制进程
GGSCI (dev2 as ogg@orcl) 9> info rshog001,showch

REPLICAT   RSHOG001  Last Started 2021-05-13 20:01   Status RUNNING
INTEGRATED
Checkpoint Lag       00:00:00 (updated 00:00:05 ago)
Process ID           40358
Log Read Checkpoint  File /ogg/dirdat/ra000000001
                     2021-07-14 14:09:52.001669  RBA 1090657


Current Checkpoint Detail:

Read Checkpoint #1

  GGS Log Trail

  Startup Checkpoint (starting position in the data source):
    Sequence #: 0
    RBA: 0
    Timestamp: Not Available
    Extract Trail: /ogg/dirdat/ra
    Seqno Length: 9

  Current Checkpoint (position of last record read in the data source):
    Sequence #: 1
    RBA: 1090657
    Timestamp: 2021-07-14 14:09:52.001669
    Extract Trail: /ogg/dirdat/ra
    Seqno Length: 9

Header:
  Version = 2
  Record Source = A
  Type = 14
  # Input Checkpoints = 1
  # Output Checkpoints = 0

Configuration:
  Data Source = 0
  Transaction Integrity = -1
  Task Type = 0

Database Checkpoint:
  Checkpoint table = ogg.ogg_checkpoint
  Key = 1926598335 (0x72d58ebf)
  Create Time = 2021-05-13 20:01:50

Status:
  Start Time = 2021-05-13 20:01:58
  Last Update Time = 2021-07-14 14:13:33
  Stop Status = A
  Last Result = 400

#等待检查点一致后关闭复制进程  
```





