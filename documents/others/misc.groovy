pipeline {

    agent any

    environment {
        VEGA_SERVER_BRANCH = "${VEGA_SERVER_BRANCH}"
        INTERFACE_TESTING_BRANCH = "${INTERFACE_TESTING_BRANCH}"

        VEGA_SERVER_DIR = "vega_server_dir"
        VEGA_INTERFACE_TESTING_DIR = "interface_testing_dir"

        SERVER_CONFIG_PATH = "/tmp/vega_server/interface_testing/config/"

        HOST_MAVEN_DEPENDENCE = '/tmp/vega_server/.m2/'
        DOCKER_MAVEN_DEPENDENCE = '/root/.m2/'
    }

    stages {

        stage("Checkout Vega Server code base") {
            steps {
                dir("${VEGA_SERVER_DIR}") {
                    git (
                        branch: "${VEGA_SERVER_BRANCH}",
                        credentialsId: "jenkins_deploy",
                        url: "git@git.youle.game:vega/backend/servers.git"
                    )
                }
            }
        }

        stage("Launch vega_game_server for testing") {
            steps {
                dir("${VEGA_SERVER_DIR}") {
                    sh 'cd Vega && cp ${SERVER_CONFIG_PATH}/SERVER_CONFIG.json config/SERVER_CONFIG.json'
                    sh 'cd Vega && cp ${SERVER_CONFIG_PATH}/dev.json config/dev.json'
                    sh 'cd Vega && cp .env.example .env'
                    sh 'cd Vega && docker-compose build'
                    sh 'cd Vega && docker-compose up game-server&'

                    // sleep for 10 seconds to wait for the service is really launched.
                    sleep(time:10,unit:"SECONDS")
                }
            }
        }

        stage("Execute Vega Interface testing") {
            agent {
                docker {
                    image 'registry-dev.youle.game/unit_test/maven_jdk10:latest'
                    args '--network=host -u root:root -v ${WORKSPACE}:/app -v ${HOST_MAVEN_DEPENDENCE}:${DOCKER_MAVEN_DEPENDENCE}'
                    reuseNode true
                }
            }

            steps {
                dir("${VEGA_INTERFACE_TESTING_DIR}") {
                    git (
                        branch: "${INTERFACE_TESTING_BRANCH}",
                        credentialsId: "jenkins_deploy",
                        url: "git@git.youle.game:vega/backend/VegaInterfaceTest.git"
                    )

                    sh 'make test'
                }
            }

            post {
                always {
                    sendDingTalkMessage()
                }
            }
        }
    }

    post {
        always {
            dir("${VEGA_SERVER_DIR}") {
                sh 'cd Vega && docker-compose down'
            }
        }
    }
}

def sendDingTalkMessage() {
    def dingTalkUrl = "https://oapi.dingtalk.com/robot/send?access_token=f7c505c57bbc82982d10fe0e43bdb4b78f9e67503afc271fb3c162ebc0ca1279"
    def message = """
       {
           "msgtype": "markdown",
           "markdown": {
               "title": "Jenkins DingTalk Message",
               "text": "### [Vega Interface Testing]: The build ${BUILD_ID} for task ${JOB_BASE_NAME} is ${currentBuild.currentResult}\n* Job Name: ${JOB_BASE_NAME}\n* Job Status: ${currentBuild.currentResult}\n* Job URL: ${JOB_URL}${BUILD_ID}\n"
           }
       }
    """

    def response = httpRequest acceptType: 'APPLICATION_JSON', contentType: 'APPLICATION_JSON', httpMode: 'POST', requestBody: message, url: dingTalkUrl

    println('Response: ' + response.content)
}
