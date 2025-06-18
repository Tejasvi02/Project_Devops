pipeline {
    agent any

    environment {
        DOCKER_CREDS = 'dockerhub-creds'
        GITHUB_CREDS = 'github-creds'
        DOCKERHUB_USERNAME = 'tejasb02'
        AWS_REGION = 'us-east-1'
        CLUSTER_NAME = 'my-eks-cluster'
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

        stage('Deploy to EKS') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-creds', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    withEnv(["KUBECONFIG=${env.WORKSPACE}/kubeconfig"]) {
                        sh '''
                        aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
                        aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
                        aws eks update-kubeconfig --region $AWS_REGION --name $CLUSTER_NAME

                        kubectl apply -f k8s/order/
                        kubectl apply -f k8s/stock/
                        kubectl apply -f k8s/delivery/
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            echo '✅ Deployed to EKS successfully.'
        }
        failure {
            echo '❌ Deployment failed.'
        }
    }
}
