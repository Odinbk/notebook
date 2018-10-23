# IDEA配置

## PowerMock Maven引入

```xml
<!-- https://mvnrepository.com/artifact/org.testng/testng -->
      <!-- https://mvnrepository.com/artifact/org.powermock/powermock-module-testng -->
      <dependency>
          <groupId>org.powermock</groupId>
          <artifactId>powermock-module-testng</artifactId>
          <version>2.0.0-beta.5</version>
          <scope>test</scope>
          <exclusions>
              <exclusion>
                  <groupId>org.testng</groupId>
                  <artifactId>testng</artifactId>
              </exclusion>
          </exclusions>
      </dependency>

      <dependency>
          <groupId>org.mockito</groupId>
          <artifactId>mockito-core</artifactId>
          <version>2.19.0</version>
          <scope>test</scope>
      </dependency>

      <dependency>
          <groupId>org.powermock</groupId>
          <artifactId>powermock-core</artifactId>
          <version>2.0.0-beta.5</version>
          <scope>test</scope>
          <exclusions>
              <exclusion>
                  <groupId>org.javassist</groupId>
                  <artifactId>javassist</artifactId>
              </exclusion>
          </exclusions>
      </dependency>
      <!-- https://mvnrepository.com/artifact/org.powermock/powermock-api-mockito2 -->
      <dependency>
          <groupId>org.powermock</groupId>
          <artifactId>powermock-api-mockito2</artifactId>
          <version>2.0.0-beta.5</version>
          <scope>test</scope>
      </dependency>
  </dependencies>
```