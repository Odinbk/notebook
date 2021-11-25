
# Vega 数值，Lua热更新方案讨论

## 包的格式

* VegaLua: `vega/version/VegaLua/{tag}/LuaPatches`
* Config: `vega/version/Config/{tag}/NumericPatches`

## 发布流程

1. 项目组组织好要热更新的文件（文件名中保留时间戳，格式：{module_name}_{timestamp}.7z. eg. Config_1577245548.7z)
2. 通过WallE提供的热更新功能页面，选择发布类型: production, gray etc. 构建热更新包。
3. WallE生成打包任务，任务完成后自动上传热更新包到FTP, OSS等文件存储。
4. 走天梯流程发布热更新。 热更新包会解压缩，覆盖到当前线上版本的指定目录下，（路径参考`包的格式`）推动到集群所有的机器上。
5. GameServer监控当前线上版本的指定目录下，（路径参考`包的格式`）， 当发现有文件更新时，加载热更新，通知客户端更新。

## PS

* WallE上之前提供的GameStatic，Patch功能保留，还会被用到。
* WallE提供独立的热更新功能入口。
* 热更新包现由项目组提供。


{"deployment_environment_id":"14","name":"xxxx","patch":"xxx","desc":"xx",
  "launcher":[{"conditionList":[{"condition":"FROM_VERSION","operator":"==","conditionValue":"1216"},{"condition":"FROM_VERSION","operator":"==","conditionValue":"1216"}]}]}

{"deployment_environment_id":"14","name":"xxx","type":"bool","default":"xxx","desc":"xxxx",
"launcher":[{"value":"xxx","desc":"xxx","conditionList":[{"condition":"FROM_VERSION","operator":"==","conditionValue":"1216"}]},{"value":"xxx","desc":"xxx","conditionList":[{"condition":"FROM_VERSION","operator":"==","conditionValue":"1216"}]}]}