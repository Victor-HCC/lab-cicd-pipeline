pipeline {
    agent any

    tools {
        nodejs "NodeJS-7.8.0"
    }

    environment {
        IMAGE_NAME = "${BRANCH_NAME == 'main' ? 'nodemain' : 'nodedev'}"
        APP_PORT   = "${BRANCH_NAME == 'main' ? '3000' : '3001'}"
        IMAGE_TAG  = "v1.0"
    }

    stages {

        stage("Checkout") {
            steps {
                echo "Checking out branch: ${BRANCH_NAME}"
                checkout scm
            }
        }

        stage("Build") {
            steps {
                sh "npm install"
            }
        }

        stage("Test") {
            steps {
                sh "npm test"
            }
        }

        stage("Build Docker Image") {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        stage("Deploy") {
            steps {
                script {
                    sh """
                        EXISTING=\$(docker ps -aq --filter name=${IMAGE_NAME})
                        if [ -n "\$EXISTING" ]; then
                            docker stop \$EXISTING
                            docker rm   \$EXISTING
                        fi
                    """
                    if (BRANCH_NAME == "main") {
                        sh "docker run -d --name ${IMAGE_NAME} --expose 3000 -p 3000:3000 ${IMAGE_NAME}:${IMAGE_TAG}"
                    } else {
                        sh "docker run -d --name ${IMAGE_NAME} --expose 3001 -p 3001:3000 ${IMAGE_NAME}:${IMAGE_TAG}"
                    }
                    echo "Access at: http://localhost:${APP_PORT}"
                }
            }
        }
    }

    post {
        success { echo "Pipeline succeeded for branch: ${BRANCH_NAME}" }
        failure { echo "Pipeline failed for branch: ${BRANCH_NAME}" }
    }
}
