# 悠乐科技2018秋季校招笔试题

## 单项选择题

1. TCP协议中，数据发送和接受是以以下哪种方式完成的.
a) 字节流
b) 字符序列
c) 数据行
d) 数据包
Answer: a
<br/>
2. 假设要通过一条TCP连接发送一个由1000个字节构成的文件。 第一个字节被编号为10001。请问如果所有的数据由一个段发送的话，这个段的序列号是？
a) 10000
b) 10001
c) 12001
d) 11001
Answer: b
<br/>
3. 下面哪个Linux命令用来显示操作系统名称。
a) os
b) unix
c) kernel
d) uname
Answer: d
<br/>
4. 下面哪个Linux命令用来创建一个空文件，假设该文件不存在。
a) cat
b) touch
c) ed
d) read
Answer: b
<br/>
5. 下面哪个Linux命令可以将后台进程变成前台进程。
a) bg
b) fg
c) background
d) forground
Answer: b
<br/>
6. 如何以后台进程的方式启动一个进程。
a) &
b) *
c) ?
d) |
Answer: a
<br/>
7. 下面的SQL语句存在一个错误，请指出错在哪里:
```sql
SELECT * FROM employee WHERE dept_name="Comp Sci";
```
a) Dept_name
b) Employee
c) “Comp Sci”
d) From
Answer: c
Exp: 字符串需要单引号
<br/>
  8. 下面的SQL语句可以被答案选项中的哪条替代?
```sql
Select name, course_id
from instructor, teaches
where instructor_ID= teaches_ID;
```
This Query can be replaced by which one of the following ?
a) Select name,course_id from teaches,instructor where instructor_id=course_id;
b) Select name, course_id from instructor natural join teaches;
c) Select name ,course_id from instructor;
d) Select course_id from instructor join teaches;
Answer: b
<br/>
9. 有数据库表T的A列被定义为varchar(20)类型，存在值为“Avi”的记录. 表T的B列被定义为char(20)，存在值为”Reed”的记录. 请问A和B列的值分别使用了多大的空间？
a) 3, 20
b) 20, 4
c) 20 , 20
d) 3, 4
Answer: a
<br/>
10. HTTP协议工作在网络模型的哪层.
a) 应用层
b) 传输层
c) 网络层
d) 以上都不是
Answer: a
<br/>
11. 数据包从客户端发送给服务器端，并从服务器端返回的时间开销在HTTP协议中被称为。
a) STT
b) RTT
c) PTT
d) None of the mentioned
Answer: b
<br/>
12. HTTP中，请求消息是在三次握手的第几部发送的？
a) 第一步
b) 第二步
c) 第三步
d) 以上答案都不对
Answer: c
<br/>
13. 找出不正确的HTTP状态码和意义匹配。
a) 200 OK
b) 400 Bad Request
c) 301 Moved permanently
d) 304 Not Found
Answer: d
<br/>
14. 哪种HTTP请求方法被指定时，HTTP Body可以设置为空。
a) POST
b) SEND
c) GET
d) 以上答案都不对
Answer: c
<br/>
15. 当哪种HTTP请求被响应时，response的requested object为空？
a) GET
b) POST
c) HEAD
d) PUT
Answer: c
<br/>
16. 访问操作系统提供的服务需要通过下列哪种接口来达成：
a) 系统调用
b) API
c) 库函数
d) 汇编指令
Answer: a
<br/>
17. Unix操作系统中，下列哪条命令用来创建一个新的进程。
a) fork
b) create
c) new
d) 以上答案都不对
Answer: a
<br/>
18. 一个Unix进程会被一下哪种情况终结？
a) 进程正常退出
b) fatal error
c) 被其他的进程杀死
d) 以上所有情况都可以
Answer: d 
<br/>
19. 一组进程在下列哪种情况下会出现死锁
a) 所有的进程都被阻塞且不可恢复
b) 所有的进程都已经被终结
c) 所有的进程都在试图杀死彼此
d) 以上答案都不对
Answer: a
<br/>
20. 进程栈不包括下面哪项
a) Function参数
b) 局部变量
c) 返回地址
d) 子进程进程ID
Answer: d
<br/>
21. 以下哪项可以被用来做同步工具
a) 线程
b) 管道
c) 信号量
d) Socket
Answer: c
<br/>
22. 信号量是一个共享的整型变量，它不可以
a) 小于0
b) 大于0
c) 小于1
d) 大于1
Answer: a
<br/>
23. 以下哪项可以用来提供互斥
a) 互斥锁
b) binary信号量
c) 互斥锁和binary信号量
d) 以上答案都不正确
Answer: c
<br/>
24. 分析 fun()函数的时间复杂度为?
```
int fun(int n)
{
  int count = 0;
  for (int i = n; i > 0; i /= 2)
     for (int j = 0; j < i; j++)
        count += 1;
  return count;
}
```
a) O(n^2)
b) O(nLogn)
c) O(n)
d) O(nLognLogn)
Answer: c
<br/>
25. 以下排序算法的经典实现中，哪个不是稳定排序
a) 插入排序
b) 归并排序
c) 快速排序
d) 冒泡排序
Answer: c
<br/>
26. 以下排序算法的经典实现中，哪个在待排序数组基本有序的情况下，性能最好。
a) 插入排序
b) 归并排序
c) 快速排序
d) 堆排序
Answer: a
<br/>
27.	结构中定义的成员，其默认访问权限是:
a) public
b) protected
c) private
d) static
Anwser: a
<br/>
28)	给定n个节点的二叉搜索树，每个节点的值是整数。给定一个整数，在树中找与该整数最接近的节点的最小算法复杂度是:
a) O(n) 
b) O(logn)
c) O(nlogn) 
d) O(n^2)
Answer: b
<br/>
29)	一个栈的入栈序列是A，B，C，D，E，则栈的不可能的输出序列是：
a) EDCBA
b) DECBA
c) DCEAB
d) ABCDE
Anser: c
<br/>
30. 32位计算机上，用下列哪种数据类型存储65000最合适？
a) signed short
b) unsigned short
c) long
d) int
Answer：b
<br/>
31. int数据类型的大小为：
a) 4 Bytes
b) 8 Bytes
c) Depends on the system/compiler
d) Cannot be determined
Answer：c
<br/>
32. 下面的三元运算表达式中必须出现的表达式为
exp1 ? exp2 : exp3;
a) exp1
b) exp2
c) exp3
d) 所有表达式
<br/>
33. 下面的C代码可以被重写为:
```c
c = (n) ? a : b;
```
a) if (!n)c = b;
    else c = a;
