# Powermock 101

## @PrepareForTest

- 模拟静态、final、私有方法，需在测试类上添加注解@PrepareForTest
- 不可以加在Method上面
- 代码示例：

  ```java
  @PrepareForTest({NumericService.class, EventCenterService.class, BagService.class, DiffUtil.class})
  public class TestBagServiceDel extends AbstractVegaTest {
      ... some methods
  }
  ```

## @BeforeMethod

- 使用@BeforeMethod注释将在每个测试方法之前运行的方法
- 对静态方法、私有方法进行Mock

  ```java
    PowerMockito.mockStatic(Class)
  ```

- 对final类型方法进行Mock

  ```java
  PowerMockito.mock(Class)
  ```

- 仅对类中的部分方法进行Mock

  ```java
  object = PowerMockito.spy(Class)
  ```

- 代码示例：

  ```java
  @BeforeMethod
  public void prepareMocking() throws Exception {
      PowerMockito.mockStatic(NumericService.class);
      PowerMockito.mockStatic(EventCenterService.class);
      PowerMockito.spy(BagService.class);
      PowerMockito.mockStatic(DiffUtil.class);

      // 初始化Role对象时，调用RoleGodTrial对象的初始化方法，一层层调用到TimeStrategy.needAction()方法
      // 从而需要对NumericService.getNumericById(Refresh.class, refreshTag)语句进行mock
      Refresh refreshConfig = new Refresh() {
          {
              type = "1";
              para1 = Arrays.asList("1", "2", "3", "4", "5", "6", "7");
              para2 = Arrays.asList("5");
          }
      };
      PowerMockito.when(NumericService.class, "getNumericById", ArgumentMatchers.eq(Refresh.class), anyString()).thenReturn(refreshConfig);
  }
  ```

## prepareMockingForMethod()

- 不是所有的测试方法都需要mock足够多的接口，可能存在潜在的副作用。
- 定义私有方法prepareMethodFor*Method*，用于为单个或多个方法mock相应的接口。
- 代码示例：

  ```java
  private void prepareMockingForGetItemListBySubType(String tag) throws Exception {

      Item item = new Item() {
          {
              subType = 111;
          }
      };

      if("310014".equals(tag)) {
          PowerMockito.when(NumericService.class, "getNumericById", ArgumentMatchers.eq(Item.class), anyString()).thenReturn(item);
      }
  }
  ```

## @DataProvider

- 使用@DataProvider标记一种方法来提供测试方法的数据[推荐使用]
- 直接对参数进行返回，return this.build2DArray( ... )；
- 代码示例：

  ```java
  @DataProvider
  public Object[][] getItemListBySubType_HappyPath_DataProvider() {

      return this.build2DArray(
              this.buildArray(111, "310014", 1, 111, true),
              this.buildArray(111, "310001", 1, 101, false)
      );
  }
  ```

## @Test

- 使用@Test将类或方法标记为测试的一部分。
- @Test方法命名参考：getItemListBySubType_HappyPath()、getItemListBySubType_[SadPath()](https://www.jianshu.com/p/e7fb0c10d143)
- 代码示例：

  ```java
  @Test(dataProvider = "getItemListBySubType_HappyPath_DataProvider")
  public void getItemListBySubType_HappyPath(int subType, String tag1, int count1, int subType1, boolean isAddItem1) throws Exception {
      List<BagItem> result = Lists.newArrayList();
      List<BagItem> ret = BagService.getItemListBySubType(role, subType);
      assertEquals(ret, result);
  }
  ```

### Mock方法

- 建议使用doReturn(..)when(..)，不会调用真实的方法，参考[thenReturn()与doReturn()的区别](https://www.cnblogs.com/lanqi/p/7865163.html)

- 对void()方法进行Mock

  ```java
  PowerMockito.doNothing().when(Class, "methodName", params);
  ```

- 对返回值非空的方法进行Mock，需要返回值

  ```java
  PowerMockito.doReturn(value).when(object, "fieldName", params);
  ```

- 对返回值非空的方法进行Mock，无需返回值

  ```java
    PowerMockito.doReturn(null).when(object, "fieldName", params);
  ```

- 模糊匹配

  - 测试一个方法时，可能不想传入精确的params值，这时候可以使用Mockito.anyInt()，anyString()，any(Class)等
  - 不可与精确匹配混用

### 调用方法

- 调用私有方法

  ```java
    Whitebox.invokeMethod(object, "methodName", params)
  ```

- 调用私有静态方法

  ```java
    Whitebox.invokeMethod(Class, "methodName", params)
  ```

- 设置类的field

  ```java
    Whitebox.setInternalState(Class, "fieldName", value)
  ```

- 设置对象的field

  ```java
    Whitebox.setInternalState(object, "fieldName", value)
  ```

### 验证方法调用

- 验证静态方法调用

  ```java
    PowerMockito.verifyStatic(Class);
    Class.method(params);
  ```

- 验证非静态方法调用

  ```java
    PowerMockito.verifyPrivate(object);
    object.method(params);
  ```