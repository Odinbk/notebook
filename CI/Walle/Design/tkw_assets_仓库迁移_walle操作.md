## 迁移TKW Assets仓库， WallE相关操作

* disable luacode-client, scripts-client, work_assets-client模块。确认gitlab上相应的钩子正确移除。(1min)
* 编辑luacode-client, scripts-client, work_assets-client模块的project id，project address。保存。(1min)
* enable 这些模块，确认gitlab上相应的钩子正确创建。(1min)
* 备份打包机所有workspace下：luacode-client, scripts-client, work_assets-client工作目录。
* 触发三个模块的CI，验证CI流程正确。(120mins, 拉仓库可能会比较耗时。) 
* 删除打包机workspace下的备份目录，释放空间。