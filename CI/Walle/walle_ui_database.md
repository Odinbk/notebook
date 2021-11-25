### modules

CREATE DATABASE walle;

CREATE TABLE walle_job (
  id INT not null auto_increment primary key,
  game_id INT not null,
  deployment_id INT not null,
  server_version_version_id INT,
  client_version_version_id INT,
  online_server_version_version_id INT,
  create_time DATETIME,
  job_config JSON
);

CREATE TABLE deployment (
  id  INT not null auto_increment primary key,
  game_id VARCHAR(50) not null,
  name VARCHAR(50),
  cluster_id  SMALLINT,
  platform_id TINYINT,
  global_url VARCHAR(500),
  cdn_url VARCHAR(500),
  notice_server_url VARCHAR(500),
  vms_server_url VARCHAR(500)
)

CREATE TABLE game(
  id INT not null auto_increment primary key,
  name VARCHAR(50),
  pipeline_repo_project_id SMALLINT,
  pipeline_repo VARCHAR(100)
);

CREATE TABLE module (
  id INT not null auto_increment primary key,
  game_id INT,
  is_client_module TINYINT,
  is_server_module TINYINT,
  module_name VARCHAR(20),
  tag VARCHAR(100),
)

CREATE TABLE version (
  id  INT not null auto_increment primary key,
  version VARCHAR(20),
  <!-- is_client_module TINYINT,
  is_server_module TINYINT, -->
  create_time DATETIME
)

CREATE TABLE version_module_tags (
  id INT not null auto_increment primary key,
  module_id INT,
  version_id INT,
)

CREATE TABLE upgrade_path (
  id INT not null auto_increment primary key,
  game_id SMALLINT,
  name VARCHAR(100),
  is_enabled TINYINT
)

CREATE TABLE upgrade_path__profile (
  id INT not null auto_increment primary key,
  upgrade_path_id INT,
  module_id INT,
  profile_name VARCHAR(100),
  FOREIGN KEY fk_upgrade_path(upgrade_path_id)
  REFERENCES upgrade_path(id)
  ON UPDATE CASCADE
  ON DELETE RESTRICT
)

CREATE TABLE deployment__upgrade_path (
  id INT not null auto_increment primary key,
  deployment_id INT,
  upgrade_path_id INT
)

CREATE TABLE deployment__version (
  id INT not null auto_increment primary key,
  deployment_id INT,
  version_id INT,
  is_compatible_with_server TINYINT,
  is_deployed TINYINT,
  is_online TINYINT
);

<!-- CREATE TABLE compatible_client_versions (
  id INT not null auto_increment primary key,
  deployment_id INT,
  verison_id INT
) -->


<!-- create table upgrade_path-profile (
  id INT not null auto_increment primary key,
  upgrade_path_id INT,
  path_id INT,
  version_id INT
) -->

<!-- create table target (
  id INT not null auto_increment primary key,
  upgrade_path_id INT,
  minimized_package TINYINT,
  full_package TINYINT
)

create table target (
  id INT not null auto_increment primary key,
  upgrade_path_id,
  client_upgrade_packages SET,
  server_upgrade_packages SET,
  installation_package TINYINT
) -->

<!-- create table module_tags (
  id INT not null auto_increment primary key,
  module_id INT,
  tag VARCHAR(100),
  FOREIGN KEY fk_cat(module_id)
  REFERENCES modules(id)
  ON UPDATE CASCADE
  ON DELETE RESTRICT
) -->

CREATE TABLE install_package (
  id INT not null auto_increment primary key,
  deployment_environment_id INT,
  upgrade_path_id INT,
  version_id INT,
  package VARCHAR(100) CHARACTER SET utf8 COLLATE utf8_bin
);

CREATE TABLE update_package (
  id INT not null auto_increment primary key,
  deployment_environment_id INT,
  upgrade_path_id INT,
  from_version_id INT,
  to_version_id INT,
  packages VARCHAR(4096) CHARACTER SET utf8 COLLATE utf8_bin
);

CREATE TABLE compatible_version (
   id INT not null auto_increment primary key,
     deployment_id INT,
     server_version_id INT,
     client_version_id INT,
  FOREIGN KEY fk_compatible_version_deployment(deployment_id)
  REFERENCES deployment(id)
  ON UPDATE CASCADE
  ON DELETE RESTRICT
);

