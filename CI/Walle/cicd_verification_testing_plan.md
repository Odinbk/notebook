# 验收测试

## 测试环境

* Walle：http://172.16.153.114:5001 
  * 测试分支：walle_verification
* Jenkins：http://172.16.153.95:8080/
* RC：https://jenkinsrc-test.youle.game/


## 前置步骤

### Client

* [x] 把DK的SVN仓库拷贝到测试SVN
 * [x] 复制游戏代码
 * [x] 复制Pipeline脚本
* [x] Unity项目手动触发一次CI，目的是将代码Checkout到Jenkins Workspace. 
* [x] 打包机上将Unity工程切换到Android Platform

### Server

* [ ] 独立的vms notice服务。
* [x] git仓库切CICD_DEMO_BRANCH分支。
* [x] Tag以 CICD_DEMO_TAG开头将会触发测试环境的Jenkins任务。

### Walle

* [x] 测试用的Walle站点
* [x] 测试用的MySQL，准备测试数据.
* [x] 测试用的memcache docker
* [x] 注册Module
* [x] 注册升级序列

### Resource Center

* [x] 测试用的RC

### Jenkins

* [x] 测试用的Jenkins
* [x] 创建代码仓库钩子
* [x] 创建cd job

### 新的部署位置

* [x] 孙亮创建测试用的部署位置CICD.

```
CICD集群已经初始化完毕，信息为
集群名称CICD
外网IP： 118.31.37.113  内网IP：10.5.0.86  
mongo：10.5.0.86:31000
redis: 10.5.0.86:41000
zookeeper: 10.5.0.86:58000

global地址 http://dk-cicd.topjoy.com:8810/
vms地址：http://dk-cicd.topjoy.com:8800/
notice地址：http://dk-cicd.topjoy.com:8804/

cdn包下载地址：http://lwcs2cdn.dashenq.com/cicd/

集群id：82
platform id：76
game id ：8
```

## 测试用例

* 手动覆盖常用的测试用例。

### 测试用例
1. Case 1，前后端同时发布
   * 各个模块分别触发CI流程
   * Walle UI同时发布客户端和服务端
   * 发布上线（天梯，托马斯）
   * 客户端安装包下载、安装、正常进游戏
   * 假设客户端版本号C-1
2. Case 2，只发布客户端
   * 客户端改动一点lua代码和资源，走CI
   * Walle UI只发布客户端，勾选生成更新包
   * 发布上线
   * 用Case1的客户端重进游戏，测试热更是否正常
   * 假设客户端版本号C-2
3. Case 3，只发布服务端
   * 后端做一些改动
   * Walle UI只发布服务端
   * 发布上线
   * 用Case2的客户端可以进游戏，正常玩耍
4. Case 4，只发布客户端，禁止C-1版本更新
   * 客户端做一点改动，走CI
   * Walle UI只发布客户端，同时勾选生成安装包和更新包，minimum_upgrade_version选C-2
   * 发布上线
   * 用C-2版本客户端进游戏，可以正常更新进入游戏
   * 用C-1版本客户端进游戏，被拒绝热更，必须下整包
   * 此时客户端版本C-3
5. Case 5，服务器兼容版本测试
   * 保持C-3版本客户端在游戏中
   *  客户端做一点改动，走CI
   * Walle UI只发布客户端，选择不踢用户下线，同时打安装包和更新包，假设此时客户端版本号C-4
   * 发布上线
   * 上面的C-3版本可以正常游戏，没有被踢下线
   * 安装C-4客户端，可以正常登陆
6. Case 6，客户端跨多个版本更新测试
   * 安装C-2客户端，可以正常更新到C-4，并进入游戏
7. 其他后端和发布系统相关的Case请轩总补充
