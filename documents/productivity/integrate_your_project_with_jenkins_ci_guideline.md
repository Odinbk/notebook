# 让您的项目支持持续集成

该文档将一步一步的指引你配置你的项目以支持持续集成。目前我们实现了自动化单元测试的部分，更多自动化类型如功能测试，接口测试，冒烟测试等会逐步支持。

## 开发流程的改变

项目中引入单元测试会对原本的开发流程有一点影响。主要可能有：

* 开发者要为自己的代码覆盖单元测试，覆盖率的问题我们会单独讨论 **# TO DO**。
* 要合并到协同开发分支(如master，develop，和release)的代码必须通过所有的单元测试用例。
* 要合并到协同开发分支的代码需要在gitlab上创建一个Merge Request，并要求至少一位同事Review该Merge Reqeust。
* Merge Request只有通过和自动化测试，通过Code Review并对Code Review的Comments达成一致方可合并。关于如何做Code Review我们会单独展开讨论 **# TO DO**。

## 为你项目的代码仓库添加以下文件

* Makefile

在项目的根目录下创建Makefile, 假如项目已经存在Makefile，请将`test`和`coverage`命令添加到Makefile中.
`make test`将作为Jenkins任务执行测试用例的入口。无论您的项目是Java，Python Django或者其它，只要在`test`命令里正确触发即可.
`make coverage`将作为Jenkins任务生成代码测试覆盖率报告的入口。

Java Maven项目的Makefile例子:

```makefile
   PROJECT_DIR:=$(CURDIR)
  
   test:
    cd ${PROJECT_DIR}/PROJECT_NAME && mvn test
  
   coverage:
    cd ${PROJECT_DIR}/PROJECT_NAME && mvn jacoco:report
  
   help:
    @echo "Usage: 'make <command>'"
    @echo " [Test]"
    @echo "test   test the entire project with command 'mvn test'"
    @echo " [Coverage]"
    @echo "coverage  generate the test coverage report with command 'mvn jacoco:report'"
```

* Jenkinsfile

在项目的根目录下创建Jenkinsfile, Jenkinsfile定义了Jenkins的工作流。在这个例子中，该任务会执行以下步骤：

1. **Prepare**, 调用Jenkins接口获取提前配置好的镜像仓库的账号和密码，并使用该账号密码登录`registry-dev.youle.game`. 为了避免在Jenkins以及其他公共机器上留下账号密码信息文件`docker.config`，我们选择了每个任务显示登录的方式。

2. **Lint**, 代码风格和静态代码检查阶段。从镜像仓库的lint目录下获取最新的lint检查镜像，执行`/root/lint/lint.sh`脚本。该路径是构建镜像时约定的地址，在dev_tools制作镜像时复制对应项目的lint.sh脚本到该目录下。

3. **Test**, 执行单元测试用例。首先从镜像仓库的unit_test目录中获取最新的测试镜像。执行`make test`命令触发单元测试。测试成功的话会在`post`事件中执行`make coverage`命令生成测试覆盖率报告源文件，并触发`coverage`任务统计和展现测试覆盖率。无论测试成功与否，都会讲本次构建的一些基本信息通过钉钉通知给相信的群组。放弃了使用发送邮件的方式，因为我们使用的163邮箱账号会不定期的被163封禁，理由是发送垃圾邮件。触发`downstream`任务统计`lint`检查结果，假如检查失败，将会导致本次构建失败并发送钉钉通知。

```groovy
#!groovy

pipeline {

    agent any

    environment {
        TEMP_DIR = "${sh(returnStdout: true, script: 'mktemp -d')}".trim()
        DIFF_FILES = "changed_files.txt"
        PMD_RESULT = "pmd.xml"
        REGISTRY_ADDRESS = 'registry-dev.youle.game'
        DOCKER_REG_CREDENTIAL = 'register-dev-harbor'
    }

    stages {

        stage('Prepare') {

            steps {
                script {
                    withCredentials(
                        [
                            usernamePassword(
                                credentialsId: DOCKER_REG_CREDENTIAL,
                                usernameVariable: 'DOCKER_USR',
                                passwordVariable: 'DOCKER_PWD'
                            )
                        ]
                    ) {
                        sh 'docker login -u=${DOCKER_USR} -p=${DOCKER_PWD} ${REGISTRY_ADDRESS}'
                    }
                }
                sh 'git diff --name-only ${GIT_COMMIT}..${GIT_PREVIOUS_COMMIT} -- "*.java" > ${TEMP_DIR}/${DIFF_FILES}'
                sh 'cat ${TEMP_DIR}/${DIFF_FILES}'
            }
        }

        stage('Lint') {

            agent {
                docker {
                    image 'registry-dev.youle.game/lint/centos_jdk10_pmd:latest'
                    args '-u root:root -v ${WORKSPACE}:/app -v ${TEMP_DIR}:${TEMP_DIR}'
                    alwaysPull true
                }
            }

            steps {
                sh 'echo "PMD static code checking"'
                sh '/root/lint/lint.sh'
            }
        }

        stage('Test') {

            agent {
                docker {
                    image 'registry-dev.youle.game/unit_test/maven_jdk10:latest'
                    args '-u root:root -v ${WORKSPACE}:/app -v ${TEMP_DIR}:${TEMP_DIR}'
                    alwaysPull true
                }
            }

            steps {
                sh 'echo ${WORKSPACE}'
                sh 'make test'
            }

            post {

                success {
                    sh 'make coverage'
                    build job: 'vega_server_coverage'
                }

                always {
                    build job: 'vega_server_downstream', parameters: [
                        string(name: 'PMD_RESULT', value: "${TEMP_DIR}/${PMD_RESULT}")
                    ]

                    sendDingTalkMessage()
                }
            }
        }
    }
}

def sendDingTalkMessage() {
    def dingTalkUrl = "https://oapi.dingtalk.com/robot/send?access_token=3c7ea4196ee7906e32153547ab8ece632bce45bf341a0c59a825e6755c0ca80c"
    def message = """
       {
           "msgtype": "markdown",
           "markdown": {
               "title": "Jenkins DingTalk Message",
               "text": "### [Jenkins Job]: The build ${BUILD_ID} for task ${JOB_BASE_NAME} is ${currentBuild.currentResult}\n* Job Name: ${JOB_BASE_NAME}\n* Job Status: ${currentBuild.currentResult}\n* Job URL: ${JOB_URL}${BUILD_ID}\n* Git Commit Id: ${GIT_COMMIT}\n* Git Commit Author: ${gitlabUserEmail}\n* Git Branch Name: ${GIT_BRANCH}\n* Git Source Home Page: ${gitlabSourceRepoHomepage}"
           },
           "at": {
                "atMobiles": [
                    "${gitlabUserEmail}"
                ],
                "isAtAll": false
           }
       }
    """

    def response = httpRequest acceptType: 'APPLICATION_JSON', contentType: 'APPLICATION_JSON', httpMode: 'POST', requestBody: message, url: dingTalkUrl

    println('Response: ' + response.content)
}
```

