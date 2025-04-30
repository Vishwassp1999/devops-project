pipeline {
  agent any

  environment {
    AWS_DEFAULT_REGION = 'ap-south-1'
  }

  stages {
    stage('Clone Repo') {
      steps {
        git branch: 'main', url: 'https://github.com/Vishwassp1999/devops-project.git'
      }
    }

    stage('Terraform Init') {
      steps {
        sh '''
          terraform init
        '''
      }
    }

    stage('Terraform Apply') {
      steps {
        sh '''
          terraform apply -auto-approve
        '''
      }
    }
  }
}
