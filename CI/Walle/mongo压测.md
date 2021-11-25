## 测试目的
* 测试MongoDB的性能，整理使用MongoDB的最佳实践

## 测试要点
* 整理MongoDB的性能指标
* 测试应用端连接数与QPS之前的关系
* 测试多台应用端连接MongoDB后，QPS的变化。测试多少应用端连接MongoDB为最优
* 测试MongoDB的同步驱动和异步驱动的性能差异
* 测试bulkwrite对性能的影响

## 测试环境
* 测试应用端采用的是macbook pro
* MongoDB版本为3.4，副本集有三个mongo实例，分别为一主一从一仲裁，都部署在centos7的4核8G的开发机，存储引擎为wiredTiger
* 与运维交流过mongo的线上部署环境，一般也是三个实例的副本集，但是主，从，仲裁都是分别部署在不同的机器上。

## 测试工具与方法
* 测试工具
  * 监控工具
    * mongostat：用来分析mongodb的各种关键性能指标
      * 启动命令：mongostat --host 172.16.134.73:31000 -usiteRootAdmin -pmongodb_password --authenticationDatabase admin
      * 输出图表如下![image](uploads/fca7d015562cd05fad8cbf8f04548b32/image.png)
    * top：查看系统负载，每个cpu的利用率等
      * 输出图表如下![image](uploads/31f19d03ea699ac887127319c8ba2724/image.png)
    * vmstat：查看系统性能指标(vmstat 1)
      * 输出图表如下![image](uploads/5b0daa5d73078e09c631a26033d7915a/image.png)
    * iostat: 查看系统IO情况，官方推荐的监控命令（iostat -xmt 1）
      * 输出图表如下![image](uploads/583abd04ef01a05e09a84773ae6ac49e/image.png)
      * 关键性能指标
        * (设备)使用率：统计过程中处理I/O请求的时间与统计时间的百分比，即iostat输出中的%util，如果该值大于60%，很可能降低系统的性能表现。
        * IOPS：每秒处理读/写请求的数量，即iostat输出中的r/s和w/s，个人PC的机械硬盘IOPS一般在100左右，而各种公有云/私有云的普通服务器，也只在百这个数量级
        * 数据吞吐量：每秒读/写的数据大小，即iostat输出中的rMB/s和wMB/s，通常磁盘的数据吞吐量与IO类型有直接关系，顺序IO的吞吐能力明显优与随机读写
  * ycsb（Yahoo! Cloud Serving Benchmark），主要用来进行辅助测试，之前运维也做过mongo的压测，用的是这个工具
  * 使用BulkOperation来把数据批量入库的测试程序（100%的mongodb的update操作）

