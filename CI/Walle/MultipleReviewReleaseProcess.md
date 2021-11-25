# 支持多审核服

## 多审核服设计方案

### 包结构

1. 单独的release文件，记录本次发包的release名称，例如：production，gray1，xiaomireview
2. config.zoo名称调整，修改为{release}.config.zoo，为了避免包在同一目录下解压缩，不同包之间互相覆盖的问题。

### 天梯调整

3. 刷新{release}.config.zoo到ZooKeeper的脚本，需要指定release的名称。
4. 发布版本时，校验传入的release名称是否和包中release文件中的名称一致，不一致的话退出版本发布，避免将不正确的{release}.config.zoo信息写入ZK，污染数据。
5. production版本发布的流程中添加步骤，把release文件中的release名称，写入到ZK /default_release配置结下。Global，VMS，Notice等没有灰度版本的服务从/prod_release读取release名称，进而从ZK中相应的release节点下获取module_tag等数据。审核，灰度发布流程不更新该值。

## 多审核服上线发布计划

由于支持多审核服方案的核心是ZooKeeper中数据结构的调整，GameServer, BattleServer, VMS, Global等模块读取数据的方式和地址都需要做相应的调整。
该部分讨论何时，如何更新代码，数据迁移等相关操作。

### ZooKeeper中的数据是否需要迁移

### 上线时间

### 上线流程

0. ~~清理HWReplicaA，HWReplicaB，HWReplicaC三个集群的ZK，Mongo和Redis数据库, 执行天梯流程，停止所有服务。审核服不启动battle。CMDB中删除Battle的配置~~
0. 修改天梯流程，在发布正式版本的流程中添加设置default_release的步骤，同步流程到所有的部署位置。（审核服和正式服的流程不同）
1. ~~WallE停机维护。~~
2. ~~eve multiple_review分支合并主干，依赖eve的dk-pipeline, pipeline, tkw-pipeline通过单元测试后合并主干。~~
3. ~~zdk_tools, vega_tools, tkw_tools, payment_tools, dk-pipeline, vega-pipeline, tkw-pipeline, payment-pipeline 合并master, OPS推送最新脚本到部署位置~~
4. ~~从CMDB同步部署位置信息，对部署位置做基本的配置，global，vms，notice，cdn url, ERROR_REPORT_URL 等。~~
4. ~~Walle 上配置调整: 取消原来的审核服关系，HWReplicaA，HWReplicaB, HWReplicaC调整为HWAndroid的审核服部署位置。（检查Vega，TKW是否存在审核服关系。）~~
5. 打包验证