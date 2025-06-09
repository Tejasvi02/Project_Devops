pipeline {
    agent any

    environment {
        DOCKER_CREDS = 'dockerhub-creds'
        GITHUB_CREDS = 'github-creds'
        DOCKERHUB_USERNAME = 'tejasb02'
        DOCKER_BUILDKIT = '1'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', credentialsId: "${GITHUB_CREDS}", url: 'https://github.com/Tejasvi02/Project_Devops.git'
            }
        }

        stage('Build & Push Docker Images') {
            parallel {
                stage('Service A') {
                    steps {
                        dir('order-ms') {
                            sh 'mvn clean package -DskipTests'
                            script {
                                def image = docker.build("${DOCKERHUB_USERNAME}/service-a:${BUILD_NUMBER}")
                                docker.withRegistry('', DOCKER_CREDS) {
                                    image.push()
                                }
                            }
                        }
                    }
                }

                stage('Service B') {
                    steps {
                        dir('stock-ms') {
                            sh 'mvn clean package -DskipTests'
                            script {
                                def image = docker.build("${DOCKERHUB_USERNAME}/service-b:${BUILD_NUMBER}")
                                docker.withRegistry('', DOCKER_CREDS) {
                                    image.push()
                                }
                            }
                        }
                    }
                }

                stage('Service C') {
                    steps {
                        dir('delivery-ms') {
                            sh 'mvn clean package -DskipTests'
                            script {
                                def image = docker.build("${DOCKERHUB_USERNAME}/service-c:${BUILD_NUMBER}")
                                docker.withRegistry('', DOCKER_CREDS) {
                                    image.push()
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    post {
        success {
            echo '✅ All services built and pushed successfully.'
        }
        failure {
            echo '❌ Build or push failed.'
        }
        always {
            cleanWs()
        }
    }
}

