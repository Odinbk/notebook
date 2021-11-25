# 多仓库项目构建流程

### 创建独立的项目流程git仓库，用来触发多仓库项目的环境搭建和版本发布信息记录。我们称该项目为发布项目，包含：

1; Jenkinsfile，监听所有子项目是否有新的Master Tag发布。如果某子项目有新的Master Tag发布，触发Jenkins任务构建一套可以用于集成测试的环境。该环境由以下镜像构成:

* 新Master Tag发布的子项目，构建基于该Tag的镜像。
* 其他依赖子项目，选取当前最新的Master Tag镜像。

2; Deployment.{version}, 该文件记录了组成发布项目所有子项目发布时的Tag信息和镜像地址。例如：

    Deployment.V1.2.3

```json
      {
        'repo_01': {
          'master_tag': 'tag_01',
          'image': 'repo_01_image_address'
        },
        'repo_02': {
          'master_tag': 'tag_02',
          'image': 'repo_02_image_address'
        }
      }
```

3; 构建好的环境需要由QA测试，测试通过后为发布项目生成对应的Deployment文件并打Tag，用来触发线上部署任务。

4; 线上部署任务需要由相关人员放行后继续。

### 每个子项目都有独立的构建流程：

* 代码静态检查
* 单元测试
* 接口测试
* 构建镜像并上传

* 代码通过Code Review和自动化测试后合并master。
* 代码合并Master后触发Jenkins任务给Master打Tag。
