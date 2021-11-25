# 关于在游戏开发中落地Unit Testing

## Done-Done

1. 开发者自己完成Unit Test，要提交合并进入Master的代码需要有一定UT覆盖率的要求.
2. Never break the CI. 任何要合并进入Master的代码必须通过全部测试集，保证新提交的代码不会破坏已经存在的逻辑.
3. 对于修复的Bug添加对应的单元测试用例覆盖.
4. 开发在本地开发测试负责的模块可以不跑全部测试集， 但是一定要保证自己新加入的测试可以执行通过.
5. Devops组提供Gitlab的接口， 开发可以决定触发全集测试. 全集测试会运行在和线上环境一样的集群上，避免测试在本地通过但是在发布环境不能通过的情况.
6. 组内推广Code Review文化，代码必须经过并通过至少一位非作者组员Review方可合并入master, 要求代码Reviewer确认关键路径有UT覆盖.
7. 代码作者自己不允许通过gitlab合并代码进入master， 由代码Reviewer合并代码.
8. 统一UT开发框架，Mock框架，避免一套测试多种框架的情况.
9. 维护关于UT Trouble shooting的知识文档.
