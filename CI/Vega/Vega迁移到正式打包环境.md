# 迁移计划

## 时间

* 计划本周5开始，预计在7月15日之前完成。

## 参与者

* 杨光，李栋梁，项目组各模块负责人。

## 前置条件

* ~~CICD和dtestreview集群可用，可以正常执行天梯流程~~。
* ~~验证eve `change_upgrade_strategy` 分支对DK项目无副作用, 合并入 `master`。~~
* ~~vega pipeline以及各模块仓库中的pipeline.py脚本，从eve提供的接口获取数据库连接相关信息，~~ requirements.txt中eve的依赖改为`master`。

## 流程步骤

* [DevOps] ~~在正式环境上创建Vega依赖的数据库: vega, vega_resource_center, vega_mtl_cache~~
  * ~~vega_resource_center.resource_center_authorization中配置了rsync用到的账号密码~~
  * ~~vega_resource_center.resource_center_database中配置了访问vega_resource_center, 和vega_mtl_cache数据库地址，账号密码。~~
* [DevOps] ~~Walle上配置为CICD， dtestreview等部署位置配置VMS，Global，Notice地址，配置thinking_sdk_app_id, lua_error_app_id。~~
* [DevOps] ~~Walle上创建升级序列，配置升级序列和Module， 升级序列和部署位置之间的关系。~~
* [DevOps] ~~Jenkins-CI上配置Vega打包机Slave。~~
* [DevOps] ~~Walle正式环境中创建Vega的所有模块。~~
  * ~~检查git和svn中，到正式环境jenkins的钩子被正确创建。~~
  * ~~jenkins父任务会自动创建出来。~~
  * ~~父任务中walle4_toolkit的分支改为 `vega_demo_branch_never_merge_to_master` (保证各模块仅master_ci分支可以触发CI任务)~~
  * ~~父任务指定运行在slave节点。~~
* [DevOps] ~~手动移除测试环境上配置的Git，SVN hooks，DevOps提前准备好脚本。~~
* [DevOps] ~~Jenkins-CI环境创建Vega CD，Hotfix任务到Jenkins-CI正式环境。~~
  * ~~检查CD和Hotfix任务中pipeline仓库分支为*/master_ci。~~
* [项目组] ~~触发各模块CI保证资源正确产出。~~
* [项目组] ~~触发打包任务，保证打包任务可以正常出包。~~
* [项目组] ~~天梯验证首次发布，前后端发布，仅前端发布，仅后端发布等常规流程。~~
* [项目组] ~~天梯验证灰度，审核流程。~~
* [项目组] 触发Hotfix任务，保证Hotfix任务可以正常执行。
* [项目组] `master_ci`分支合并到`master`
* [DevOps] 更新CD和Hotfix任务中pipeline仓库分支为*/master.
* [DevOps] 移除Jenkins-CI上父任务中walle_toolkit的特殊分支配置 (所有代码分支都可以触发CI任务)。

## 问题汇总

在验收测试过程中发现的问题都已经修复，以下是需要调整和后续跟进的问题

* 从OSS下载还是会失败
* CI和CD分开不同的群发送通知消息
* 灰度区和灰度服的对应关系维护在Meta中，由于对应关系配置错误导致的问题排查困难。
* 发布灰度版本流程中先重启Game，再重启VMS，会导致玩家在系统强制下线后重新尝试连接时前端卡死。调整了VMS和Game重启的顺序后问题解决。

## Walle功能验收跟进

在Walle验收测试中提出的功能优化基本都已经完成，以下是待完成的功能

* 版本号不变，任务号增1，重复打版本打包， (场景:只出了更新版本，但是后续想要这个版本的安装包)
* 版本必须要发布上线后，才可以进行更新，不能提前把版本都打出来做提前量（快速迭代也不方便）
  * Walle目前可以做到打包不依赖线上版本信息
  * 提前打包存在人为设定的版本号和自然打包生成版本号冲突的问题需要解决。


* 灰度区配置在CMDB中设置
* 灰度区和灰度服的对应关系在Meta中对应
* 1区和2区玩家由Global分配到了同一台Game
* 1区发布灰度版本，天梯流程操作灰度区的Game

* 先停game会导致玩家下线，玩家尝试重连会连接到未更新的VMS，导致返回了错误的数据。
* 应该先停VMS，再停Game。