* Dockerfile

此处Dockerfile为可选，因为单元测试只对代码仓库和编译环境有依赖，所以不需要每次执行都构建全新的Docker镜像。在对功能测试支持以后则必须为单元测试编写Dockerfile以及docker_compose.yaml.

## 配置Jenkins持续集成任务

Jenkins地址：https://jenkins.youle.game

### 创建专属的Jenkins视图

1. 点击Jenkins主页右上角的 + ，创建一个新的视图. 将视图起名为和你的项目一样，以后方便寻找。勾选上`列表视图`选项，点击确定.
2. 在第二页上对试图添加必要的描述信息点击保存.

### 创建单元测试任务

视图地址: https://jenkins.youle.game/view/{project_view}/

1. 创建一个新的任务.
2. 输入一个任务名称，最好和你的项目名称一致。选择`流水线`类型后点击OK。
3. 为任务添加必要的描述信息。
4. 勾选`General`选项卡下的`参数化构建过程`, 添加一个`字符参数`. `名称`中填入 _gitlabBranch_, `默认值`填入 _master_. 可能你已经猜到了， 这个参数是gitlab的webhook传过来的代码分支信息，在后面的配置中将要用到它.
5. 勾选`构建触发器`选项卡下的`Build when a change is pushed to GitLab` 选项. 将GitLab webhook URL 后面的URL复制保存下来，后面的gitlab webhook配置会用到. 点击该选项下的`高级`按钮, 再点击`Generate`按钮。 将生成的`Secret token`复制保存下来，也是为了gitlab webhook准备.
https://jenkins.youle.game/project/{project_name}
548656d4422b4ead057ac4ff2c66e54c
6. 点击`流水线`选项卡, 选择`Pipeline script from SCM`. `SCM`选项中选择`Git`. 接下来的`Repository URL`中填入你项目的git地址(就是git clone的地址), 配置正确的`Credentials`直到红色警告消失。将`Branches to build`中的 _master_ 替换成 webhook 传入的git branch环境变量 _${gitlabBranch}_。 最后一步去掉最下面的`轻量级检出`的勾选。 关于`Credentials`项的配置如果有问题可以自行搜索解决。

至此，Jenkins单元测试的主任务配置完成。但现在任务还跑不起来，因为没有和gitlab做关联。

### 将Jenkins任务和gitlab通过webhook关联

1. 打开你项目的gitlab页面， 在左边的工具栏中找到`Settings` => `Integrations`。
2. 将`创建单元测试任务`中步骤5里保存下来的URL和Secret Token填入到对应的文本框中，点击`Add webhook`保存。
3. 在`Webhooks`表单中找到刚才创建的webhook。点击`Test` => `Push events`测试确认配置生效。

这一步完成后，Jenkins单元测试任务就可以工作了。每次有代码push到远端分支，该任务就会被触发执行。但是你必须到Jenkins任务页面上去检查任务执行完成，成功与否。接下来我们将配置下游任务来完成一系列通过插件完成的功能。

### 创建单元测试任务的下游任务：发送钉钉通知, 统计Lint检查结果等。

视图地址: https://jenkins.youle.game/view/{project_view}/

1. 在你的视图下创建另外两个Jenkins任务。任务名称必须和你在前面的Jenkinsfile中配置的任务名一样(任务分别以coverage和downstream结尾)，这样才能被上游任务正确触发。这次我们选择`构建一个自由风格的软件项目`类型，点击ok。
* 对downstream任务来说：
    同样的为任务添加必要的描述信息， 然后勾选`General`选项卡中的`参数化构建过程`。上游任务向该任务传递的环境变量由此处传入。 将Jenkinsfile中build job阶段的parameter依次添加完毕。
    * `Record JaCoCo coverage report`将选项中的文件路径配置为你项目的实际路径即可。
    * `钉钉通知器配置`请自行搜索配置。非常简单。

## 为您的项目添加单元测试

万事俱备，只欠为项目添加高质量的单元测试用例了。

## 提交Bug

* 关于此文档的任何问题请直接联系：yangguang@topjoy.com
