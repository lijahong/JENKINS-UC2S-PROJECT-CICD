#!/bin/bash
# 사용하지 않는 파일이다. 사용자별 작업 공간을 생성하고, 해당 공간을 jenkins 의 workspace 로 지정해준다
# $1 = user id

#set dir name
userdir="userdir$1"

# if userdir is not exist, create userdir
if [ ! -d /root/cicdjob/workspace/$userdir ]
then
  mkdir /root/cicdjob/workspace/$userdir
fi

setdir="/root/cicdjob/workspace/${userdir}"
sed -i "s@workspacechange@${userdir}@g" /var/lib/jenkins/config.xml
