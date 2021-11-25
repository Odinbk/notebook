# Jankins 用户管理配置

## 背景需求

Jenkins在公司的持续集成和K8s迁移项目中起着重要的作用，为了达到灵活管理流程和避免因权限控制导致问题，我们需要Jenkins可以根据用户的角色（role）来对Jenkins管理的内容进行访问控制。
由于Jenkins的权限控制能力不足，例如不支持分组，不区分角色等。原生的权限控制不能满足我们的需求。经过调研，Role-based Authorization Strategy可以基本胜任。[Link](https://wiki.jenkins.io/display/JENKINS/Role+Strategy+Plugin)

我们需要：

* _放行指将挂起的Jenkins任务恢复，当然也可以取消_

1. Devops组有Jenkins的全部控制权限。
2. 各项目组QA可以对Relese分支的部署任务放行。
3. 项目组策划可以对Pre-Release分支的部署任务放行。

## 权限控制

Role-Based Authorizatio Strategy支持三级权限控制：

1. Global Role: 对Jenkins资源全局控制。
2. Item Role (Project Role)：对Jenkins Job精细控制到项目级别。
3. Node Role (Slave Role)：配置Node相关的权限。

## 方案

需求结合插件的功能，给出以下解决方案：

* 创建以下Global Roles
  1. admin：Jenkins资源的全部控制权。
  2. others： 视图的只读权限。
  Devops team成员给予admin权限，其他通过LDAP登录的用户给予others权限。
* 为每个项目创建Item Role：
  1. Item Role通过Jenkins任务的名字匹配到相应的任务。例如，名为K8s的项目创建K8s_Developer的Item Role，指定他的Pattern为k8s*，那么Jenkins中所有以k8s开头的任务控制权将有K8s_Developer Role来管理。
  2. 根据项目类型创建满足需求的Item Roles。
  3. 将Item Role按照需求分配给项目组成员。

## 步骤

* 系统管理 -> 全局安全配置 -> 授权策略。激活`Role-Based Strategy`。
* 系统管理 -> Manage and Assign Roles -> Manage Roles。
  1. 创建需要的 Global Roles。
  2. 创建需要的Project Roles。 Pattern为匹配任务名字的正则。（任务名暂定以项目名开头，全小写，方便编写Project Roles的Pattern）
  3. 根据项目的需求可以创建多个Project Roles。
* 系统管理 -> Manage and Assign Roles -> Assign Roles。
  1. 将DevOps组的成员加入到Global Roles，给予admin权限。
  2. Anonymous给予others权限。
  3. 项目组QA给予release权限，策划给予pre-release权限，开发者给予read-only权限。
