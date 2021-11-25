# This sheet is used to memo ideas and knowledge about testing and devops in game developing

## JVM Language

* Java
* Scala

## Java unit test framework and best practice

* JUnit

* PowerMock
    > [PowerMock Blog](https://www.cnblogs.com/softidea/p/4204389.html)
    > [PowerMock Wiki](https://github.com/powermock/powermock/wiki)  
    PowerMock.Morkito implementation [How To](https://ehlxr.me/2017/07/25/use-introduction-of-powermock/)
    * EasyMock -- Developer Works [How To](https://www.ibm.com/developerworks/cn/opensource/os-cn-easymock/index.html)
    
* TestNG
    > Comparison of JUnit4 and TestNG [developer works](https://www.ibm.com/developerworks/cn/java/j-cq08296/index.html)   
    TestNG could answer Fuxuan Shen's question about DDT or enumerate test cases.
    Basic knowledge about how to write test case with [TestNG](https://dev.to/chrisvasqm/introduction-to-unit-testing-with-java-2544)  
* Coverage
* Java static code check kit: prefer to use PMD and CodeStyle from Google. 
    > [Code Style](http://checkstyle.sourceforge.net/cmdline.html)  
    $ java -jar checkstyle-8.12-all.jar -c /google_checks.xml ~/Workspace/topjoy/vms/VMS/src/main  
    
    > [PMD](https://pmd.github.io/)  
      [PMD Command line](https://pmd.github.io/pmd-5.5.7/usage/running.html)  
    $ /Users/Guang/Downloads/pmd-bin-6.6.0/bin/run.sh pmd -l java -R category/java/bestpractices.xml -filelist $FILELIST    :w

## Devops

* Canary Deployment
* Blue-Green Deployment

## Principles

* Update or add test case for code where bug was find. It will help to fall twice at the same place.