* 测试方法
  * mongodb的同步驱动和异步驱动的对比测试
    * 可以采用ycsb进行测试，已经有人做过这个测试了，可以参考[这里](https://blog.csdn.net/get_set/article/details/79506591)
    * 根据这个测试的结果，在固定线程的情况下，mongo异步驱动比同步驱动略有提升，考虑到框架代码中主要采用同步驱动，改为异步驱动的话，需要进行修改和测试，后续测试仍然采用同步驱动
  * 测试bulkwrite的性能，并与实时写入进行对比，主要对比数据为写入相同数据量的情况下（实时是顺序每条写入，bulk是一次性写入所有），应用端平均每条数据花费的时间
    * ![image](uploads/05fb8509117e4e436585576c9234c383/image.png)
    * 从图中观察可知，bulk平均每条写入时间约为实时的0.5～0.25左右
    * 下图是写入100条不同大小的数据，实时写入和bulkwrite的时间对比
    * ![image](uploads/5ddeee0d6c7d7963b7b28e4bc54fce6b/image.png)
    * 由于bulk的性能比实时写入要高，后续我们测试都采用bulkwrite来进行mongodb的压测
  * 进行mongodb的压测，如何监控mongodb出现的瓶颈，及应当采用何种策略
    * 测试数据每条都为Role的DBUpdate数据。每条数据包含了12个int，4个string，大小约为56Byte（数据大小在测试中也会调整来进行测试，`单条DBUpdate数据大小会比较大程度的影响ops数据`）
    * 具体测试方法是采用的是坤哥之前给TKW的bulkwrite的代码。测试方式是用DataService中的DBService中的addTask，来起到多线程并发入库的效果。启动多个task（设为i），每个task执行多次（设为j）bulkwrite操作，每次bulkwrite写入多条DBUpdate（设为k）
    * 通过调整i，j，k参数，DBService启动的DBQueue数量（设为m，默认为16），每条DBUpdate的数据量（设为n，默认为12 int和4 string，约为56字节），来测试MongoDB的性能
    * 在测试中，以top中的load参数，作为衡量系统性能的指标，在load超过cpu cores * 2，视为高负载
    * 由于DBService.addTask时，采用的是key的objectId取模，可能会有多个task分配到一个DBQueue中执行，造成每个线程执行时间长短不太一致，比较影响时间的统计，因此测试修改了addTask中的分配方式，启动的DBQueue的数量和task的数目一致（也就是i和m是同一个值），每个task分配到一个DBQueue中运行，这样方便统计时间
    
## 测试及数据分析
  * **调整一次bulk写入的DBUpdate数据条数**
    * 调整k，m=i=16，n≈56，j=1000，在k取较大值（k > 100)时，mongodb的ops数目抖动的比较大，如下图所示
    * ![image](uploads/d54c3fe0c995e44681abf652fcbf975a/image.png)
    * 在k取较小值（k = 50）时，mongostat数据如下图所示
    * ![image](uploads/ddb6c6b3b851e1b261d38038641ad25d/image.png)
    * 考虑到我们更新玩家数据的策略，采用crontab注解，在固定间隔下，检查玩家这段时间的所有DBUpdate数据，并保存到Mongodb中，时间间隔一般不会特别大，这段时间内玩家的update数据也不会特别多，因此后续测试k采用了比较小的值

 * **调整启动的task数目**
    * 调整m（i==m），k=50，j=1000。受限于我们的测试用笔记本性能，如果启动的task过多，则cpu占用率会特别高。因此m采用了16，32，48线程来测试，每个task写入的数据量都是一致的，整理图表如下:

    |  线程数 | 执行时间| 稳定后OPS | 系统load |
    |----|----|----|----|
    | 16线程 | 97s | 1w左右 | 10左右 |
    | 32线程 | 102s | 1w左右 | 10左右 |
    | 48线程 | 103s | 1w左右 | 10左右 |
    * mongodb的ops并没有提高，每次测试写入的数据量和时间也是成正比的。数据上看已经达到了一台测试客户端能达到的ops极限
    * 观察测试中load值的变化，cpu在还有一定的空闲，sy和wa有短暂的使用率波动
    * ![image](uploads/81ee1e3de6efd79b4f948a5179c01511/image.png)
    * iostat的输出图表
    * ![image](uploads/562e9fcab3d46c106da2003a914a12bf/image.png)

    * 进一步测试，采用两台测试客户端来进行测试，获得数据如下

    |  线程数 | 执行时间| 稳定后OPS | 系统load |
    |----|----|----|----|
    | 16线程（每台8线程） | 42s~53s | 1.9w左右 | 13+ |
    | 32线程 （每台16线程）| 42s~53s | 1.9w左右 | 13+ |
    | 48线程 （每台24线程）| 45s～55s | 1.9w左右 | 13+ |
    * mongodb的ops基本上翻了一倍，系统负载也增高了一些
    * 测试时的load图表，cpu仍然还有一定的空闲，sy和wa也依然后短暂的波动
    * ![image](uploads/29deab157b3999c670a4a18663e68e51/image.png)
    * iostat的图表
    * ![image](uploads/5a60a80ec3dde1ddbb86d5133cbc9bcb/image.png)
    * vmstat的输出图表
    * ![image](uploads/642e7a2802ad6f718abf991e8c0e0f44/image.png)

    * 产生的问题：
      * mongodb的ops，在更多个测试客户端连接时，变化趋势是怎样的，是否还能维持线性增长？
        * 限于测试环境限制，目前只有两台笔记本可以利用，更多台测试暂时没做
        * 也尝试过同一台机器开两个jvm，各启动一个压测程序，也没有办法提升ops
      * 为什么两台客户端连接可以突破单台测试机能达到的mongodb的ops的上限
        * 根据实际上ops数目的增长，可以判断出mongodb在处理update时有了提升，2台客户端，ops接近2倍，判断出mongodb处理网络请求和处理update时没有达到瓶颈，但是一台应用端调整各种测试参数，也没法突破ops限制，查了很多资料也没有能够找到合理的解释
        * 根据压测时load和iostat的数值，感觉mongodb的机器瓶颈在磁盘io，查看了一下vmstat的输出，每秒写入磁盘的数据量很高，同时中断数和上下文切换次数也很高，特别是上下文切换次数每隔几秒会出现一次上百万次的峰值
        * ![image](uploads/a2881906cebec38a84e4d400d41ea451/image.png)
        * 用blktrace来分析了一下单台客户端和两台客户端中一次io操作中，具体用时的统计
        * 其中
          * 单台
            * ![image](uploads/bc26e34f5d680a7c9eafb688e0aaadb0/image.png)
          * 两台
            * ![image](uploads/7b500e20db01487b46c7ec038a8b82c0/image.png)
          * 图表中关键数据的解释
            * ![image](uploads/be4e98a45ec56b9a114255790497ac5f/image.png)
          * 针对图中占比最多的I2D，尝试调整了一下IO Scheduler。默认的是deadline，调整为cfq之后，系统load略降，但是会造成任务处理时间的增加，后续仍旧维持了deadline调度器

  * **调整每条DBUpdate的大小** 
    * 调整n=2000Bytes（每条DBUpdate包含500个int），m=i=8，j=1000, k=50
    * mongostat输出，ops显著降低
    * ![image](uploads/c7d6d7c18d0518b5c42d840a63fcec9b/image.png)
    * load值，相比之前测试，mongodb的cpu占用率明显提高，负载也相应提高
    * ![image](uploads/ad62982b3cea19285e59c36078d78695/image.png)
    * vmstat输出，可以看到正在运行的进程数明显增多
    * ![image](uploads/09959273da6d4e36a6e7472586d57ef6/image.png)
    * iostat输出，io写入很少
    * ![image](uploads/5c02e99cd43aa5d20fd120a412559af4/image.png)
    * mongodb占用cpu的原因查找
      * 因为主要占用在用户空间，因此打算用ltrace来跟踪一下库函数的调用，但是attach时候会导致mongo退出
    * 从测试结果看，如果每条DBUpdate包含数据较多，会导致mongodb的cpu占用率提高
    * 两台测试客户端同时测试也不会对ops有提高
  
  * **每条DBUpdate大小随机，范围从40Bytes～1kBytes** 
    * m=i=8，j=1000, k=50
    * mongostat输出
    * ![image](uploads/359ed3dd340ac3286bddb9af0e75bf7b/image.png)
    * top输出
    * ![image](uploads/4b4a7a29edf4ee35f10089fd6395778c/image.png)
    * iostat输出
    * ![image](uploads/e38199c9c0bea11245c112f4dc0fc3f6/image.png)
    * vmstat输出
    * ![image](uploads/822046b32119f9c7d2204b13ff2495bd/image.png)

  * 偶然情况发现，mongo的secondary节点挂掉后，系统load会降低非常多，猜想副本集的oplog同步可能会是单机io的问题所在，把mongodb的oplog的size从1G设置成了5G，在当前的部署模式下（一主一从一仲裁）也没有ops的提升
  
         
