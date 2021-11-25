# 单元测试

测试代码最小逻辑单元：方法 的正确性

## 测什么

测试代码最小逻辑单元：方法

* Mock外部依赖，例如：磁盘IO，网络IO，数据库，RPC等。

## 怎么测

开发者自己编写与代码配套的单元测试用例

测试框架

* Java
  * TestNG

* Python
  * unittest2

## 环境

单元测试非常独立，不需要复杂的环境配置。 所以启动一个满足单元测试执行条件最小的docker容器就可以了。

* Java
  * Maven
  * JDK
  * PMD (静态代码检查)

* Python
  * Python
  * nosetest
  * pycodestyle (代码规范检查)

## 谁来维护

* 开发者
  * 单元测试用例
  * Makefile (触发执行测试，代码覆盖率入口)
  * Dockerfile

* Devops
  * Jenkinsfile

## 疑惑

java -ms512m -mx512m -Xmn256m -Djava.awt.headless=true -cp target/Vega-0.0.1-SNAPSHOT.jar:target/dependency/* -Dserver.type=GAME_SERVER -Dserver.group=yangguang_local -Dserver.home=. vega.Bootstrap

java.lang.LinkageError: loader constraint violation: when resolving method "vega.gameserver.exception.GSLogicException.<init>(Lvega/gameserver/enums/GSErrorDefineEnum;[Ljava/lang/Object;)V" the class loader (instance of org/powermock/core/classloader/MockClassLoader) of the current class, vega/gameserver/service/role/BagService, and the class loader (instance of jdk/internal/loader/ClassLoaders$AppClassLoader) for the method's defining class, vega/gameserver/exception/GSLogicException, have different Class objects for the type vega/gameserver/enums/GSErrorDefineEnum used in the signature


"vega.gameserver.exception.GSLogicException.<init>(Lvega/gameserver/enums/GSErrorDefineEnum;Ljava/lang/String;[Ljava/lang/Object;)V" 
the class loader (instance of org/powermock/core/classloader/MockClassLoader) of the current class, vega/gameserver/service/role/BagService, 
the class loader (instance of jdk/internal/loader/ClassLoaders$AppClassLoader) for the method's defining class, vega/gameserver/exception/GSLogicException
have different Class objects for the type vega/gameserver/enums/GSErrorDefineEnum used in the signature

Caused by: java.lang.LinkageError: loader constraint violation: when resolving method "vega.gameserver.exception.GSLogicException.<init>(Lvega/gameserver/enums/GSErrorDefineEnum;Ljava/lang/String;[Ljava/lang/Object;)V" the class loader (instance of org/powermock/core/classloader/MockClassLoader) of the current class, vega/gameserver/service/role/BagService, and the class loader (instance of jdk/internal/loader/ClassLoaders$AppClassLoader) for the method's defining class, vega/gameserver/exception/GSLogicException, have different Class objects for the type vega/gameserver/enums/GSErrorDefineEnum used in the signature