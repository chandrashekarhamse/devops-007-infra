def tag_destroy = 'destroy_k8s_nodes'

pipeline {
  agent {
    label 'ec2-linux-docker-agent'
  }

  stages {
    stage('checkout Terraform repo') {
        steps {
            dir('terraform') {
                checkout([$class: 'GitSCM', 
                    branches: [[name: '*/main']], 
                    userRemoteConfigs: [[url: 'https://github.com/chandrashekarhamse/terraform-automation.git']]
                ])
            }
        }
    }

    stage('Create the k8s nodes') {
      agent {
        docker {
          image 'hashicorp/terraform:1.13'
          args '-v /var/run/docker.sock:/var/run/docker.sock'
          reuseNode true  // 👈 Mounts the same workspace from EC2 agent into the Docker container
        }
      }
      steps {
        sh 'terraform --version'
        sh 'terraform init'
        sh 'terraform plan'
        sh 'terraform apply --auto-approve'
      }
    }
    stage('Destroy the k8s nodes') {
      when {
        tag tag_destroy
      }
      agent {
        docker {
          image 'hashicorp/terraform:1.13'
          args '-v /var/run/docker.sock:/var/run/docker.sock'
          reuseNode true
        }
      }
      steps {
        sh 'terraform destroy --auto-approve'
      }
    }
  }
}
