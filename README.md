# UC2S_CICD_JOB
#### UC2S Project - CICD 노드 실행 파일

### 파일 설명
- Setawsgetconfig.sh : 해당 AWS 계정이 가지고 있는 클러스터에 대한 kubeconfig 파일을 가져와서 Jenkins 에 등록해준다
- createuser.sh	: JENKINS 유저를 생성하고, API TOKEN 을 생성하여 반환해준다
- Setworkspace.sh	: Jenkins 유저의 프로젝트 별 작업 공간을 생성해준다 
- Jenkinsplay.sh	: Jenkins-Cli 를 이용해 CI / CICD 작업을 수행해준다
- playcicd.xml	: Cicd job 템플릿 파일로 해당 파일을 수정하여 사용자 별 job 을 정의한다
- Playci.xml	: Ci job 템플릿 파일로 해당 파일을 수정하여 사용자 별 job 을 정의한다
- Main.sh	: 사용자가 ci 혹은 cicd 서비스를 요청하면, main 에서 요청한 서비스가 ci 인지 cicd 인지 확인하여 필요한 작업을 수행한다
