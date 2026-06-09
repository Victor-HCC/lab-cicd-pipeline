Groovy – Jenkinsfile
pipeline {
    agent any
 
    tools {
        nodejs "NodeJS-7.8.0"
    }
 
    environment {
        // Set image name and port based on branch
        IMAGE_NAME = "${BRANCH_NAME == 'main' ? 'nodemain' : 'nodedev'}"
        APP_PORT   = "${BRANCH_NAME == 'main' ? '3000'   : '3001'}"
        IMAGE_TAG  = "v1.0"
    }
 
    stages {
 
        // ── Stage 1: Checkout ────────────────────────────────────
        stage("Checkout") {
            steps {
                echo "Checking out branch: ${BRANCH_NAME}"
                checkout scm
            }
        }
 
        // ── Stage 2: Build ───────────────────────────────────────
        stage("Build") {
            steps {
                echo "Installing Node.js dependencies..."
                sh "npm install"
            }
        }
 
        // ── Stage 3: Test ────────────────────────────────────────
        stage("Test") {
            steps {
                echo "Running tests..."
                sh "npm test"
            }
        }
 
        // ── Stage 4: Build Docker Image ──────────────────────────
        stage("Build Docker Image") {
            steps {
                script {
                    echo "Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }
 
        // ── Stage 5: Deploy ──────────────────────────────────────
        stage("Deploy") {
            steps {
                script {
                    echo "Deploying ${IMAGE_NAME}:${IMAGE_TAG} on port ${APP_PORT}"
 
                    // Stop and remove ONLY the container for this environment
                    // (Advanced: leaves the other env untouched)
                    sh """
                        EXISTING=\$(docker ps -aq --filter name=${IMAGE_NAME})
                        if [ -n "\$EXISTING" ]; then
                            echo "Stopping existing ${IMAGE_NAME} containers..."
                            docker stop \$EXISTING
                            docker rm   \$EXISTING
                        fi
                    """
 
                    // Run new container
                    if (BRANCH_NAME == "main") {
                        sh "docker run -d --name ${IMAGE_NAME} --expose 3000 -p 3000:3000 ${IMAGE_NAME}:${IMAGE_TAG}"
                    } else {
                        sh "docker run -d --name ${IMAGE_NAME} --expose 3001 -p 3001:3000 ${IMAGE_NAME}:${IMAGE_TAG}"
                    }
 
                    echo "Application deployed!"
                    echo "Access at: http://localhost:${APP_PORT}"
                }
            }
        }
    }
 
    post {
        success {
            echo "Pipeline completed successfully for branch: ${BRANCH_NAME}"
        }
        failure {
            echo "Pipeline failed for branch: ${BRANCH_NAME}"
        }
        always {
            echo "Pipeline finished. Branch: ${BRANCH_NAME}, Image: ${IMAGE_NAME}:${IMAGE_TAG}"
        }
    }
}
