# Vega

### 接入时间点

* 3月初开始

### 任务清单

#### Walle

* 从CMDB同步Vega游戏信息
* 从CMDB同步部署位置信息 （未开发, 二月底前完成）
* Vega RC用户读写文件权限，挂载点。
* RC HTTP Server权限控制 (未开发, 二月底前完成)
* Jenkins权限控制。Slave隔离。
* 注册Module，升级序列。配置升级序列和部署位置的关系

#### 服务端

* 编写jenkinsfile, Makefile
* 确定Zookeeper文件格式。
* vage pipeline-meta （ZooKeeper配置文件管理）, pipeline-build（cd python脚本）, pipeline-workflow(天梯相关脚本).
* 改造game，global等后端服务，改从Zookeeper读取配置。
* 接入新的Notice和VMS
* 同时维护2条打包分支，代码管理相关。

#### 客户端

* 前端模块的pipeline.py和Profile。
* 创建vega-pipeline仓库, 创建和前端相关的CD脚本
* 编写jenkinsfile, Makefile
* 客户端增量式更新
* Mtool
* 图片资源增量转换
* 客户端新版VMS，Notice接入.

#### Vega已接入老打包系统，但新系统还不支持的功能

* 灰度发布 (近期设计，3月底前完成)
* GameStatic，Patch （计划中, 二月底前完成）
* Apple审核服 （计划中, 二月底前完成）
* 服务端热更新 (未上线)


#### 

* 打包系统单独部署

### 

* Dune仓库的权限
* vega-pipeline权限
* vega仓库需要给jenkins_deploy添加reporter权限。
* 孙亮在SVN中创建检出vega代码的账户
* 后端打包机安装docker和检出docker image的账户

### 打包机信息

ssh topjoy@172.16.170.8 
密码 topjoy
域名：cicd1.vega.youle.game

SVN 账户

90016 vega_delpoy cjtdkya1gde


###

* 升级序列和部署位置相关的文档
* 添加升级序列页出错
* MTool迁移到Docker
* 打包机前端打包依赖Java1.8， 后端依赖Java10.
* RC要拆分给Vega的数据库
* DK RC数据库需要配置权限保护
* Walle提供接口获取RC数据库配置信息


### 打包机配置

#### docker配置相关

* 打包机上安装docker
* 创建jenkins账户，账户密码都为jenkins
* 设置jenkins账户为管理员: `dscl . -append /groups/admin GroupMembership jenkins`
* 切换到jenkins账户
* 已jenkins用户重新启动docker
* 将jenkins的workspace在docker preference中添加到file sharing里，重启docker
* 后端项目需要在~/.m2下放一份公司依赖包配置settings.xml
* 前端项目用到mtool工具的需要在~/下放一份公司依赖包配置 mtool给不同项目组的配置文件 config.xml, 源头可以从mtool代码仓库中找到。不同项目配置不同。
* 将docker的路径注册到~/.bash_profile 
* 用项目组专用LDAP账号登录registry-dev `docker login registry-dev.youle.game -u wallevega -p f3ef66b0`
* docker 拉取需要的镜像，如果速度非常慢的话可以在官方镜像名前加上mirror.youle.game，镜像会缓存在公司的内网镜像地址。eg. docker pull mirror.youle.game/python

#### jenkins-slave配置

