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

 parameters{
    choice(name: 'action', choices: ['Apply', 'Destroy'], description: 'Pick something')
 }

   stages {
      stage('Init') { 
         
          steps {
            script{
            def directories = ['10-cdn', '08-web-alb', '07-0.1-acm', '06-alb', '05-vpn', '04-db', '02-sg', '01-vpc']

                    for (String dirName : directories) {
                        // Change to the directory
                        dir(dirName) {
                            // Initialize Terraform (if not already initialized)
                            sh """terraform init"""
                        }
                    }
            }
            
            }
        }
   }
      stage('Plan') { 
        when{
            expression{
                params.action == 'Apply'
            }
        }
          steps {
             sh """
                cd 01-vpc
                terraform plan
             """

            }
        }
      stage('Deploy') {

        when{
            expression{
                params.action == 'Apply'
            }
        }
       
          steps {
            sh """
                cd 01-vpc
                terraform apply -auto-approve
             """
            }
        }

        stage('Destroy') {
             when{
            expression{
                params.action == 'Destroy'
            }
        }
      
          steps {
            script{
             def directories = ['10-cdn', '08-web-alb', '07-0.1-acm', '06-alb', '05-vpn', '04-db', '02-sg', '01-vpc']

                    for (String dirName : directories) {
                        // Execute terraform destroy inside the directory
                        sh """
                            cd ${dirName}
                            terraform destroy -auto-approve
                        """
                    }
            }
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


