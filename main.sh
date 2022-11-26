#!/bin/bash

# $1 = user id
# $2 = user password
# $3 = repo name
# $4 = cluster name
# $5 = githubrepo_address
# $6 = aws_access_key_id
# $7 = aws_secret_access_key
# $8 = region
# $9 = ci or cicd

# create jenkins workspace and setting it
#/root/cicdjob/jenkinsjob/setworkspace.sh $1

if [[ $9 == 'cicd' ]]
then
# set aws config for access and get kubeconfig from eks cluster
  /home/ec2-user/cicdjob/awsjob/setawsgetconfig.sh $6 $7 $8 $4

# start job - cicd
  /home/ec2-user/cicdjob/jenkinsjob/jenkinsplay.sh $1 $2 $3 $5 $6 $7 $8 $9
else
# start job - ci
  /home/ec2-user/cicdjob/jenkinsjob/jenkinsplay.sh $1 $2 $3 $5 $6 $7 $8 $9
fi
