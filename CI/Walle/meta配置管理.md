# Meta配置管理

腾讯CMDB接口获取的数据包括两部分：

1. 业务服务信息，包括资产的IP，所属的集群，业务模块名称。
2. 区服信息，包括区服的id，以及和相关连的应用服务信息。

腾讯CMDB不维护，但是我们需要的配置：

1. 业务服务和区服的对应关系。例如哪些区服连接到哪些GameServer等。

## 面临的问题

1. 业务服务和区服的对应关系通过pipeline仓库中的meta文件手动维护。
2. 服务配置规则不一致，例如GameServer和区服的关系是通过section to server配置，而WorldServer和区服的关系正好倒过来，是server to section。
3. 懂业务的开发不清楚线上机器的状态，知道机器状态的运维不了解业务，更改配置文件容易出错。

## 方案

1. 统一维护业务服务和区服对应关系的配置。下面是简单讨论后整理的配置格式例子草稿，最终格式还得等讨论后决定。

```json
{
  "Game": [
    {
      "name": "Game",
      "id": "9.150.61.1",
      "sections": [8001, 8002, 8003]
    },
    {
      "name": "Game",
      "id": "9.150.61.2",
      "sections": [8004, 8005, 8006]
    }
  ],
  "World": [
    {
      "name": "World",
      "id": "9.150.61.145",
      "services": [
        {
          "name": "Match",
          "sections": [8001, 8002, 8003],
          "functions": ["GASP", "WORLD_ARENA"],
        },
        {
          "name": "Guild",
          "sections": [8001, 8002, 8003],
          "functions": ["GUILD"],
        },
        {
          "name": "GLOBAL_HALL",
          "lines": [],
          "functions": [],
        }
      ]
    }
  ]
}
```

2. 项目组定义业务服务和区服匹配的规则，DevOps编写规则解释器生成配置。
3. 创建验证规则，验证生成的配置合法性。
