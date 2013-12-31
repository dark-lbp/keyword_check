#! /bin/bash
# SCRIPT: keyword_check_main.sh
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
#定义关键字
export KEY_WORD=`cat ../conf/keyword`
#echo $KEY_WORD
#定义并发进程数量
export PARALLEL="4"
#定义临时管道文件名
#export TMPFILE_GZIP=/tmp/"$$"_gzip.fifo
#export TMPFILE_TAR=/tmp/"$$"_tar.fifo
#export TMPFILE_OTHER=/tmp/"$$"_other.fifo
#定义失败标识文件-暂未使用
#export FAILURE_FLAG_GZIP=../log/failure_gzip.log
#export FAILURE_FLAG_TAR=../log/failure_tar.log
#export FAILURE_FLAG_OTHER=../log/failure_other.log
#定义xx文件
export FILES_TMP=../tmp/files_tmp
export FILES_GZIP=../tmp/files_gzip
export FILES_GZIP_OUT=../out/files_gz.out
export FILES_TAR=../tmp/files_tar
export FILES_TAR_OUT=../out/files_tar.out
export FILES_OTHER=../tmp/files_other
export FILES_OTHER_OUT=../out/files_other.out
#定义并发任务临时文件
export GZIP_PROC=../tmp/gzip_proc
export TAR_PROC=../tmp/tar_proc
export OTHER_PROC=../tmp/other_proc



#定义控制文件
export CMD_PROC_CONTROL='./keyword_check_proc_control.sh'
#定义任务文件
export CMD_GZIP='./keyword_check_gzip.sh'
export CMD_TAR='./keyword_check_tar.sh'
export CMD_OTHER='./keyword_check_other.sh'

#清空xx文件
echo -e "是清除扫描结果并，重新扫描？\n"
echo -e "Y=清除并重新扫描，N=不清除并继续扫描，C=取消\n"

read ANSWER

case "$ANSWER" in
	Y)
	rm -rf ../tmp/*
	rm -rf ../out/*
	echo -e "\n\n"  > $FILES_GZIP_OUT
	echo -e "\n\n"  > $FILES_TAR_OUT
	echo -e "\n\n"  > $FILES_OTHER_OUT
	echo -e "\n\n"  > $FILES_TMP
	echo -e "\n\n"  > $FILES_GZIP
	echo -e "\n\n"  > $FILES_TAR
	echo -e "\n\n"  > $FILES_OTHER
#清理失败标识文件
#	rm -f  ${FAILURE_FLAG_GZIP}
#清理失败标识文件
#	rm -f  ${FAILURE_FLAG_OTHER}
#清理失败标识文件
#	rm -f  ${FAILURE_FLAG_TAR}
########################生成检测文件列表#####################
#生成初始全列表
#	IFS=$'\n';find / -type f 2>/dev/null > $FILES_TMP
	IFS=$'\n';find /opt -type f 2>/dev/null > $FILES_TMP
#生成gz文件列表.tgz
	cat $FILES_TMP | grep -E "*[^tar]\.gz$" >$FILES_GZIP
#生成tar类型压缩包列表
	cat $FILES_TMP | grep -E ""*\\.tar\.*"|"*\.tgz$""|grep -v "/var/cache/pacman/pkg" >$FILES_TAR
#生成剩余普通文件的列表
##排除二进制
	cat $FILES_TMP | grep -Ev ""*\.tar\.*"|"*[^tar]\.gz$"|"*\.vdi"|"*\.iso"|"^/sys"|"^/proc"|"^/run""|perl -e 'while(<>){s/\n//;if(!-B){print $_."\n"}}' >$FILES_OTHER
##未排除二进制
#	cat ../tmp/files_tmp | grep -Ev ""*\.tar\.*"|"*[^tar]\.gz$"|"*\.vdi"|"*\.iso"|"^/sys"|"^/proc"|"^/run"" >$FILES_OTHER


echo $FILES_GZIP

if [ -f "$FILES_GZIP" ]; then
    export GZIP_PROC_LINES=`expr $(cat $FILES_GZIP|wc -l) / $PARALLEL`
    echo -e "$GZIP_PROC_LINES \n"
fi
if [ -f "$FILES_TAR" ]; then
    export TAR_PROC_LINES=`expr $(cat $FILES_TAR|wc -l) / $PARALLEL`
    echo -e "$TAR_PROC_LINES \n"
fi
if [ -f "$FILES_OTHER" ]; then
    export OTHER_PROC_LINES=`expr $(cat $FILES_OTHER|wc -l) / $PARALLEL`
    echo -e "$OTHER_PROC_LINES \n"
fi


#根据并发数分割任务列表

	echo -e "GZIP=$GZIP_PROC_LINES\n"
	split -l $GZIP_PROC_LINES $FILES_GZIP $GZIP_PROC
	echo -e "TAR=$TAR_PROC_LINES\n"
	split -l $TAR_PROC_LINES $FILES_TAR $TAR_PROC
	echo -e "OTHER=$OTHER_PROC_LINES\n"
	split -l $OTHER_PROC_LINES $FILES_OTHER $OTHER_PROC
     	;;

	N)
	echo -e "正在继续执行上次的扫描\n"
	;;
	C)
	exit 0
	;;

	*)
	echo -e "输入错误，请重新输入\n"
	echo -e "是清除扫描结果并，重新扫描？\n"
	echo -e "Y=清除并重新扫描，N=不清除并继续扫描，C=取消\n"
	read ANSWER
esac



####################### 函数定义 ########################

####################### 主程序 ########################


`$CMD_PROC_CONTROL` 2>/dev/null &

wait

echo -e "ALL JOB DONE"

exit




