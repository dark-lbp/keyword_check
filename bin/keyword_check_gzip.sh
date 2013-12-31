#! /bin/bash
# SCRIPT: keyword_check_gzip.sh
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

# 定义gzip压缩包检测函数
check_gzip_file()
{
	K=$(zgrep -no $KEY_WORD ${1}) 
		if [[ $? -eq 0 ]]
			then
			echo -e "file name:${1}\n"  >> "$FILES_GZIP_OUT.$$"
			echo -e $K|sed -e 's/\ /\n/g'  >> "$FILES_GZIP_OUT.$$"
			echo -e "\n\n"  >> "$FILES_GZIP_OUT.$$"
		fi
}
####################### 主程序 ########################
trap 'trap_exit; exit 2' 1 2 3 15
#
IFS=$'\n';cat ${1} | while read GZIP_FILE
do
#（后台执行主程序命令）
check_gzip_file ${GZIP_FILE} 
#减少任务队列
sed -i 1d ${1}
done

#（等待子进程结果返回值）
wait
 
exit


