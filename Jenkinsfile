pipeline {
  agent { label 'slave01' }

  options {
    buildDiscarder(logRotator(numToKeepStr: '3', artifactDaysToKeepStr: '7'))
    timestamps()
    timeout(time: 5, unit: 'MINUTES')
  }

  environment {
    envs   = 'stage,pff,prod'
    deploy = 'true'
  }

  stages {
    stage('Check environment') {
      steps {
        echo "envs=${env.envs}"
        echo "deploy=${env.deploy}"
      }
    }

    stage('Check timeout') {
      options {
        timeout(time: 30, unit: 'SECONDS')
      }
      steps {
        sh 'sleep 60'
      }
    }
  }

  post {
    always {
      cleanWs()
    }
  }
}
