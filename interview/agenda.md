# 开发测试流程讨论

## 议题：

1. 频繁的工作分支和主分支间的代码同步.
2. 通过merge request合并代码
3. code review
4. 提高单元测试覆盖率.
5. 开发测试流程短中期目标
    > 短期目标：稳步提高单元测试覆盖率，例如 5~10%类覆盖率；理清要接口测试的测试用例，划分优先级。
    > 中长期目标：80%类覆盖率，重要的class 75%+，平均50%+ 行/分支覆盖率；接口测试覆盖P0，P1.

## 结论总结：

1. 根据开发项目的特点，尽可能早的将功能完备的代码合并回Master分支。（功能完备可以理解为和现有功能没有冲突，不影响Master发布， 代码可以正常构建打包， 通过所有的单元测试）  避免开发分支过久地游离于Master。
2. 非紧急场景拒绝通过命令行合并代码到Master分支。 通过Gitlab提交Merge Request发起合并请求。 合并代码时使用Gitlab的commit squish和delete original branch功能精简commits，删除无用分支。
3. 开展Code Review实践。 同事间互相review，项目主程， lead把控Code Review质量，不流于形式。 Review关注项目组Java开发规范，代码设计，架构，性能，数据库设计等方面。 总结可以用工具替代的检查点（PMD， Sonar等）。
4. 推进单元测试. 新开发的功能配套单测，根据开发模块的重要性自己评估覆盖率，具体覆盖率要求根据实践情况商定。开发者可以简单记录下开发功能，编写测试用例，进行Code Review的时间开销，帮助将来设定预期。
5. 根据实践和反馈设定技术中心季度目标，下周2的同步例会上收集大家的反馈情况。

## Q4目标

* 单元测试class, method覆盖率100%。
* 接口测试Vega，NCC达到一个合理的覆盖率。
* 集成测试环境可以执行冒烟测试。
* 培训QA上手接口测试。
* 接口测试支持多种协议 （protobuffer)。
* 集成测试环境暂时可以不包含前端。
* 模拟弱网，存储不可用的情况。
* 质量报告：sonarqube。
* 给Vega搭建比较完整的接口测试环境。