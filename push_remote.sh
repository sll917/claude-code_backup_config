#!/bin/bash
# **********************************************************
# * Author : liangliangSu
# * Email : sll917@hotmail.com
# * Create time : 2022-11-09 19:14
# * Filename : push_gitee.sh
# **********************************************************
#提交文件
git add .
read -p "Please briefly enter the Update instructions: " text
git commit -m "Update time:`date "+%Y-%m-%d %H:%M"`,Update info:$text"

echo -e "\033[32m start push code to server!\033[0m"
sleep 1

#推送到 gitee remote
# git push -f -u gitee master
# if [ $? = 0 ];then
# 	echo -e "\e[1;32m gitee Server push success ! \e[0m"
# else
# 	echo -e "\e[1;31m gitee Server push fail ! \e[0m"
# fi

#推送到 github remote
git push -f -u github master
if [ $? = 0 ];then
	echo -e "\033[1;32m github Server push success ! \033[0m"
else
	echo -e "\033[1;31m github Server push fail ! \033[0m"
fi

#退回版本
#git log --graph --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%an%C(reset)%C(bold yellow)%d%C(reset) %C(dim white)- %s%C(reset)' --all
#git log
#git reset --hard commit_id
