master:
	sls deploy --stage=dev --service=devops-007-infra-jenkins-master
slave:
	sls deploy --stage=dev --service=devops-007-infra-jenkins-slave
both:
	sls deploy --stage=dev --service=devops-007-infra-jenkins-master
	sls deploy --stage=dev --service=devops-007-infra-jenkins-slave
master-destroy:
	sls remove --stage=dev --service=devops-007-infra-jenkins-master
slave-destroy:
	sls remove --stage=dev --service=devops-007-infra-jenkins-slave
master-slave:
	sls remove --stage=dev --service=devops-007-infra-jenkins-master
	sls remove --stage=dev --service=devops-007-infra-jenkins-slave