
##

### VMS

* DK, Vega都需要更新。

### Walle

* 要传给Pipeline所有的历史版本, 包含灰度，审核，正式所有历史版本的配置结，包含当前线上版本。
* 最小可升级版本不需要了, 用途。
* 确认兼容版本计算是否和最小可升级版本有关。
* job_config中发布类型的配置可以统一放到一个配置结下。
* 选择哪些版本可以更新上来。

### eve

* cd config
* 

### 打包脚本



## DK6月11号想测试运维流程，和宋飞跟进何时出包。


### 目标

* 监控
* 灾备

## 监控

* 系统级
* 应用服务
* 业务服务
* 业务层面需求

## 展现

* promethus + grafana
* 分部式的Promethus部署。

6月中旬到位


WARNING:website.api.v1:Adding module tag failed with error: (MySQLdb._exceptions.IntegrityError) (1062, "Duplicate entry '22-DKClient#Assets#WorkAssets#26725' for key 'unique__module_id__tag'") [SQL: 'INSERT INTO module_tag (module_id, tag) VALUES (%s, %s)'] [parameters: (22, 'DKClient#Assets#WorkAssets#26725')] (Background on this error at: http://sqlalche.me/e/gkpj)