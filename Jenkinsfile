pipeline {
    agent any

    environment {
        DOCKER_CREDS = 'dockerhub-creds'
        DOCKERHUB_USERNAME = 'tejasb02'
        AWS_REGION = 'us-east-1'
        CLUSTER_NAME = 'my-eks-cluster'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
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
                                    image.push("latest")
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
                                    image.push("latest")
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
                                    image.push("latest")
                                }
                            }
                        }
                    }
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'aws-creds',
                    usernameVariable: 'AWS_ACCESS_KEY_ID',
                    passwordVariable: 'AWS_SECRET_ACCESS_KEY'
                )]) {
                    sh '''
                        aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                        aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                        aws configure set default.region $AWS_REGION

                        aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME

                        kubectl apply -f k8s/order/
                        kubectl apply -f k8s/stock/
                        kubectl apply -f k8s/delivery/
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Deployed to EKS successfully.'
        }
        failure {
            echo 'Deployment failed.'
        }
    }
}