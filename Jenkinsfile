def tag_destroy = 'destroy_k8s_nodes'

pipeline {
  agent {
    label 'ec2-linux-docker-agent'
  }
  environment {
    ANSIBLE_KEY = credentials('ANSIBLE_SSH_PRIVATE_KEY')
  }
  parameters {
    choice(name: 'DESTROY_K8s_INFRA', choices: ['No','Yes'], description: 'Destroy k8s Infra ?')
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
          sh '''
            terraform --version
            terraform init
            terraform plan
            terraform apply --auto-approve
            
          '''
        }
      }
    }

    stage('Destroy k8s Nodes') {
      when {
        expression {
          return params.DESTROY_K8s_INFRA == 'Yes'
        }
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
          writeFile file: 'ec2-key.pem', text: "${ANSIBLE_KEY}"
          sh 'chmod 400 ec2-key.pem'
          sh '''
            pip3 install --no-cache-dir boto3 botocore
            ansible-galaxy collection install amazon.aws --upgrade
          '''
          sh '''
            ansible-inventory -i inventory/k8s-nodes/aws_ec2.yaml --list
            sleep 3600
          '''
          // sh '''
          //   ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory/k8s-nodes/aws_ec2.yaml --private-key ec2-key.pem master-playbook.yml
          //   sleep 60
          //   ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory/k8s-nodes/aws_ec2.yaml --private-key ec2-key.pem worker-playbook.yml
          // '''
        }
      }
    }
  }
}
