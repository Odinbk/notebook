# WallE公网部署

## 项目调整

* WallE支持配置多个jenkins地址。
* WallE支持注册，展现如jenkins api token，rsync账户等敏感信息。
* Thomas代码从WallE仓库剥离出来成独立的仓库。
    * 代码打包到pypi，Thomas自身接入CI/CD，代码通过测试直接发布到pypi，更新版本号。
    * Thomas的配置文件由Apollo管理，Apollo已经是外网服务。
    * 使用Thomas，从gitlab下载源代码改为从pypi安装。
* eve, pillar, walle_toolkit (一个脚本，判断jenkins任务是否满足触发条件。)
    * 代码打包到pypi，接入CI/CD，代码通过测试直接发布到pypi，更新版本号。 
    * 从pypi上安装，用nexus做本地cache。
* SVN Hook service改为由WallE触发的Jenkins任务，取消常驻服务。
* 天梯执行的Tools运维脚本由北京仓库统一维护，发布，流程和其他游戏没差异。

## 对接流程

* 内网环境，根据区域部署独立的Resource Center (+Web浏览?) + RSyncd, nexus， jenkins master。
* RSyncd创建用于RSync读写的账户，注册RSync地址，账户信息到WallE。
* jenkins创建凭证，注册jenkins地址，凭证到WallE中。
* WallE中创建对应的游戏数据库，ResourceCenter数据库。
* CI/CD接入，天梯运维脚本编写。
* 集群的相关信息添加到CMDB，初始化，集群信息变更由Ops完成。

## 问题

* 对打包机和初始化有一些要求，例如：操作系统Mac OS，依赖Docker，Python等。 
* CI和打包阶段需要使用Docker，是否搭建私有化的docker repository。
* 项目如何管理后端配置，是否使用Meta的机制。
* 游戏版本的管理依赖VMS，打包系统也依赖VMS，所以VMS必须接入。VMS变更如何交付给第三方。
* 是否接入签名服务。
* 是否有内网DNS服务，暴露给WallE的是URL还是IP+Port。
* 内网部署环境的监控/告警，例如Resource Center，Jenkins，打包机等。
* 项目仓库的组织方式，git/svn, 是否使用了LFS。如何划分模块，如何进行热更新，是否支持线上开关，补丁 （switch & patch）。
