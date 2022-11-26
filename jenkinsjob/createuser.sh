#!/bin/bash

# id : $1
password=$2

#create user and set role - CLI
java -jar jenkins-cli.jar -s http://localhost:8080/ -auth admin:URUSA123 groovy = <<EOF
jenkins.model.Jenkins.instance.securityRealm.createAccount("$1", "${password}")
com.michelin.cio.hudson.plugins.rolestrategy.RoleBasedAuthorizationStrategy.getInstance().doAssignRole("globalRoles", "developer", "$1")
EOF

# get csrf token - API
csrfresult=$(curl -s --cookie-jar /tmp/cookies -u $1:${password} http://localhost:8080/crumbIssuer/api/json)

# make temporary file and file address
csrffile=$(mktemp -t temptoken.XXX)
tokenfile=$(mktemp -t temptoken.XXX)
slicetokenfile=$(mktemp -t temptoken.XXX)

# slice csrf token from json file
echo $csrfresult | jq '.crumb' > $csrffile

# delete " from side of csrf token
sed -i 's/"//g' $csrffile
#cat $csrffile
csrftoken=$(cat $csrffile)

# set api token name
nameoftoken=($1"token")

# get api token - API
jenkinstoken_json=$(curl -X POST --cookie /tmp/cookies http://localhost:8080/me/descriptorByName/jenkins.security.ApiTokenProperty/generateNewToken?newTokenName=$nameoftoken -H "Jenkins-Crumb:$csrftoken" -u $1:${password})

# slice the json file for get token value
echo $jenkinstoken_json > $tokenfile
cat $tokenfile | jq '.data.tokenValue' > $slicetokenfile

# remove " from token
sed -i 's/"//g' $slicetokenfile
jenkins_api_token=$(cat $slicetokenfile)

# print result
echo $jenkins_api_token

# delete temporary file
rm -rf $csrffile 2> /dev/null
rm -rf $tokenfile 2> /dev/null
rm -rf $slicetokenfile 2> /dev/null
