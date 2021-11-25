# CI/CD Meeting notes

## 2018-11-15

## attentees

汪凡，潘宇频，孙亮，曲宁，申富轩，胡笳，杨光，Jacky，阎杨将，尹力炜，刘斌。

## Topics

* 热更，滚动跟新，CI / CD。
* 确定职责。
* 目标：减少沟通成本，用新技术替换现有的技术栈； 天梯转Jenkins。
* 启动时间： 下周一。
* 刘斌项目负责人，杨光负责组织和实施敏捷开发的一些工作。
* 从DK入手。
* 交接调整工作。调整工位。


## 2018-11-16

* 从痛点出发
* 解决实际问题
* 发布打包部署
* 理顺流程
* 关注3D项目
* 数值表的联调， 产品热更新
* Jenkins定义流程，替换瓦力中的worker部分
* 3D客户端的热更新，SDK接入，接口化，透明。
* 整体的集成环境。
* 和项目组沟通需求。单元测试做到什么的程度。联调的环境，版本的匹配。

* 线上， 开发， 测试， hotfix， 灰度分开

## 

1. 用WalleUI触发Jenkins，去掉Git-Params的依赖。
2. 构建过程从哪里触发，是从CI的产出开始还是从源代码开始。
3. WalleUI中可不可以不存动态参数。
4. Jenkins Slave需要支持K8s，VM，要支持Windows和MacOS；项目组自己的机器注册到Jenkins master作为Slave节点。
5. 集中管理的配置仓库，可能包括：JenkinsFile，K8s编排文件，Meta配置，PyTask等。
6. 优化PyTask流程，把可以挪到相应代码从库中处理的部分提取出去。
7. 产出的结果在ResourceCenter上如何管理，目录规划分类，归属要明确，避免出现运维和开发都不知道用途的文件或目录，需要产出文档。
8. Git-Meta中配置职责划清。
9. 统一的python启停脚本。切版本的脚本，统一多版本目录结构。Python3。
10. K8s云维护。
11. 客户端整理python task。

## 开发测试周会

* Nginx 配置目录权限，控制项目组之间访gitbook.
* Retrospective
* 早会时间太长，讨论单独找人
* 不相关的人可以随时走


curl -X GET https://jenkins-ci.youle.game/view/vega/job/vega-gameServer/job/generate_reload_package/config.xml -u jenkins_deploy:11b732770f38eb9957a7c599b1366aea42 -o config.xml

curl -X GET https://jenkins.youle.game/view/vega/job/vega_server/config.xml -u yangguang:11daaaf227f443ed735351c4016c05281a -o config_view.xml

curl -s -X POST 'https://jenkins.youle.game/createItem?name=testtesttest' -u yangguang:11daaaf227f443ed735351c4016c05281a --data-binary @config.xml -H "Content-Type:text/xml"

curl -X POST https://yangguang:11daaaf227f443ed735351c4016c05281a@jenkins.youle.game/job/testtesttest/build --data-urlencode '{"parameter": [{"name": "gitlabBranch", "value": 123}]}'

curl -X POST https://yangguang:11daaaf227f443ed735351c4016c05281a@jenkins.youle.game/job/testtesttest/build --form file0=@/Users/Guang/Downloads/config.xml --form json='{"parameter": [{"name":"harness/Task.xml", "file":"file0"}]}'

curl -X POST https://yangguang:11daaaf227f443ed735351c4016c05281a@jenkins.youle.game/job/testtesttest/build --form file0=@/Users/Guang/Downloads/config.xml --form json='{"parameter": [{"name":"Task.xml", "file":"file0"}]}'

curl -X POST https://jenkins.youle.game/job/testtesttest/build --form file0=@/Users/Guang/Downloads/config.xml --form json='{"parameter": [{"name":"Task.xml", "file":"file0"}]}'

curl http://jenkins/job/$JOB_NAME/build -F file0=@PATH_TO_FILE -F json='{"parameter": [{"name":"FILE_LOCATION_AS_SET_IN_JENKINS", "file":"file0"}]}'

curl -X POST https://yangguang:11daaaf227f443ed735351c4016c05281a@jenkins.youle.game/job/test_job/build --form file0=@/Users/Guang/Downloads/config.xml --form json='{"parameter": [{"name":"Task.xml", "file":"file0"}]}'

curl -X POST https://yangguang:11daaaf227f443ed735351c4016c05281a@jenkins.youle.game/job/testtesttest/build  --form file0=@/Users/Guang/Downloads/config.xml --form json='{"parameter": [{"name":"harness/Task.xml", "file":"file0"}]}'

curl -X POST https://yangguang:117572d087ace2ef388434b28cf899732d@jenkins-ci.youle.game/job/hook-test/build --data-urlencode '{"parameter": [{"name": "gitlabBranch", "value": 123}]}'

curl -X POST https://yangguang:117572d087ace2ef388434b28cf899732d@jenkins-ci.youle.game/job/svn-hook-test/job/hook-test/buildWithParameters --data-urlencode '{"parameter": [{"name": "repos", "value": "xxx"}, {"value": "xxxxx", "name": "rev"}, {"name": "token", "value": "awesometoken"}]}'


curl -X POST https://yangguang:11daaaf227f443ed735351c4016c05281a@jenkins.youle.game/job/test_job/build --data-urlencode '{"parameter": [{"name": "test", "value": "aewrrqe"}]}'

curl -X POST https://yangguang:11daaaf227f443ed735351c4016c05281a@jenkins.youle.game/job/test_job/build  --data-urlencode json='{"parameter": [{"name":"test", "value":"123xxx"}]}'

curl -X GET http://172.16.153.95:8080/job/dk_demo-WALLE/job/__WALLE-walle__/config.xml -u yangguang:1177d471d4a10abe72b15cf39768db2ba2 -o config.xml
