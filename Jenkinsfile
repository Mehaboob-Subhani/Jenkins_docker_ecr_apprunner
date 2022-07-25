pipeline {
    agent any
    tools {nodejs "Node"}
    options {
        skipStagesAfterUnstable()
    }
    stages {
        stage('Clone repository') { 
            steps { 
                script{
                checkout scm
                }
            }
        }
        stage('React build') {
            //need to create secret text in jenkins credential, specific to "ms" pipeline (Not global)
            environment {
                WELCOME = credentials("WELCOME")       
            }
            steps {
                sh 'echo "install and build react app"'
                sh 'echo "$WELCOME"'
                sh '''
                   npm install -g yarn
                   cd ui
                   yarn install
                   yarn run create-env
                   yarn run build
                '''
            }
        }  
        stage('Deploy for feature/sub-user_v1') {
            when {
                branch 'feature/sub-user_v1'
            }
            steps {
                script{
                  docker.withRegistry('http://*.dkr.ecr.us-east-1.amazonaws.com/slates', 'ecr:us-east-1:ms') {                 
                    def app = docker.build("react_django_app")
                    app.push("latest")
                    }
                }
            }
        }    
        stage('Deploy for release/uat') {
            when {
                branch 'release/uat'
            }
            steps {
                script{
                  input message: 'Finished build the docker image? (Click "Proceed" to continue)'
                  docker.withRegistry('http://*.dkr.ecr.us-east-1.amazonaws.com/react_django_app', 'ecr:us-east-1:ms') {                 
                    def app = docker.build("react_django_app")
                    app.push("latest")
                    }
                }
            }
        }
        stage('Deploy for preprod') {
            when {
                branch 'preprod'
            }
            steps {
                script{
                  input message: 'Finished build the docker image? (Click "Proceed" to continue)'
                  docker.withRegistry('http://*.dkr.ecr.us-east-1.amazonaws.com/react_django_app', 'ecr:us-east-1:ms') {                 
                    def app = docker.build("react_django_app")
                    app.push("latest")
                    }
                }
            }
        }
        stage('Deploy for live') {
            when {
                branch 'live'
            }
            steps {
                script{
                  input message: 'Finished build the docker image? (Click "Proceed" to continue)'
                  docker.withRegistry('http://*.dkr.ecr.us-east-1.amazonaws.com/react_django_app', 'ecr:us-east-1:ms') {                 
                    def app = docker.build("react_django_app")
                    app.push("latest")
                    }
                }
            }
        }             
        stage('Checkout code') {
            steps {
                script {
                // Checkout the repository and save the resulting metadataa
                def scmVars = checkout([
                    $class: 'GitSCM',
                ])

                // Display the variable using scmVars
                echo "scmVars.GIT_COMMIT"
                echo "${scmVars.GIT_COMMIT}"

                // Displaying the variables saving it as environment variables
                
                env.GIT_COMMIT = scmVars.GIT_COMMIT
                echo "env.GIT_COMMIT"
                echo "${env.GIT_COMMIT}"
                }
               // Here the metadata is available as environment variables
            }
        } 
    }
    post{
               // send email triigger always
        always{
            emailext to: "ahamedsubhani12@gmail.com",
            subject: "jenkins build:${currentBuild.currentResult}: ${env.JOB_NAME}",
            body: "${currentBuild.currentResult}: Job ${env.JOB_NAME}\nMore Info can be found here: ${env.BUILD_URL}"
        }
    }    
}
