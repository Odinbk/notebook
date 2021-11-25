# 接入Walle打包系统Step By Step

一款游戏软件打包需要经历几个阶段:

1. 代码编译，美术资源处理。
2. 打包代码和资源在一起。

这个过程可能会持续数小时。事实上将代码和资源打包在一起最多几分钟就可以完成，而代码编译/美术资源处理会用掉大部分的时间。就像准备一桌酒席一样，炒菜做饭本身是很快的，而前期的买菜，洗菜，准备食材等前期工作会用掉绝大部分的时间。

要是前期的准备工作在平时就准备好，打包时直接从编译过的代码/处理过的资源开始，打包会非常的快。

软件工程中的CI/CD （持续集成，持续发布，持续部署）实践正式来解决这个问题。每当有代码提交到代码仓库，会自动触发CI流程：对代码进行静态/风格检查，执行自动化测试，构建软件包，制作软件docker镜像等一系列过程。产出的软件包/docker镜像在软件行业成为Artifacts（产出物）。

新的打包系统基于CI/CD的实践：项目接入标准流程的CI过程，减少维护成本； 打包过程从CI产出的Artifacts开始，缩短打包的时间。

## 准备工作

### 和DevOps/专家组沟通打包需求

新的打包系统的设计是基于统一的CI/CD流程，统一的好处不用多说，代价是需要在灵活性上做一些折中。在接入前和DevOps/专家组快速同步打包需求非常有必要 -- 打包系统对项目组的需求添加功能，项目组为接入打包系统做适当的调整。沟通的点包括不限于一下内容:

* 项目代码组织方式，代码管理工具， 分支管理策略。美术资源管理，管理工具。划分功能模块。
* 准备打包机。Linux or Mac/Windows. Docker or virtualenv. 一台 / 多台。
* 打包频率
* 腾讯驻场系统平行迁移。

## CI接入

### 打包机配置

1. 申请打包机，根据资源构建特点决定打包机类型。例如3D项目依赖Unity做资源转换，所以需要Mac/Windows打包机。一般后端资源打包在Linux上就可以完成。
2. 打包机配置jenkins账户。CI/CD系统依赖Jenkins做任务调度，为了方便的水平扩展任务容量，我们采用Jenkins的master-slave模式。Master节点上只负责任务的调度和轻量任务的执行，较重的CI和打包任务都通过slave label的方式派发到Slave节点上执行。因此，打包机事实上作为Jenkins的Slave阶段存在的。Jenkins操纵Slave是通过SSH（我们选择 Username + private key）的方式，所以需要在Slave上创建专门的**管理员**账户，并将Master上的SSH公钥推到各Slave节点上。

  - MacOS
    * 创建jenkins账户，密码需要告知DevOps。
    * 设置jenkins账户为系统管理员. 
    ```shell
    dscl . -append /groups/admin GroupMembership jenkins
    ```

  - Linux
    ```shell
    useradd -u 1000 jenkins
    echo jenkins | passwd --stdin jenkins
    mkdir -p /data/jenkins/jenkins_home
    chown -R jenkins.jenkins /data/jenkins
    ```