ALTER TABLE deployment
ADD FOREIGN KEY fk_deployment_deployment_environment(deployment_environment_id)
REFERENCES deployment_environment(id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

    module_id = Column(Integer, ForeignKey('module.id'), nullable=False)
    project_id = Column(SMALLINT)
    branch = Column(String(100))
    project_root = Column(String(200))
    hook_directories = Column(String(200))
    repo_address = Column(String(100))

CREATE TABLE repository (
  module_id INT not null,
  project_id INT,
  branch_name VARCHAR(64),
  project_root VARCHAR(256),
  hook_directories VARCHAR(256),
  repo_address VARCHAR(128),
  PRIMARY KEY (module_id, branch_name),
  FOREIGN KEY fk_repository_module(module_id)
  REFERENCES module(id)
  ON UPDATE CASCADE
  ON DELETE RESTRICT
);

INSERT INTO repository (
   SELECT id,
   gitlab_project_id as project_id,
   gitlab_branch as branch_name,
   svn_project_root as project_root,
   svn_hook_directories as hook_directories,
   repo_address
   FROM module);

ALTER TABLE module DROP COLUMN gitlab_project_id;
ALTER TABLE module DROP COLUMN gitlab_branch;
ALTER TABLE module DROP COLUMN svn_project_root;
ALTER TABLE module DROP COLUMN svn_hook_directories;
ALTER TABLE module DROP COLUMN repo_address;

ALTER TABLE svn_diff_mapping
ADD COLUMN repo_address VARCHAR(100) NOT NULL;


DKClient_release/Assets/Scripts,DKClient_release/Assets/Plugins
svn://svn.youle.game/dk/DKClient_release/Assets/Scripts

DKClient_release/Assets/WorkAssets
svn://svn.youle.game/dk/DKClient_release/Assets/WorkAssets

class CompatibleVersion(Model, SQLAlchemyCRUD, ToJSON):
    __tablename__ = "compatible_version"

    id = Column(Integer, primary_key=True, nullable=False)
    deployment_id = Column(Integer, ForeignKey('deployment.id'), nullable=False)
    server_version_id = Column(Integer, nullable=False)
    client_version_id = Column(Integer, nullable=False)

mysql --host=172.16.152.100 --port=36911 --user=root --password=password

def find_index(list_num, target):
  for index, value in enumerate(list_num):
      if value == target:
        return index

  return -1

def find_intersection(nums1, nums2):
  return set(nums1).intersection(nums2)

def max_continuous_sub_sequence(nums):
  max = 0
  max_start = max_end = 0
  i = j = 0

  while j < len(nums):
    while i < j:
      if sum(nums[i:j]) > max:
        max = sum(nums[i:j])
        max_start, max_end = i,j

  return max_start, max_end



# Walle上线CheckList

## CI

- [x] 服务端CI流程与Jenkins联调
- [x] 客户端CI流程与Jenkins联调

## CD

- [x] Walle触发CD流程的Jenkins任务
- [x] 服务端CD流程与Jenkins联调
- [ ] 客户端CD流程与Jenkins联调 (Pipeline脚本已经完成，周一需要最后验证一下)

## 托马斯

- [x] 托马斯脚本开发
- [ ] 配置触发托马斯脚本的Jenkins Job

## 天梯上线

- [x] 根据Walle 生成的CD流程yaml配置文件生成ZooKeeper配置
- [x] 天梯服务器启停脚本

## Walle

- [x] 基本功能开发
- [x] 部署环境准备: python，mysql
- [ ] 在新环境上部署Walle和数据库，于测试环境隔离。

## Jenkins

- [x] Jenkins基础环境
- [x] Walle注册Module生成Jenkins主Job

## Retrospective

* jenkins job 中传递了大量明文信息，这些信息都是可以从walle中通过game name查询到.
* 打包机上Eve更新问题.
* 已经触发过CI的Tag应该Fail Gracefully，给出容易判断的错误状态。

* vms, global按照module前缀匹配，按照分支名做过滤，只触发对应分支的任务。
* 除开vms和global，其他仓库忽略分支信息，一个module， 一次构建，生成一次个构建文件。
* Vega的VMS Fork了代码仓库，属于特例，以后处理。
* 环境变量大小写要统一。
* Jenkins Job中的Shell脚本需要单独拿出来，版本管理，在Job中动态获取。
* Gitlab 由tag触发钩子时，gitlabSourceBranch并不是分支而是Tag名。在类似VMS和Global这种需要匹配分支的仓库会导致匹配不正确。这个问题需要后续解决.
* Jenkins构建的速度比预期的慢很多.
* Jenkinfile 中需要指定slave node，最好能由ops自动分配.

## 上线情况

- [x] Walle上线: website + database迁移
- [x] RC数据库迁移
- [x] DK后端模块CI接入
- [x] DK后端模块CD接入
- [x] DK前端模块CI接入 / Luascript / AssetBundle / DataConfig / C#
- [x] DK前端模块CD接入 / 已联调完成，安装包可以生成. 前端资源RC路径需要调整.
- [x] 托马斯脚本
- [x] 天梯脚本
- [ ] 测试流程，热更，等。和项目组确认。DK项目组测试计划安排。1.4出包给渠道， 1.10号公司内测， 1.21匿名测试.
