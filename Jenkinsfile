pipeline {
   agent {
        label 'AGENT-1'
   }

    options {
        // Timeout counter starts AFTER agent is allocated
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
    }

 

   stages {
      stage('Init') { 
          steps {
            sh """
                ls -ltr
            """
            }
        }
      stage('Plan') { 
          steps {
             sh 'echo this is test'
            }
        }
      stage('Deploy') { 
          steps {
       sh 'echo this is deploy'
            }
        }

     

      post{
        always{
            echo 'I will always say hello again'
        }
        success{
            echo 'I will say hello only when success'
        }
        failure{
            echo 'I will say hello only when failure'
        }
      }
    }
