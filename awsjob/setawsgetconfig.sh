#!/bin/bash
# get kubeconfig from user iam - region - cluster and import it to jenkins
# 파이프라인 생성은 일회성으로 하므로, 매번 config 를 가져와서 mv 해주면, 덮어씌여져서 해당 config 로 작업을 실행할 수 있다
# $1 = access key
# $2 = secret key
# $3 = region
# $4 = cluster name

# reset aws configure data, if it exist
rm -rf ~/.aws/credentials
rm -rf ~/.aws/config

# set aws configure
aws configure set aws_access_key_id $1
aws configure set aws_secret_access_key $2
aws configure set region $4
aws configure set output json

# make .kube dir
mkdir -p $HOME/.kube

# config 에 대한 소유권 설정, 현재 유저한테 소유권을 준다
#sudo chown $(id -u):$(id -g) $HOME/.kube/config

# get kubeconfig
aws eks update-kubeconfig --region $3 --name $4

# move kubeconfig file to jenkins.kube
sudo cp $HOME/.kube/config /var/lib/jenkins/.kube/