## 结论
  * 本文主要测试的mongodb执行update的性能，mongodb采用副本集，一主一从一仲裁全部部署在一台4核8G的centos7的机器上，与实际线上mongodb部署不同，线上的副本集，主，从，仲裁都分在不同机器上部署
  * 采用bulkwrite比实时写入会有速度上的提升，提升幅度随着每条写入数据量的提高而减小
  * 单条DBUpdate数据的大小，会显著影响mongo的性能
  * 在DBUpdate数据每条56Bytes情况下，单台机器能达到1w左右ops，两台能接近2w左右ops，这时系统瓶颈主要在磁盘io上
  * 在DBUpdate数据每条2kBytes情况下，单台机器只能达到400多ops，两台ops数据基本没变化，主要瓶颈在mongo的cpu占用上

## 其他
* MongoDB的官网强烈建议在wiredTiger引擎下，linux用xfs文件系统来进行mongodb数据存储，而不用ext4文件系统。网上有一片在aws上进行测试的[文章](https://scalegrid.io/blog/xfs-vs-ext4-comparing-mongodb-performance-on-aws-ec2/)，结论是在高速硬盘（ssd）上，性能提升比较大，中低端机器上，提升不那么显著。

## 补充测试
  * 做了一组发送相同数量的数据，测试应用端启用不同的线程数来进行发送的对比实验
    * ![image](uploads/85a9d103e94c27b90ded1525f4befeb9/image.png)
    * 纵坐标是消耗的时间（ms），横坐标是启用的线程数，启动线程数大于8之后，时间就没有明显变化了
  * 按照mongodb官网的建议，关闭了THP（Transparent huge pages），atime，NUMA，SELinux，也没有提升服务器mongo的处理能力
  * 尝试从mongoconfig中设置的参数中，找到能提升应用端性能的参数
    * 调整mongoclient中的参数（每次调整一个参数），监控服务器端mongodb的ops参数，负载等数值，同时监控测试客户端的各种资源占用
    * 没找到有价值的配置参数
  * 对于DBUpdate数据，统计每条数据的序列化大小值
    * mongodb网络传输采用bson
    * 对于之前测试的DBUpdate数据，数值为56字节的，bsonsize为613Byte。数值为2k字节的，bsonsize为9906Byte
  * 单台客户端压测mongo的ops瓶颈，和运维同学确认一下是否是内网有限速
    * 用iperf3检测笔记本通过YL-USER，连接服务器的速率，在180s的统计时间内，结果如下：
    * ![image](uploads/217762dcdfb26266891062bcc14d4e79/image.png)
    * 在压测时，查看笔记本的活动监视器的网络部分，看 发出的数据/秒 最多不到7M，应该是没有达到网络速度的限制
    * ![image](uploads/ad3a6c8ecf4eb3d1db3d70cc1d87929a/image.png)