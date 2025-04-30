pipeline {
  agent any

  environment {
    AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
    AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    AWS_DEFAULT_REGION    = 'ap-south-1'
  }

  stages {

    stage('Clone Repository') {
      steps {
        git 'https://github.com/Vishwassp1999/devops-project.git'
      }
    }

    stage('Terraform Init') {
      steps {
        dir('terraform') {
          sh 'terraform init'
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        dir('terraform') {
          sh 'terraform plan'
        }
      }
    }

    stage('Terraform Apply') {
      steps {
        dir('terraform') {
          sh 'terraform apply -auto-approve'
        }
      }
    }
  }

  post {
    success {
      echo '✅ EC2 instance deployed successfully!'
    }
    failure {
      echo '❌ Build failed. Check logs.'
    }
  }
}
