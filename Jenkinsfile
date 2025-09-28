def tag_destroy = 'destroy_k8s_nodes'

pipeline {
  agent {
    label 'ec2-linux-docker-agent'
  }
  stages {
    stage('checkout terraform repo') {
      steps {
        dir('terraform') {
          checkout([$class: 'GitSCM', 
              branches: [[name: '*/main']], 
              userRemoteConfigs: [[url: 'https://github.com/chandrashekarhamse/terraform-automation.git']]
          ])
        }
      }
    }
    stage('Create k8s nodes') {
      agent {
        docker {
          image 'hashicorp/terraform:1.13'
          args '--entrypoint="sleep 300" -u root -v /var/run/docker.sock:/var/run/docker.sock -t'
          reuseNode true
        }
      }
      steps {
        sh 'terraform --version'
        sh 'terraform init'
        sh 'terraform plan'
        sh 'terraform apply --auto-approve'
      }
    }
    stage('Destroy k8s nodes') {
      when {
        tag tag_destroy
      }
      agent {
        docker {
          image 'hashicorp/terraform:1.13'
          args '--entrypoint="" -u root -v /var/run/docker.sock:/var/run/docker.sock -t'
          reuseNode true
        }
      }
      steps {
        sh 'terraform destroy --auto-approve'
      }
    }
  }
}