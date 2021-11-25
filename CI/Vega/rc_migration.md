
* MTool只负责资源转换，不再上传转换的结果。
* CI流程需要修改，在调用MTool处理资源前从新RC的 RC_ROOT/{Game}/develop/cache 目录下把Cache文件同步到打包机Cache目录。MTool从Cache目录读取Cache，处理资源。资源处理完成后调用eve提供的Rsync接口上传产出物到RC_ROOT/{Game}/develop/frontend中，并同时上传打包机cache目录到 RC_ROOT/{Game}/develop/cache, resource_center数据库创建cache表，记录cache记录(是否需要).
* MTool计划迁入容器中，不依赖打包机上安装的MTool。所以不会有打包机上安装多个版本MTool的需求，也不用新加打包机。
* 预处理老RC中的Cache到新的RC，预处理期间产生的新Cache文件在CI的过程中更新.
 