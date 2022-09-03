#!/bin/bash
SQL_FILE=$1
USERNAME=$2
PASSWORD=$3
OUTPUT_FILE=explain_plan.out

#
init_thread_pool(){
    FIFO_FILE=thread_pool.fifo
    THREAD_NUM=5
    if [ -e $FIFO_FILE ];then
        rm $FIFO_FILE
    fi
    #建立管道文件
    mkfifo -m 644 $FIFO_FILE
    #绑定文件描述符
    exec 8<>$FIFO_FILE
    #写入指定数量空行，配合read函数阻塞特性，实现进程数控制
    for((i=1;i<$THREAD_NUM;i++))
    do
        echo "1";
    done >&8

}


#使用explain plan for 分析执行计划
explain_sql(){
    SQL_TEXT=$(echo $*|sed 's/;//g')
    echo "SQL_TEXT==${SQL_TEXT}"
    ${ORACLE_HOME}/bin/sqlplus  -S  ${USERNAME}/${PASSWORD}  <<EOF >> ${OUTPUT_FILE} 2>&1 
        explain plan for 
        ${SQL_TEXT};
        SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
EOF
}

###### main

if [ ! "$ORACLE_HOME" ];then
    echo "ORACLE_HOME is undefined!"
fi
echo "SQL_FILE:${SQL_FILE}"
echo "OUTPUT_FILE:${OUTPUT_FILE}"
echo "clear output file"
if [ -f "${OUTPUT_FILE}" ];then
    >${OUTPUT_FILE}
fi
echo "start explain plan"


while read LINE 
do
    echo "explain_sql ${LINE}"
    echo "###############################################################################" >>${OUTPUT_FILE}
    echo "explain plan for : ${LINE}" >>${OUTPUT_FILE}
    explain_sql "${LINE}"
done <${SQL_FILE}

wait

echo "explain plan completed!"
