#!/bin/bash
# $1 = user id
# $2 = password
# $3 = repo name
# $4 = git repo
# $5 = aws access
# $6 = aws secret
# $7 = region
# $8 = ci or cicd

jobname=$(cat /proc/sys/kernel/random/uuid)
xmlpath="/root/cicdjob/jenkinsjob/template/${jobname}.xml"
# get xml file template( it attain pipeline job context ). we made it by get xml file from jenkins server job, which admin create it. it is template for create xml
# java -jar jenkins-cli.jar -s http://192.168.1.192:8080/ -auth admin:test123 -webSocket get-job jobname > sample.xml
# after get xml, it change some variable for job

if [[ $8 == 'cicd' ]]
then
cp /root/cicdjob/jenkinsjob/template/playcicd.xml $xmlpath
# update xml file
sed -i "s@setgitrepoaddr@${4}@g" $xmlpath
sed -i "s@setawsaccesskeyid@${5}@g" $xmlpath
sed -i "s@setawssecretkey@${6}@g" $xmlpath
sed -i "s@setregion@${7}@g" $xmlpath
sed -i "s@setecrreponame@${3}@g" $xmlpath

else
cp /root/cicdjob/jenkinsjob/template/playci.xml $xmlpath
# update xml file
sed -i "s@setgitrepoaddr@${4}@g" $xmlpath
sed -i "s@setawsaccesskeyid@${5}@g" $xmlpath
sed -i "s@setawssecretkey@${6}@g" $xmlpath
sed -i "s@setregion@${7}@g" $xmlpath
sed -i "s@setecrreponame@${3}@g" $xmlpath

fi

# make job using by xml
java -jar jenkins-cli.jar -s http://192.168.1.192:8080/ -auth $1:$2 -webSocket create-job ${jobname} < $xmlpath

# build job
java -jar jenkins-cli.jar -s http://192.168.1.192:8080/ -auth $1:$2 -webSocket build ${jobname}

sleep 25

# get result about build
result=$(cat /var/lib/jenkins/jobs/${jobname}/builds/1/log | tail -n 1)

# delete job after build complete
rm -rf $xmlpath
java -jar jenkins-cli.jar -s http://192.168.1.192:8080/ -auth $1:$2 -webSocket delete-job ${jobname}

# return build result ( success or fail ) by stdin for python subprocess module
echo $result
