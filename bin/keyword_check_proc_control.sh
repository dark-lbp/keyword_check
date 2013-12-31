#! /bin/bash
# SCRIPT: keyword_check_proc_control.sh
# AUTHOR: DARK_LBP
# MAIL: jtrkid@gmail.com
# DATE: 2012/05/02
# REV: 1.2
# For FUN,^^
# PURPOSE:
# 根据关键字列表，检查系统中匹配关键字的文件列表，并进行输出
# Use Age:
# ./keyword_check_main.sh



####################定义部分################

####################### 函数定义 ########################
function trap_exit
{
kill -9 0
}


####################### 主程序 ########################

trap 'trap_exit; exit 2' 1 2 3 15


#执行GZIP包检查
ls "$GZIP_PROC"* | while read GZIP_FILE_LIST
do
`$CMD_GZIP $GZIP_FILE_LIST` 2>/dev/null &
echo -e "生成任务$GZIP_FILE_LIST\n"
done

wait


#执行TAR包检查
ls "$TAR_PROC"* | while read TAR_FILE_LIST
do
`$CMD_TAR $TAR_FILE_LIST` 2>/dev/null &
echo -e "生成任务$TAR_FILE_LIST\n"
done
wait

#执行普通文件检查
ls "$OTHER_PROC"* | while read OTHER_FILE_LIST
do
`$CMD_OTHER $OTHER_FILE_LIST` 2>/dev/null &
echo -e "生成任务$OTHER_FILE_LIST\n"
done

wait

#合并输出文件
#cat $FILES_GZIP_OUT.* > $FILES_GZIP_OUT
#cat $FILES_TAR_OUT.* > $FILES_TAR_OUT
#cat $FILES_OTHER_OUT.* > $FILES_OTHER_OUT


echo -e "ALL JOB DONE"

exit

