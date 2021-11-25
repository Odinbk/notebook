# GGG 客户端CI

* Assets，数值在SVN仓库；Lua，C#在Git仓库。
* Assets和数值单分支开发。
* Assets和数值表经过MTool转换成Lua的产出在Git中同步，开发在开发期有完全的资源可以开发测试。
* Lua 和 C#代码也在SVN同步，策划在开发期也有完备的资源可以预览效果。
* Git 和 SVN之间的同步项目组有脚本完成。
* 依赖的MTool，CI脚本代码都在Git中，对MTool和CI脚本的修改会随着Git到SVN的同步，同步到SVN中。
* 项目组对数值表有验证脚本，需要装载到Unity. CI完成后，需要有一个后继任务将转成的Lua提交回SVN。
