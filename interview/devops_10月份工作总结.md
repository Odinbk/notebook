# Devops组10月份工作总结

## 服务部署容器化

### K8s技术方案调研/测试

| 工作内容 | 成果 |
|-----|-----|
| 常用数据库如MySQL, MongoDB, Redis在K8s中性能测试。| 数据库应用的性能在K8s中会有不同程度的性能下降。 性能要求高的服务需要独立部署在kubernetes 外部或者通过使用更高读写效率的ssd 磁盘和更高带宽的网络设备来改善 |
| K8s性能测试：网络，磁盘IO，单Pod容器数量，服务性能测试。| 这会在单节点 pod 数量高到一定程度的时候主机间的网络效率不高，另外 Kubernetes 为了解决有状态服务的数据持久化，也会使用基于网络的分布式存储。因此 Kubernetes 性能对网络的要求比较高。单个Kubernetes node 可支持的 pod 数量官方默认值为 220，社区测试结果在 200 左右，如果要提升集群能支撑的负载能力，可以通过添加节点来解决；对于网络存储的网络效率，可以考虑使用更高速网络设备来解决。|
| K8s应用滚动更新，日志收集，数据表更新等方案。| 确定了滚动更新，日志收集的方案（目前有两种），在OMTools项目中已经实践。 确定数据表更新方案， 后续会在Vega的集成测试环境中实践。 |
| 多仓库项目K8s实施细节，仓库版本匹配方案。| Q3落地了单一仓库项目容器化(CMDB, UCenter), 10月份落地了多仓库项目 (OMTools)。 通过相关仓库约定版本号来实现代码兼容。 |
| 公司级别的镜像缓存 | 在公司的docker-registry缓存常用的公共镜像， 加速有docker image依赖的相关任务。|

### 容器化部署

| 工作内容 | 成果 |
|-----|-----|
| OMTools（新版GMTools）容器化部署 | OMTools已经完成容器化部署，对内提供服务。|
| DevOps培训资料，OPS培训。 | 为如何容器化一个项目编写了详细的文档，不容易用文字表述的步骤录制了视频。 为OPS和OMTools项目成员培训介绍了流程细节。 |

## 自动化测试

[自动化测试介绍文档](https://git.youle.game/TC/TSD/DevOps/dev_tools/wikis/technical_manual/software_develop_testing_process#2-%E6%8E%A5%E5%8F%A3%E6%B5%8B%E8%AF%95)

### 单元测试

| 工作内容 | 成果 |
|-----|-----|
| 为Vega编写单元测试用例 | 单元测试覆盖率在稳步提高，目前约10%的代码行，方法，类的覆盖率。[覆盖率报告](https://jenkins.youle.game/view/vega/job/vega_server_coverage/jacoco/) |
| 为Vega搭建持续集成环境 | 支持静态代码检查，提交代码触发单元测试，测试覆盖率报告，和测试结果钉钉通知。|
| 推进开发测试流程 | 推动vega项目组用merge request的方式开展code review。 |

### 接口测试

| 工作内容 | 成果 |
|-----|-----|
| 开发易用的接口测试框架 | 根据公司业务特点，利用服务端debug接口，开发很容易上手的接口测试框架。封装现有的JClint，发送同步请求。 利用Java Annotation实现了半申明式的用例编写。 [Drum接口测试框架](https://git.youle.game/TC/TAG/backend/drum)，对ncc及vega项目QA人员进行培训，完成Drum框架环境搭建及使用的wiki文档。|
| 构建基于容器化的测试环境 | 使用docker-compose来快速搭建用来支撑接口测试的测试环境。秒级启动，数据隔离，环境准备简单。 |
| 持续发布的Vega接口文档 | 使用脚本提取Vega代码中的ApiParam注解，自动生成gitbook接口文档。搭配Gitlab CI runner，实现持续发布。 |

## 其他

| 工作内容 | 成果 |
|-----|-----|
| 容器化LDAP部署 | 新的LDAP基于Docker部署，方便迁移和恢复。实现基于group的Jenkins权限管理. |
