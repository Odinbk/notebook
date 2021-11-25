# Jenkins权限管理

Jenkins默认的权限管理能力比较弱，不支持创建分组，没有角色的概念。 Jenkins支持LDAP用户管理，我们可以利用LDAP的分组概念，结合Role-Based Authorization Strategy Plugin提供的角色概念，基本可以满足公司多游戏对Jenkins任务做隔离的需求。

## 权限配置

### 用户分类

* 匿名用户: 未登录Jenkins的用户。
* 登录的未授权用户: 通过LDAP登录了Jenkins，但是在Jenkins权限管理中未分配Jenkins Role。
* 授权用户: 通过LDAP登录了Jenkins，并在Jenkins权限管理中分配Jenkins Role。

### 角色分类

#### Global Role

* Admin: 拥有所有Jenkins操作权限。
* Guest: 只有最基本的访问权限.

![global_role](/CI/Walle/materials/jenkins_global_role.png)

![global_role_matrix](/CI/Walle/materials/jenkins_global_role_matrix.png)

#### Project Role

创建基于正则表达式的Project Role规则. 创建规则名称时以游戏名作为前缀，例如vega，vega-thomas. etc. 匹配模式可以根据需求编写正则表达式，Jenkins会以这个正则来匹配Jenkins任务名称。通常Jenkins任务命名中会包含游戏的名称，而且也应当做到游戏之间互相隔离。所以匹配模式中包含游戏名字是较好的实践。例如: .*vega.*

![setup_project_role](/CI/Walle/materials/jenkins_setup_project_role.png)

![project_role](/CI/Walle/materials/jenkins_project_role.png)

![project_role_matrix](/CI/Walle/materials/jenkins_project_role_matrix.png)

需要特别注意的权限控制是`任务`类中的`Workspace`, 分配了该权限意味着拥有权限的人可以在Jenkins页面上可以访问任务的Workspace目录内容，该目录下往往会有项目的代码检出。非项目组成员一定不能配置项目的Workspace权限。

#### Slave Role

暂时未使用

### LDAP用户组

#### 区分LDAP组织单元和组的概念

* 组织单元以树的方式组织，一个用户只能存在于组织架构中的一个组织单元内。例如Tom是技术中心 -> TSD -> DevOps组织中的一员，那Tom就不能同时是技术中心 -> TSD -> Ops组织的成员。
* 组的概念是独立于组织架构的，一个用户同时可以在多个组中。例如Tom同时是产品开发，和业务运维组的成员。

#### 创建组

1. 以管理员身份登录[LDAP Admin](http://172.16.153.80/ldapadmin/index.php), jenkins用户组创建在`ou=jenkins`组织单元下。

![jenkins](/CI/Walle/materials/ldap_jenkins.png)

2. 点击`Create new entry here`, 选择`Generic: Posix Group`模板。

3. 输入组名，选择用户加入当前组，点击`create object`完成操作。

![create_group](/CI/Walle/materials/ldap_create_group.png)

* 组命名: 组命令遵循{项目名称}-{功能分组}的命名规则，例如：vega, vega-release等。

#### 添加/删除组用户 

1. 在左侧的树形结构中选择要编辑的用户组，点击`modify group members`

![edit_group](/CI/Walle/materials/ldap_edit_group.png)

2. 从组中添加/删除用户，保存修改。

![edit_group_member](/CI/Walle/materials/ldap_edit_group_member.png)

#### 权限分配规则

* release组例如vega-release用作Jenkins任务审批放行，访问敏感资源。项目组策划，前后端主程，项目QA负责人可以添加到该组中。
* 游戏名直接命名的通用组例如vega在Jenkins上会配置相对小的权限，只能查看任务执行状态，访问一般数据。项目成员都可以添加都该组中。

### 权限申请

发邮件给devops@youle.game, 抄送项目负责人, 说明是否有编辑Jenkin Job的需求。