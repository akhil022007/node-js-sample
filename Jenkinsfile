pipeline{

agent any

environment {
    REPO_URL = "https://github.com/akhil022007/node-js-sample.git"
}

stages {


   
  
    stage('Checkout') {
        steps {
            script {
                echo "Checking out code from ${env.REPO_URL}"
                cleanWs()
                git branch: 'master', url: "${env.REPO_URL}"
            }
        }
    }

    stage('Build & Deploy') {
        steps {
            script {
                echo "Executing deploy.sh script..."
                sh 'chmod +x deploy.sh'
                sh './deploy.sh'
            }
        }
    }

    stage('Test Application') {
        steps {
            script {
                echo "Executing test.sh script..."
                sh 'chmod +x test.sh'
                sh './test.sh'
            }
        }
    }
}

post {
    always {
        echo "Pipeline finished."
    }
    success {
        echo "Pipeline completed successfully! Application is deployed."
    }
    failure {
        echo "Pipeline failed. Check Jenkins console output for errors."
    }
}
}
