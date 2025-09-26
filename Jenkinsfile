pipeline {
    agent { label 'ec2-linux-docker-agent' }

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
                    sh 'ansible-playbook -i inventory/k8s-nodes/aws_ec2.yml master-playbook.yml'
                }
            }
        }
        stage('Configure k8s worker node') {
            steps {
                dir('ansible') {
                    sh 'ansible-playbook -i inventory/k8s-nodes/aws_ec2.yml worker-playbook.yml'
                }
            }
        }
    }
}