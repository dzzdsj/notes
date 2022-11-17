#/bin/bash
#if [ $# -ne 2 ]
#then
#echo " Usage : $0 table_name flat_file_name"
#exit
#fi

if [[ $# -ne 1 ]]
then
echo " Usage : $0 table_name "
exit
fi

#assigning envir. variable to unix variables

table_name=$1
flat_file=$2
DELEMITER='\t'
ORA_USER=dzzdsj
ORA_USER_PASSWORD=dzzdsj
#creating the control file

echo "LOAD DATA" > ${table_name}.ctl
#echo "INFILE '$flat_file'" >> $table_name.ctl
echo "characterset \"ZHS32GB18030\"" >>${table_name}.ctl
echo "append into table $table_name " >> ${table_name}.ctl
echo "fields terminated by '$DELEMITER'" >> ${table_name}.ctl
echo "trailing nullcols" >>${table_name}.ctl
echo "(" >> ${table_name}.ctl

#describing the table and spooling into file

sqlplus -s ${ORA_USER}/${ORA_USER_PASSWORD} <<EOF
spool ${table_name}.lst
desc ${table_name}
spool off
EOF

# creating suitable file and add the feilds into control file
# cutting the first line (headings)
#cutting the last line
tail -n +3 ${table_name}.lst | head -n -1 >field.txt

# reading file line by line

while read line
do
#cutting the first field
field_name=`echo ${line} | cut -f1 -d' '`
data_type_str=$(echo ${line}|awk '{print $NF}')
#data_type=`echo $data_type_str | cut -f1 -d'('`
if [[ "$data_type_str" = "DATE" ]];then
  #echo "data_type_str=$data_type_str"
  echo "$field_name        DATE \"yyyy-mm-dd hh24:mi:ss\"" >> ${table_name}.ctl
else
  #echo "field_name=$field_name"
  echo "$field_name" >>${table_name}.ctl
fi
done<field.txt

echo ")" >> ${table_name}.ctl

#removing the file
#rm -f field.txt
rm -f ${table_name}.lst
#calling the SQLLOADER

#SQLLDR $CUST_ORA_USER CONTROL=$table_name.ctl ERROR=99999999

#removing the control file
#rm -f $table_name.ctl