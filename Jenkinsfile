pipeline {
  agent any
  stages {
    stage('Build') {
      parallel {
        stage('Build') {
          steps {
            echo 'Building the application'
          }
        }

        stage('Test') {
          steps {
            echo 'Testing the application'
            echo '"Printing JDK path " + ${JDKPath}'
          }
        }

      }
    }

    stage('Deploy') {
      steps {
        echo 'Deploying the app on a server'
      }
    }

  }
  environment {
    JDKPath = '/Library/Java/JavaVirtualMachines/sapmachine-jdk-11.0.11.jdk/Contents/Home'
  }
}