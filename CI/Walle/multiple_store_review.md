# 打包系统支持多审核服

## 现状

### Pipeline

引用了eve中的ReleaseType枚举
会影响到

1. Gray, AppStore Review, Production, 之间交叉打包的逻辑。

### eve

1. 生成ZK中/version配置结下版本相关配置
2. 从WallE传递给pipeline的配置文件中获取线上版本信息的逻辑。

### tools

自己定义的ReleaseType枚举

1. 从ZK中读取/version配置结下版本相关配置

### VMS

1. 根据客户端请求中的ReleaseType从ZK中获取版本相关数据，生成升级路径。

### Walle

自己定义的ReleaseType枚举

1. 获取线上版本信息
2. 传给pipeline历史版本信息的逻辑
3. UI上的显示

## 方案

1. DK审核服方案改为分部署位置，避免发布的global，vms操作和正式服互相影响。
2. Walle中维护ReleaseType的配置，下游链路中只是使用传递的值，不做特殊逻辑判断。
    * 例如交叉打包，审核和正式之间也会生成交叉包。
    * 是否可以逆向更新通过另外的字段控制。
3. 项目组自定义审核服，创建/更新/删除 审核服不需要修改代码。
4. 审核切正式不需要发版本
5. 兼容Vega，TKW，尽量做最小的改动。

## 设计

### 支持多个审核服和多个灰度服

* 审核服部署在独立的部署位置，和正式服的部署位置物理分离。使用不同的ZooKeeper，Global；审核服的VMS指向正式服的地址，在Walle上手动配置。
* 灰度服和正式服部署在同一个部署位置，公用相同的，ZooKeeper，VMS，Global。
* 独立的数据库表记录ReleaseType: 灰度服的信息通过Walle提供的页面录入，审核服的信息从CMDB同步，名字和部署位置名称保持一致。
* ReleaseType的名字只能是字母，不支持数字和下划线。
* ZooKeeper中的数据格式需要做调整。
    以下配置结下的{release_type}从固定的[production, gray, appstore_review]调整为动态的值。
    * /version/{release_type}
    * /history/versions/{release_type}
    原来的
    /{release_type}/version/
    /{release_type}/servers/
    配置结调整为以下格式
    * /release_type/{release_type}/clients/['c-1', 'c-2']
    * /release_type/{release_type}/servers/[1,2,3]
    Global和VMS获取数据的逻辑需要做简单调整，首先通过区服id，或者客户端版本，遍历上面的节点，查到对应的release_type，再根据release_type从其他配置结下动态获取数据
* eve中交叉打包的控制逻辑提前到Walle中判断，通过打包参数控制eve的交叉打包逻辑。
* eve, tools, pipeline，vms，global等仓库中不再维护ReleaseType枚举。