3. 安装必要的软件

  切换到步骤2创建的jenkins账户安装一下软件。

  - Java8

    - MacOS

      - 安装
        [Oracle JDK]( https://download.oracle.com/otn-pub/java/jdk/8u202-b08/1961070e4c9b4e26a04e7f5a083f551e/jdk-8u202-macosx-x64.dmg)

    - Linxu

      - 安装
        ```shell
        tar zxvf jdk-8u181-linux-x64.tar.gz -C /opt
        ```
      - 验证
        ```shell
        /opt/jdk1.8.0_181/bin/java -version

        java version "1.8.0_181"
        Java(TM) SE Runtime Environment (build 1.8.0_181-b13)
        Java HotSpot(TM) 64-Bit Server VM (build 25.181-b13, mixed mode)
        ```

  - Python3.6.5 

    - 注意
      - Python和Python相关的模块包禁止sudo安装。

    - MacOS

      - 安装
        [Offical Package](https://www.python.org/ftp/python/3.6.5/python-3.6.5-macosx10.9.pkg)

    - Linux

      - 安装
        [参考](https://docs.aws.amazon.com/zh_cn/cli/latest/userguide/install-linux-python.html)

  - Docker & Docker-Compose

    - 安装
      [参考]( https://docs.docker.com/install/linux/docker-ce/centos/#install-using-the-repository)

    - MacOS上需要将jenkins的workspace目录添加到docker perference -> File Sharing中。
    - 如有访问公司镜像仓库Harbor的需求，请docker login {harbor address}。地址，账号请联系DevOps。

  - VirtualEnv

    由于Jenkins通过Label可以调度任何任务到匹配的Slave上，所以Python执行环境的隔离非常重要。Docker不能满足的场景我们用VirtualEnv实现Python环境隔离。

    - 安装
    ```shell
    pip3 install virtualenv
    ```
4. 注册打包机为Jenkins Slave节点

  - 登录到jenkins master， 分发公钥给slave. ssh-copy-id jenkins@{slave ip address}
  - 以管理员身份登录jenkins，添加凭证。jenkins > 凭证 > 系统 > 全局凭证 > 添加凭证。先看看是否存在已经配置好的jenkins主从凭证，(名字为jenkins)，授权方式为SSH Username with private key。不存在的话配置一个。私钥从jenkins master的~/.ssh/id_rsa获得。
  - 配置jenkins slave节点。jenkins > 系统管理 > 节点管理 > 新建节点。 [阅读文档](https://git.youle.game/TC/TSD/DevOps/dune/wikis/%E8%BF%90%E7%BB%B4%E6%96%87%E6%A1%A3/Jenkins-slave-configration)
  - 在Slave节点配置中设置PATH环境变量，指向必要的软件执行目录，如：docker，python等。

### 项目组

项目组需要在代码/资源仓库下添加下列文件定制资源的构建过程。

* Jenkinsfile
  Jenkins通过执行Jenkinsfile中定制的流程实现构建过程的流水线。Jenkinsfile同时做为DevOps和开发组职责的接口: Jenkinsfile中只配置流程，不实现具体的逻辑。 Jenkinsfile通过调用make命令执行构建逻辑。
  从CI/CD仓库中获取一份Jenkinsfile的模板，参考其中的说明完成配置。[Jenkinsfile模板](https://git.youle.game/TC/TSD/DevOps/dune/blob/master/example/Jenkinsfile.example)
* Makefile
  Makefile中实现CI构建流程中每个步骤的具体实现。调用外部命令，串起整个流程。复杂的步骤可以在pipeline.py中实现。
  从CI/CD仓库中获取一份Makefile的模板，参考其中的说明完成配置。[Makefile模板](https://git.youle.game/TC/TSD/DevOps/dune/blob/master/example/Makefile.example)
* _continuous_integration_delievery
  该目录是一个和打包系统约定的目录，在不确定影响的情况下不要删除或变更文件名。否则会导致CI过程无法正常触发/执行。
  * pipeline.py是一个单独的python module，实现复杂的build和文件上传resource_center等逻辑。该文件不需要重头写起，专家组在[eve](https://git.youle.game/opensource/eve)仓库中已经封装了许多通用的逻辑。项目组应该复用eve中提供的功能来实现自己的构建等逻辑。
  * profile.yaml文件用来配置参数以实现一次代码提交，并发构建多平台/渠道/语言的需求。文件可以配置前缀区分不同目的，但一定要以profile.yaml作为后缀，这样CI/CD才能正确识别该文件。

### CI/CD系统

CI/CD系统通过webhook建立Jenkins和代码仓库之间的联系。当代码仓库在CI/CD中注册为Module后，系统会根据配置自动建立Jenkins和代码仓库之间的webhook。每当代码仓库上有触发事件发生(GIT上有新tag生成；SVN上有新的Commit提交)时，webhook会通知Jenkins执行相应的Job。

#### GIT

在正式提交Tag触发webhook前，请确认被触发的代码仓库中为jenkins_deploy这个账户配置了reporter权限。jenkins_deploy账户是Jenkins用来检出代码特殊账号，已提前在Jenkins中创建好了凭证。它只需要检出代码的权限(reporter)即可，CI/CD系统不会通过该账户提交任何代码到代码仓库。

#### SVN

由于SVN没有实现webhook功能，所以我们自己实现了svn_hook_service用来通过编程实现在svn仓库中添加/删除/查看hook的功能。目前只操作post-commit hook。
svn_hook_service是一个web服务，需要提前部署在svn server所在的服务器上。
实现原理: 

1. 检查指定地址的svn路径下的hooks目录下是否存在post-commit hook。如果不存在，创建；如果已存在，重命名该hook为post-commit.backup，并创建新的post-commit hook。
2. 创建post-commit.d目录，将post-commit.backup hook存入该目录。（为了防止CI/CD系统创建的hook影响项目组自己配置的hook，会将项目组的hook备份）
3. post-commit.d目录中创建Initialized标记文件，标记该仓库已经执行过初始化操作。避免步骤2被重复执行。
3. 每当post-commit hook被触发时，它会遍历post-commit.d下所有的hook文件，并执行触发。

svn_hook_service实现了list接口方便查看hook创建情况。
```
list

http://svn.youle.game:8080/hooks/list

headers = {'Content-Type': 'application/json'}

body = {'project': {game_name}}

response = {
    "data": {
        "post-commit.{hook suffix 01}": {hook content},
        "post-commit.{hook suffix 02}": {hook content},
    }
}
```

在项目接入时，OPS会为项目创建项目只读的svn账号，账号模式为: {game_name}_deploy。该账户会被配置在Jenkins任务中用于svn仓库代码的检出, CI/CD系统不会通过该账户提交任何代码到代码仓库。

## Artifacts(产出物)存放/管理

CI/CD阶段产出的Artifacts通过Rsync同步到CI/CD系统的资源管理系统Resource Center. Resource Center使用Ceph网络存储，理论上有无限的存储空间和高可用。Ceph上挂载一个Linux docker容器实现打包机和Ceph的文件同步。

前端的资源有增量更新的特点，为了避免相同的资源在Resource Center冗余存储的情况，Resource Center有独立的数据库记录文件和内容签名的映射关系。该功能为可选，eve工具库中封装了文件映射的逻辑。

* [Resource Center HTTP Server地址](https://jenkinsrc.youle.game/). HTTP Server用于调试和结果验证，包的不应该从Resource Center直接分发。包的分发在Thomas部分会详细说明。
* Resource Center按照项目开辟了隔离的空间，为RSync配置了独立的操作账户，对每个项目组可用的空间设置限制，目前为1T。
  * 创建项目空间和RSync账户的工作是一个定时任务，定时访问CMDB API检测是否有新的Game创建。RSync账户信息存入Walle的数据库，通过环境变量的方式分发给项目组的CI/CD任务。后续会加入敏感信息脱敏的功能。
* Resource Center会有基本的权限验证和资源隔离，项目组之间的不可以互相访问各自的空间。-- 正在实现中。

## 打包脚本

| 施工中

## Thomas分发

上传包到CDN/FTP的功能已经从独立的系统变为CI/CD系统的一项功能。当打包成功后，会自动触发Thomas的Jenkins任务，上传母包到CDN/FTP。

* [Thomas Jenkins任务](https://jenkins-ci.youle.game/view/thomas_upload/job/thomas_upload/)
* 项目组完成CD脚本前，联系DevOps配置Thomas需要的相关信息。

## 天梯发布/运维流程

| 施工中

* 运维脚本
* 服务启停脚本

## Jenkins任务

CI/CD系统提供了统一的Jenkins服务来承载公司游戏项目的CI和打包需求。采用Jenkins Master-Slave的拓补方式应对容量的水平扩展。

### 任务组织/任务隔离

Jenkins任务通过项目名称隔离，例如DK项目相关的任务都会归类到dk的view下。相同项目的任务根据在Walle上注册的Module归类到对应的目录下，根据不同的分支再归类到对应的view下。

[Jenkins地址](https://jenkins-ci.youle.game/) 使用LDAP账户登录（登录gitlab的账户）。

项目归类示例:
![项目归类](/CI/Walle/materials/game_isolation.png)

模块归类示例:
![模块归类](/CI/Walle/materials/job_isolation.png)

### 权限隔离

由于Jenkins任务在执行过程中会输出详细的执行过程日志，日志中难免有项目相关的敏感信息，所以Jenkins任务需要项目级别的权限隔离。

通过Jenkins接入LDAP，和Role-Based Authorization Strategy插件实现项目级别的权限隔离。具体细节可以参阅[文档](https://git.youle.game/TC/TSD/DevOps/dune/wikis/jenkins_authorization)

### Notes

* CI/CD系统使用的Jenkins和用来跑单元测试/接口测试的Jenkins目前是两套独立的系统。
* 项目组在接入阶段调试测试用的Jenkins可以联系DevOps获得。