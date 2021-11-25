# 问题本

## 数值表

1. mtools上传转换后的数值表到git仓库.
2. 插件去除Java文件中没有用到的import

## 下周目标

1. issue估点 （不属于devops职责范围的内容，请在devops的kanban上创建issue，早会估点。）
2. 容灾，监控 （单独拆Kanban, 细化拆分任务）
3. 调试测试OMTools，正式切换到K8s
4. OMTools的日志收集，监控，达到可用的状态。
5. DK对外测试准备。12月6号。
6. K8s相关培训。
7. K8s编排插件。
8. Vega的集成测试环境。其他模块，ZK，RabbitMQ
9. K8s相关工具需求和开发。
10. 跟进OMTools实际落地，解决相关问题。
11. Jenkins迁移。
12. Gitlab在测试方向的调研。

## 备忘：

* mirror.youle.game 官方
* registry-dev.youle.game/ 自己制作

## Kubectl

hosts: 172.16.152.21: 10101/9101

* kubectl get namespace
* kubectl get pods -n vega-master
* kubectl get cm -n kube-system
* kubectl get cm -n kube-system tcp-services -o yaml
* kubectl logs -f vega-6d94569957-52nnt -n vega-master
