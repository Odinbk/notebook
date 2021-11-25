# 新版Walle UI

## 部署机器

### 线上机

* ssh user00@172.16.153.114 topjoy

### 测试机

* ssh root@172.16.153.53  topjoy

## 数据库

### Walle数据库

#### 线上数据库

walle
* mysql --host=172.16.153.114 --port=51000 --user=walle --password=kOqR0Pp8n2

* 跳板机到数据库部署机器
mysql -u root -p  --socket=/data/home/user00/service/mysql_work//51000//mysqld.socket
OPS@topjoy.com

* vega_mtl_cache 账户
CREATE USER 'tp_cache'@'' IDENTIFIED BY '599e6d0c';
GRANT ALL ON vega_mtl_cache.* TO 'tp_cache'@'';

#### 测试数据库

walle
* mysql --host=172.16.152.100 --port=36911 --user=root --password=password

### RC数据库

#### 测试数据库
rc

rc_url: dk_demo@jenkinsrc-test.youle.game::dk_demo/
rc password: 5JHkPOzz

dk_resource_center
* mysql --host=172.16.152.100 --port=36911 --user=root --password=password


#### 线上数据库
rc

rc_url: vega@jenkinsrc.youle.game::vega/
rc password: OFfE4DHn

db1
* mysql --host=172.16.153.114 --port=51000 --user=walle --password=kOqR0Pp8n2

## Jenkins

jenkins.youle.game

* 172.16.152.20  root/youle

jenkins-ci.youle.game

* jenkins home 目录: /data/jenkins/jenkins_home
* 因为jenkins 用起来感觉比较慢，目前172.16.153.76 上的 jenkins 换成了 java -jar 的方式
* 如果它挂了，用 /data/jenkins/start-by-java.sh 启动
* 用于WallE请求Jenkins API的账户 jenkins_deploy/zfwgdSftNnrs token可能有一年有效期的限制。
* jenkins-ci 升级到了较新的版本，迁移到了. 172.16.153.41 从跳板机连接


## Resource Center jenkinsrc.youle.game

* http://172.16.153.52
* ~172.16.153.52   root/topjoy~
* ~172.16.153.53   root/topjoy~
* 172.16.152.18, 172.16.152.19, 172.16.152.20
* rsync服务 状态查看/启动/重启/停止 对应命令
* systemctl status/start/restart/stop rsyncd
* gohttpserver 是从web 上查看rc 上文件的静态文件server。现在只在 172.16.153.52 上做了部署

gohttpserver 启动命令
/opt/gohttpserver/start.sh

gohttpserver 停止命令
kill $(cat /opt/gohttpserver/gohttpserver.pid)

### RC Command

https://git.youle.game/TC/TSD/DevOps/dune/wikis/%E8%BF%90%E7%BB%B4%E6%96%87%E6%A1%A3/ResouceCenter-%E7%9B%B8%E5%85%B3%E6%9C%8D%E5%8A%A1%E5%92%8C%E6%8B%93%E6%89%91

### RC Design

https://git.youle.game/TC/TSD/DevOps/dune/wikis/%E8%BF%90%E7%BB%B4%E6%96%87%E6%A1%A3/resoucecenter-mount-machine-configration

## RunDeck

* http://rundeck.youle.game:4440/project/walle4/execution/show/118#output
* admin   JDePGRHhbG

## EVE Upgrade

pip install -e git+https://git.youle.game/opensource/eve.git#egg=eve
pip install -e git+https://git.youle.game/opensource/eve.git#egg=eve
pip install git+https://git.youle.game/opensource/eve.git@install_test#egg=eve
git+git@git.youle.game:opensource/eve.git#egg=eve

## Dep

### Walle

创建Jenkins Job, 项目仓库挂钩子， 触发打包，管理项目构建资源，上传CDN(Thomas)等。

* https://git.youle.game/TC/TSD/DevOps/walle4

### Eve

python基础库，md5签名，压缩，等前后端打包工具。

* https://git.youle.game/opensource/eve/

### DK-Pipeline

CICD构建流程仓库，前后端公用。

* https://git.youle.game/opensource/eve/


### Topjoy邮箱设置

* 服务器名称: smtp.partner.outlook.cn
* 端口: 587
* 加密方法: STARTTLS

### JIRA

* host：172.16.153.130G
* username: root
* pwd：youle.game

### 更新git仓库公用的账号

devops      zdwgdZyt1


### DK SVN账号

