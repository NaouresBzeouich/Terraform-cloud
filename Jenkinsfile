pipeline{
    agent any
    stages {
        stage('Terraform Init') {
            steps {
                bat 'terraform init'
            }
        }
        stage('Terraform Plan') {
            steps {
                bat 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            steps {
                bat 'terraform apply -auto-approve'
            }
        }

        stage('Deploy with Ansible') {
            steps {
                bat 'echo ansible-playbook -i inventory.ini playbook.yml'
            }
        }
    }
}
