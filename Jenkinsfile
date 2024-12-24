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
                stage('OWASP') {
            steps {
                dependencyCheck additionalArguments: '--format HTML', odcInstallation: 'Dependency check',
                 stopBuild: true // Stop on any critical vulnerabilities
                 
            }     
        }
        // JaCoCo Code Coverage Report
        stage('JaCoCo Report') {
            steps {
                // Run JaCoCo and generate the report
                sh "mvn clean test jacoco:report"
            }
        }
    }
    post {
        always {
            // Publish JaCoCo code coverage in Jenkins
            jacoco execPattern: '**/target/*.exec', classPattern: '**/target/classes', sourcePattern: '**/src/main/java'

            // Optionally, you can publish the JaCoCo HTML report in Jenkins
            publishHTML(target: [
                reportName: 'JaCoCo Report',
                reportDir: 'target/site/jacoco',
                reportFiles: 'index.html'
            ])
        }
    }
}