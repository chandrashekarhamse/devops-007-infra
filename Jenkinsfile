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
        stage('Terraform init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        } 
        stage('Terraform plan') {
            steps {
                dir('terraform') {
                    sh 'terraform plan'
                }
            }
        }
    }
}