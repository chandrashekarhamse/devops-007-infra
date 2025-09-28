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
    stage('Create k8s nodes with terraform') {
      agent {
        docker {
          image 'hashicorp/terraform:1.13'
          args '--entrypoint="" -u root -v /var/run/docker.sock:/var/run/docker.sock -t'
          reuseNode true
        }
      }
      steps {
        dir('terraform') {
          sh 'terraform --version'
          sh 'terraform init'
          sh 'terraform plan'
        }
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
        dir('terraform') {
          sh 'terraform destroy --auto-approve'
        }       
      }
    }
  }
  stages{
    stage('checkout ansible repo') {
      steps {
        dir('ansible') {
          checkout([$class: 'GitSCM', 
              branches: [[name: '*/main']], 
              userRemoteConfigs: [[url: 'https://github.com/chandrashekarhamse/ansible-automation.git']]
          ])   
        }     
      }
    }
    stage('configure k8s nodes using ansible') {
      agent {
        docker {
          image 'alpine/ansible:2.17.0'
          reuseNode true
        }
      }
      steps{
        dir('ansible') {
          ansible localhost -m ping
        }
      }
    }
  }
}