b) if (n &lt;= 0)c = b;
    else c = a;
c) if (n &gt; 0)c = a;
    else c = b;
d) All of the mentioned
Answer: a

## 读代码预测输出

题目1：阅读c代码，预测输出。
```c
#include <stdio.h>
int main()
{
    unsigned int i = 23;
    signed char c = -23;
    if (i > c)
        printf("Yes\n");
    else if (i < c)
        printf("No\n");
}
```
Answer: No
隐式类型转换，signed char会被转换成ungisned int.


题目2：阅读c代码，预测输出。

```c
#include <stdio.h>
void main()
{
    int y = 3;
    int x = 5 % 2 * 3 / 2;
    printf("Value of x is %d", x);
}
```
Answer: 1

题目3：阅读java代码，预测输出。
```java
public class Test 
{ 
    public static void main(String[] args) 
    { 
        int value = 554; 
        String var = (String)value;  //line 1 
        String temp = "123"; 
        int data = (int)temp; //line 2 
        System.out.println(data + var); 
    } 
}
```
Answer: 编译错误
需要显式类型转换

题目4：阅读c代码，预测输出。
```c
#include <stdio.h>
struct temp
{
    int a;
} s;
void func(struct temp s)
{
    s.a = 10;
    printf("%d\t", s.a);
}
main()
{
    func(s);
    printf("%d\t", s.a);
}
```
Answer: 10 0

题目5：
```python

check1 = ['Learn', 'Quiz', 'Practice', 'Contribute'] 
check2 = check1 
check3 = check1[:] 
  
check2[0] = 'Code'
check3[1] = 'Mcq'
  
count = 0
for c in (check1, check2, check3): 
    if c[0] == 'Code': 
        count += 1
    if c[1] == 'Mcq': 
        count += 10
  
print count 
```
Answer: 12

## 编程

题目1：
分层遍历二叉树。 
```
     3
    / \
   9  12
  / \
 8   10
```
输出:
3
9, 12
8, 10

题目2：
按单词翻转字符串: "youle gaming is awesome"
输出: "eluoy gnimag si emosewa"

题目3：
找到数组中第N大的那个数。要求时间复杂度尽量低。

题目4：
假定有方法flip(string, index), 当传入参数("abcdefg", 3), 返回"defgabc"。要求空间复杂度尽量低。

## 测试

题目1：
为编程题目2设计测试用例。
例如：

* 输入参数："youle gaming is awesome", 返回值: "eluoy gnimag si emosewa"
* 输入参数："", 返回值: ""

题目2：
有一个随机算法：Random(uint range)
输入无符号整数N，随机返回0~N之间的数
设计测试用例来验证该方法的正确性。

题目3：
为编程题目2设计测试用例。
例如：

* 输入参数：（"abcdefg", "3"）, 返回值: "defgabc"
* 输入参数：（"abcdefg", "0"）, 返回值: "abcdefg"
* 输入参数：（"abcdefg", "7"）, 返回值: "gfedcba"

题目4：
选一款喜欢的游戏或者软件，在使用中是否发现过它的Bug。

1. 设想自己是它的开发团队成员，你会怎么做去避免这样的Bug发生。
2. 挑选该游戏或者软件的常用功能，你会从哪些方面对该功能进行测试。

任选一项作答即可。

题目5：
有一个洗牌方法：Shuffle(int[] array)
输入一个int数组，该方法会随机打乱输入数组中元素的顺序。
设计测试用例来验证该方法的正确性。