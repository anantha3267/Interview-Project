pipeline {
    agent any
    tools {
        jdk 'jdk'
        maven 'maven'
    }

    stages {
        // Git Checkout
        stage('Git Checkout') {
            steps {
                git branch: 'main', changelog: false, poll: true, url: 'https://github.com/anantha3267/Interview-Project.git'
            }
        }

        // Compile Stage
        stage('Compile') {
            steps {
                sh "mvn clean compile"
            }
        }

        // Run Test Cases
        stage('Test Cases') {
            steps {
                sh "mvn test"
            }
        }

        // SonarQube Analysis
        stage('Sonar analysis') {
            steps {
                script {
                    // Use the SonarQube environment
                    withSonarQubeEnv('SonarQube') {
                        sh "mvn clean package"
                        sh ''' mvn sonar:sonar \
                                -Dsonar.projectName=Scoreme \
                                -Dsonar.java.binaries=. \
                                -Dsonar.projectKey=Scoreme '''
                    }
                }
            }
        }

        //Wait for SonarQube Quality Gate
        stage('Quality Gate') {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    script {
                        def qg = waitForQualityGate()
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
                }
            }
        }

        // OWASP Dependency-Check
        stage('OWASP') {
            steps {
                dependencyCheck additionalArguments: '--format HTML', odcInstallation: 'Dependency check'
            }
        }

        // JaCoCo Code Coverage
        stage('JaCoCo Report') {
            steps {
                sh "mvn clean test jacoco:report"
            }
        }
    }

    post {
        success {
            mail to: 'ananthamchiranjeevi@gmail.com', subject: 'Build Success', body: 'The build has completed successfully.'
        }

        failure {
            // Email Notification on failure (optional)
            mail to: 'ananthamchiranjeevi@gmail.com', subject: 'Build Failed', body: 'The build has failed. Please check the Jenkins logs.'
        }

        always {
            // Publish JaCoCo report in Jenkins
            jacoco execPattern: '**/target/*.exec', classPattern: '**/target/classes', sourcePattern: '**/src/main/java'
        }

        always {
            // Publish SonarQube report in Jenkins
            publishHTML(target: [
                reportName: 'SonarQube Report',
                reportDir: 'target/sonar',
                reportFiles: 'index.html'
            ])
        }
    }
}
