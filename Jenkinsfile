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
            echo "Printing JDK path  + ${JDKPath}"
          }
        }

        stage('Step Log') {
          steps {
            writeFile(file: 'Logtextfile.txt', text: 'This is an automation file')
          }
        }

      }
    }

    stage('Deploy') {
      parallel {
        stage('Deploy') {
          
          steps {
            input(message: 'Do you want to still deploy ?', id: 'OK')
            echo 'Deploying the app on a server'
          }
        }

        stage('Artefacts') {
          steps {
            archiveArtifacts 'Logtextfile.txt'
          }
        }
      }
    }

  }
  environment {
    JDKPath = '/Library/Java/JavaVirtualMachines/sapmachine-jdk-11.0.11.jdk/Contents/Home'
  }
}