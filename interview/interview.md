# 面试题

## 开发语言

### C

* 类型转换。
* 数据结构。
* 指针。
* 字符串操作。
* C语言内存对齐。提前写一个结构。
* 判断链表是否有环。

### Java

* 访问控制器的作用和差别。
* 接口和抽象类，差别和作用。
* Array & ArrayList
* ArrayList 与 LinkedList 的区别。
* Overwrite & Override
* String & StringBuilder
* 并发和同步。多线程，锁。

### Python

* list, tuple, set, dict
* 迭代器（迭代器模式， 协议), python中哪些数据结构实现了迭代器模式.
* 生成器 (yield)
* 装饰器
* PEP8

## 设计模式

* 单例，策略，观察者，工厂，简单工厂，适配器，代理 等。
* 生产者 / 消费者。消息队列。
* 为什么使用单例，如何实现，接触过的库中哪些用到了单例。

## 数据库

### SQL

* CRUD
* Join
* Where & Having
* Hash Join, Loop Join, Merge Join
* 索引，簇级索引，非簇级索引，索引最左匹配原则，使用索引的优缺点，索引失效。
* 事务，原子操作。
* 锁库，锁表， 锁行
* 分表，分库

### No-SQL

* 了解的No-SQL有哪些。
* KV, Document。
* Redis 支持的数据结构。
* Redis 原子操作。
* Cache / Storeage, 持久化策略。Cache过期策略。Cache失效，击穿。

## 网络

* 网络分层模型
* TCP (握手，挥手，顺序保证，超时重试，拥塞控制，如何抓包分析，TIME_WAIT）
* UDP 和TCP的差别，哪些应用适合使用UDP
* HTTP 浏览器中访问知乎整个流程 (DNS, ARP, TCP / IP etc. GET / POST / etc.)
* HTTPS HTTPS过程

## 操作系统

* 用户态 / 内核态
* 线程
* 进程
* IPC
* 同步 / 异步
* 线程同步

## Linux

* Linux command
* 管道
* grep, sed, awk, cut, wc etc.
* 查找某进程，端口使用情况 (ps, netstat, lsof -i:port)。
* 日志分析
  1. 统计某时间段来自某ip的请求成功率。
  2. 持续统计日志中的某几列的数据
* 正则 (邮箱，ip etc.)
* Shell


## 算法与数据结构

* 堆，栈，数组，链表，二叉树，完全二叉树，满二叉树，平衡二叉树。
* 排序算法，快速，合并，插入，堆。
* 海量搜索query，找出查找频率最高的N个单词(1, 10)。
* 字符串翻转，字符串按单词翻转。
* 不引入第三个变量交换两个变量的值。
* 翻转单链表。
* 二叉搜索树。


## 测试

### 开放问题

通过开放型的问题了解面试者分析问题的思路，条理，面对巨大测试用例集合时做取舍。在团队合作中遇到分歧时如何处理。

* 测试一款软件，产品。 （手机，笔记应用，头条客户端，搜索引擎）。
* 生活学习中使用的软件，游戏遇到过什么样的Bug。假如你是它的开发团队中的一员，收到用户提交的Bug报告会怎么做。如何避免类似的问题再次出现。
* 开发者认为QA提交的问题不重要，以手头还有其他工作为由拒绝对问题作出修改。
* 数据显示游戏新版本发布后，某Boss击杀次数激增。
* 有用户在游戏论坛反应游戏中某道具，卡牌，奖励一直刷不出来。（是否所有玩家都遇到该问题，奖励是否加入到游戏掉落列表中，是否满足掉落条件，掉落几率是否正常，如何测试控制掉率的模块）
* 聊聊SQA / SDET在团队中的角色。
* 为什么选择开发测试岗位
* 对开发测试岗位的认识

* 对测试的了解：单元，功能，集成，接口，冒烟，性能，压力，安全，易用性。
* 如何保证自己写的代码的正确性。
* 测试覆盖，逻辑 / 路径 / 分支。
* 测试策略，等价类划分。
* 测试用例管理，分级。
* 测试执行记录，Bug管理，Bug验证，预防Bug回归。
* 压力测试如何做并发 （压力测试工具，多线程，IO多路复用， 云集群）。
* XSS, DDOS, SQL Injection。

* 怎么看待Code Review，QA在Code Review中能起到什么作用 (对自己，对团队)。

## 工具

通过版本控制工具的问题了解面试者有没有协同工作的经验，是否会通过github的开源项目解决问题，学习提高自身水平。

* git (github / gitlab, 客户端工具 etc.)
  1. clone, status, add, commit, push, fetch, merge etc.
  2. git alias

### 容器化

容器化是近期软件行业的一个热点，而且公司也在落地容器化，对这方面的知识了解属于加分项。

* Docker
* K8s，Swarm etc。
* Docker hub。
* 快速构建一个基于Django + MySql的Hello World网站。
  1. 扩展应用为一个有3个服务节点的集群 （负载均衡）
  2. 数据库支持高可用

### 其它

* 专业背景
* 对游戏行业有哪些了解
* 学习工作中遇到问题如何解决问题
* stack overflow