pipeline {
  agent any

  environment {
    AWS_DEFAULT_REGION = 'ap-south-1'
  }

  stages {
    stage('Terraform Init & Apply') {
      environment {
        AWS_CREDS = credentials('aws-creds')  // ID of your stored Username/Password
      }
      steps {
        sh '''
          export AWS_ACCESS_KEY_ID=$AWS_CREDS_USR
          export AWS_SECRET_ACCESS_KEY=$AWS_CREDS_PSW
          cd terraform
          terraform init
          terraform apply -auto-approve
        '''
      }
    }
  }

  post {
    failure {
      echo '❌ Build failed. Check logs.'
    }
    success {
      echo '✅ EC2 instance provisioned successfully!'
    }
  }
}
