def tag_destroy = 'destroy_k8s_nodes'

<<<<<<< HEAD
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
=======
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
        stage('Create k8s nodes') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                    sh 'terraform plan'
                    sh 'terraform apply --auto-approve'
                }
            }
        } 
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
        stage('Configure k8s controlplane node') {
            steps {
                dir('ansible') {
                    sh 'sleep 120'
                    sh 'ansible-playbook -i inventory/k8s-nodes/aws_ec2.yml master-playbook.yml'
                }
            }
        }
        stage('Configure k8s worker node') {
            steps {
                dir('ansible') {
                    sh 'sleep 30'
                    sh 'ansible-playbook -i inventory/k8s-nodes/aws_ec2.yml worker-playbook.yml'
                }
>>>>>>> bbd60b2 (updated Jenkinsfile)
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
