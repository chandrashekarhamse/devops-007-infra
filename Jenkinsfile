def tag_destroy = 'destroy_k8s_nodes'

pipeline {
  agent {
    label 'ec2-linux-docker-agent'
  }

  stages {
    stage('Checkout Terraform Repo') {
      steps {
        dir('terraform') {
          checkout([$class: 'GitSCM',
            branches: [[name: '*/main']],
            userRemoteConfigs: [[url: 'https://github.com/chandrashekarhamse/terraform-automation.git']]
          ])
        }
      }
    }

    stage('Create k8s Nodes with Terraform') {
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

    stage('Destroy k8s Nodes') {
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

    stage('Checkout Ansible Repo') {
      steps {
        dir('ansible') {
          checkout([$class: 'GitSCM',
            branches: [[name: '*/main']],
            userRemoteConfigs: [[url: 'https://github.com/chandrashekarhamse/ansible-automation.git']]
          ])
        }
      }
    }

    stage('Configure k8s Nodes using Ansible') {
      agent {
        docker {
          image 'alpine/ansible:2.17.0'
          reuseNode true
        }
      }
      steps {
        dir('ansible') {
          sh 'ansible localhost -m ping -c local'
        }
      }
    }
  }
}
