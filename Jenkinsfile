pipeline {
    agent any
    stages {
        stage('Clean') {
            steps {
                echo "Cleaning docker compose containers"
                sh 'docker-compose down'
            }
        }
        stage('Docker compose in test mode') {
            steps {
                echo "building the docker compose and initialize the containers with running tests as entry point"
                sh 'docker-compose up -d'
            }
        }
        stage('Reporting Tests') {
            steps {
               sleep 150
               junit 'spec/reports/*.xml'
            }
        }
         stage('Docker compose teardown') {
            steps {
                echo "clean the docker compose containers"
                sh 'docker-compose down'
            }
        }
    }
}