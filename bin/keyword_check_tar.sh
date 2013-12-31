#! /bin/bash
# SCRIPT: keyword_check_tar.sh
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

# 定义tar压缩包检测函数
check_tar_file()
{

K=$(tar -axf ${1} -O |grep -no $KEY_WORD)
	     if [[ $? -eq 0 ]]
		then
		     echo -e "file name:${1}\n" >> "$FILES_TAR_OUT.$$"
		     tar -atf ${1} | grep -v '/$' | while read -r FILE
		     do
			K1=$(tar -axf ${1} $FILE -O | grep -no $KEY_WORD)
			if [[ $? -eq 0 ]]
			then
			echo -e "in file:$FILE" >> "$FILES_TAR_OUT.$$"
			echo -e $K1|sed -e 's/\ /\n/g' >> "$FILES_TAR_OUT.$$"
			echo -e "\n\n" >> "$FILES_TAR_OUT.$$"
			fi
		     done
	     fi
}

####################### 主程序 ########################
trap 'trap_exit; exit 2' 1 2 3 15

IFS=$'\n';cat ${1} | while read TAR_FILE
do
#（后台执行主程序命令）
check_tar_file ${TAR_FILE}
#减少任务队列，该操作严重影响性能
sed -i 1d ${1}
done
#（等待子进程结果返回值）

wait

exit
