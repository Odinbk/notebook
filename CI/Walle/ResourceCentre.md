## Resource Centre

/ResourceCentre 是存放资源文件的根目录。

### 目录规划

#### 方案1

在 /ResourceCentre 下，依据 `项目名称`, `资源类型` 创建子级目录，将对应的资源文件归类到相应的目录中。

~~~
  |_ResourceCenter
    |_项目名(或所有者)
        |_资源类型
          |_资源文件(文件以md5命名)
~~~

> 分子目录归类的方式，对于不同项目使用的相同资源会存储两份

资源文件存入时

* 计算文件的 md5，并以 md5 值作为文件名存储，同名文件只存储一份
* 存入前检查全局 md5 库，如果是已经存在的资源，则不存入 /ResourceCentre，使用已有副本的文件路径并记录新的元数据
* 存入同时将元数据（项目名，资源类型，资源文件原始名称，资源文件 md5 ，存放路径等）索引并存入资源文件数据库

#### 方案2

在 /ResourceCentre 下，直接存储自动构建产出的资源文件

```
  |_ResourceCenter
    |_md5
    |_md5
    |_...
```

> 不通过子目录对资源进行归类，对于不同项目使用的相同资源也只会存储1份，并且存入前避免查询全局 md5 库

资源文件存入时

- 计算文件的 md5，并以 md5 值作为文件名存储，同名文件只存储一份
- 同时将元数据（项目名，资源类型，资源文件原始名称，资源文件 md5，存储路径等）索引并存入资源文件数据库

#### 资源文件数据库

资源文件数据库不需要和资源文件存放在一起，可以作为单独的数据服务

以下是数据的定义，以 mysql 为例

> meta 表（数据示例，不代表最终设计）

~~~
"md5":"xxxx",
"path":"/repo/ab/xxxx",
"repo":"git.youle.game/repo/",
"hash":"ab3dfs2",
"jenkins_build_url":"https://jenkins.youle.game/job/omtools/job/develop/186/",
"jenkins_build_id":"158",
"resource_type":"AB",
"filename":"dk-xxxxx.apk"
"version":"v1.0.0",
~~~

### 工具需求1-自动构建

在资源的自动构建流程中，需要提供一个工具，将构建的产出的各类资源存入 ResourceCenter 的存储池，对于该工具的需求如下：

1. python 工具集接受输入的文件列表
2. （原子操作）上传文件到 /ResourceCentre，分类存放，存储以文件的 md5，保存元数据到数据库
3. 规则见方案1，2

### 工具需求1-项目组

该需求用来满足 项目组下载资源到本地的需求。因为资源文件提供了足够的信息，该工具/接口/UI 应该支持

* 根据构建信息提取生成的资源文件
* 根据 git 的hash（或 svn 的 reversion) 来提取资源文件
* 根据版本（如果有）来检索和提取资源文件

### jenkins注册测试脚本

```python
from op.jenkins.toolkit import register_project

pid = 650

view_name = 'test_view'

job_name = 'test_job'

vtp = 'view_template.xml'

vcp = 'view_template_context.yaml'

tp = 'gitlab_trigger_job_template.xml'

cp = 'gitlab_trigger_job_template_context.yaml'

register_project(pid, view_name, vtp, vcp, job_name, tp, cp)
```

http://nexus.youle.game
admin
admin123
