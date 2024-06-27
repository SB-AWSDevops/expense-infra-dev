pipeline {
   agent {
        label 'AGENT-1'
   }

    options {
        // Timeout counter starts AFTER agent is allocated
        timeout(time: 30, unit: 'MINUTES')
        disableConcurrentBuilds()
        ansiColor('xterm')
    }

 

   stages {
      stage('Init') { 
          steps {
            sh """
                cd 01-vpc
                terraform init -reconfigure
            """
            }
        }
      stage('Plan') { 
          steps {
             sh """
                cd 01-vpc
                terraform plan
             """

            }
        }
      stage('Deploy') {
        input{
            message "Should we continue?"
            ok "Yes"
        } 
          steps {
            sh """
                cd 01-vpc
                terraform apply -auto-approve
             """
            }
        }
   }

      post{
        always{
            echo 'I will always say hello again'
            deleteDir()
        }
        success{
            echo 'I will say hello only when success'
        }
        failure{
            echo 'I will say hello only when failure'
        }
      }
    }

