# 切换DK Notice到Online_Version Service

## 准备工作

### OnlineVersion Service

  a. bin已经发给孙亮
  b. 启动命令：ov -http.port 8804 -zk.host 127.0.0.1 -zk.port 58000 -log.file /var/log/online_version/online_version.log
  c. 服务存活检查命令：
  d. md5 ov ==> 4ed7d0c8be69ecc476085d164549fe1b

### Walle

* 代码更新，测试.

### DK

* 更新Notice的代码，去掉获取online version的接口。

### 天梯

* 检查现有脚本，添加Reload Notice的步骤。
* 手动部署OnlineVersion Service

## 上线步骤

* 部署时间：下周一，2019-03-25
* 参与者：张旭君，孙亮，杨光，胡笳(看自己安排)

1. 先行把OnlineVersion Service部署在DK的所有部署位置上：CCBA，CCBO，dev1，TDev，FDev, CICD, 并启动服务。
2. Walle下线。
3. 合并Walle[代码分支](https://git.youle.game/TC/TSD/DevOps/walle4/merge_requests/158)
4. 更新Walle线上数据库Schema. 命令: flask deploy
5. 部署代码，启动在5003端口测试，测试没问题后在5000端口上重启。
6. 更新vega pipeline的requirements.txt, 换成从eve master分支安装。