* 下载JDK8 https://download.oracle.com/otn-pub/java/jdk/8u202-b08/1961070e4c9b4e26a04e7f5a083f551e/jdk-8u202-macosx-x64.dmg, 在slave上完成java1.8的安装。
* 登录到jenkins master， 分发公钥给slave. `ssh-copy-id jenkins@{slave ip address}`
* 以管理员身份登录jenkins，添加凭证。jenkins > 凭证 > 系统 > 全局凭证 > 添加凭证。先看看是否存在已经配置好的jenkins主从凭证，(名字为jenkins)，授权方式为SSH Username with private key。不存在的话配置一个。私钥从jenkins master的~/.ssh/id_rsa获得。
* 配置jenkins slave节点。jenkins > 系统管理 > 节点管理 > 新建节点。 [阅读文档](https://git.youle.game/TC/TSD/DevOps/dune/wikis/%E8%BF%90%E7%BB%B4%E6%96%87%E6%A1%A3/Jenkins-slave-configration)
* 在Slave节点配置中设置PATH环境变量，指向必要的软件执行目录，如：docker，python等。


#### 安装Python3

#### 新的打包机上不一定有.bash_profile文件，source代码要检查。

#### Walle Toolkit的依赖安装

#### 配置resource_center_database 和 resource_center_authorication 中的数据.

#### 测试用的RC地址并不能反映到真正的RC存储地址，RC环境需要真正隔离.

#### 新接入的打包机需要配置jenkins_eploy账户的ssh公钥, jenkins_deploy账户用于检出git仓库的代码，接入CI的git仓库需要给jenkins_deploy账户分配reporter权限。

#### 用户jenkins检出svn代码的账户vega_deploy需要提前创建，在jenkins上注册凭据，测试工作正常。

#### 不能在Docker中执行的编译过程，依赖python，需要在打包机上提前安装virtualenv，实现环境隔离。

#### 安装XCode, 可能会遇到：xcode-select: error: tool 'xcodebuild' requires Xcode, but active developer directory '/Library/Developer/CommandLineTools' is a command line tools instance. https://stackoverflow.com/questions/17980759/xcode-select-active-developer-directory-error
https://www.jianshu.com/p/04033964f600

#### 打包机环境上MTool如何准备，jenkins执行shell命令 eve中的-i-l 等参数设置.

#### Trouble Shooting

* Jenkins 任务报错，docker command not found:
1. 任务指定docker命令时， 显式打开交互模式， source ~/.bash_profile中的配置。并在~/.bash_profile文件中添加docker运行位置（which docker）到PATH中。
     cmd = [ '/bin/bash', '-i', '-c', 'source ~/.bash_profile; docker run --rm -v ~/config.yaml:/config.yaml -v $(pwd):/input registry-dev.youle.game/mtool/mtool:dk_mtool.r20181216.01 \ mtl export_config -i /input -l /input/ci_output/lua -j /input/ci_output/temp -J /input/ci_output/json' ]
     subprocess.call(cmd)

2. 在jenkins或者jenkins slave节点配置中显式添加PATH环境变量，将docker执行位置添加到PATH中.

3. org.tmatesoft.svn.core.SVNException: svn: E155021: The path '/Users/jenkins/jenkins_home/workspace/vega-Config/Config-dev-profile_vega_android' appears to be part of a Subversion 1.7 or greater
-- 在jenkinsfile中执行 svn upgrade升级svn客户端。

### 后端CD

1. 配置全部从ZK读取，后端代码可用ZK的数据生成游戏的配置.
2. 胡笳和贤蛟定义ZK存储MQ信息的格式.
3. 胡笳和孙亮同步，天梯将MQ的账号密码刷入ZK.

### 安装eve遇到snappy的问题

1. macos 通过brew install snappy安装好snappy
2. https://github.com/andrix/python-snappy#frequently-asked-questions 设置pip的编译参数.
3. export CPPFLAGS="-I/usr/local/include -L/usr/local/lib"


### 打包机设置电源管理，避免休眠导致的ip地址不可用


### Assets任务由于TP licence授权个数的原因，需要特殊配置，限制并发任务的数量。

* https://github.com/jenkinsci/throttle-concurrent-builds-plugin/blob/master/README.md

### 打包机上需要安装7z.

### 要运行vegaC的任务的机器上需要装CCache

### 将docker假如开机启动项，添加守护进程，意外退出自动拉起。

### 停电维护后，检查jenkins slave有没有多余的异常节点出现。