dk_deploy 7PKcZyt10
vega_deploy cjtdkya1gde


### LDAP

* http://openldap.youle.game:8000/ldapadmin/cmd.phpp
* 172.16.153.80:389
* cn=admin,dc=youle,dc=com
* aeo12()aewf

### Gitlab admin personal access token

* JSL641tsmbacTFE6NB29

### SVN

Testing: svn://cicdsvn.youle.game/
172.16.153.95     /data/svn_project/authz
测试svn 上的这个文件可以控制用户权限。生产环境的得找ops

### resource center database账号

* walle kOqR0Pp8n2
* dkrc  lAFR7PN8Q5
* vegarc  s9fY79N9Qf


### Grafana

* http://gra-test.youle.game:3000/login
* admin / 123456

### 打包机打开VNC服务

https://apple.stackexchange.com/questions/30238/how-to-enable-os-x-screen-sharing-vnc-through-ssh


### K8s Dashboard

#### 地址

https://k8s.youle.game/#!/log/walle4/walle4-b888598d4-cg4l4/pod?namespace=walle4

#### 令牌

eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJkYXNoYm9hcmQtYWRtaW4tdG9rZW4tenNoOG0iLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoiZGFzaGJvYXJkLWFkbWluIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiNmNmZmIzNjItYjA0NS0xMWU4LTg2ZjMtMjQ2ZTk2MDdiM2VjIiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50Omt1YmUtc3lzdGVtOmRhc2hib2FyZC1hZG1pbiJ9.CnWOB-k5MecFaZOaNT2rGUVoo0v48ay5Ge1uERexlZY1VGT7j444M4Kjc5WzCqgC3L3Bxo5rGELGIvivXq6If_Ik5aUHwsV7ai-cbEfWpMhHyPMSEs-nVxbChyyLPJWZDrYjnkkZAP_mMxFhJ0iebQHf_Hc0jd4vHeinD7QQE_Px44NpW6J818gfOR_pb--CIzrnDgo_PvoG2LxwchfGUGBRqGmZ3x8S-eM_Ah4spiG7IG_rdHWTXCnqThA-AQQWlmJG_ScEgP89pFoed4U-BqhSQqpYWwBMYQJ6O66tUSeUHK2bCRDfKskAe0Z9nOuEArEWabZOmK69JSNwX6AgjA

rsync -avzP --relative /Users/jenkins/jenkins_home/shared/workspace/payment-pipeline_meta/pipeline_meta-meta/.develop/./backend/pipeline_meta payment@jenkinsrc.youle.game::payment/develop/ --password-file=rc.secrets
rsync -avzP --relative /Users/jenkins/jenkins_home/shared/workspace/payment-server/server-GIT/DKPaymentServer/target/./backend/server/* develop/ --password-file=rc.secrets


#### DK大神圈腾讯OSS

* http://lwcs2cdn.dashenq.com
* secret_id = AKIDOccNwGYDsKXWGmM3pMfiV3LOBqHUgDiz
* secret_key = A5k9KFuJSLzNUN1PXP1NTJuFKPFpAF4f


#### ansible推送代码脚本

* ansible-playbook -i inventory/topjoy_cmdb.py game_tools.yml --extra-vars="exec_hosts=dk_HWTestA branch=test"
* hosts 支持通配符。
* branch 默认master

tools脚本推送方法：
1. 登陆跳板机，进入/tmp目录
2. git clone git@git.youle.game:TC/TSD/OPS/craft.git your_dir_name
3. cd /tmp/your_dir_name/ansible
4. 执行 ansible-playbook -i inventory/topjoy_cmdb.py game_tools.yml --extra-vars="exec_hosts=[project_cluster] branch=[branch]"
5. 推送多集群 vi inventory/topjoy_cmdb.py 把hosts:的值改成所要推送集群的名字
比如
- hosts: 
  - dk_HWTestA
  - dk_HWTestB
  gather_facts: yes
  remote_user: root
  roles:
    - prometheus
然后执行 ansible-playbook -i inventory/topjoy_cmdb.py game_tools.yml --extra-vars="branch=[branch]"


bash -c 'ssh topjoy@172.16.170.102 cmd /c "java -jar D:/jenkins_home/slave.jar -text 2>D:/jenkins_home/slave.junk.txt"' 

ssh topjoy@172.16.170.102 /bin/bash -c 'cmd /c "java -jar D:/jenkins_home/slave.jar -text 2>D:/jenkins_home/slave.junk.txt"' 
