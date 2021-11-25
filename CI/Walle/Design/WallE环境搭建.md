# 环境搭建

环境使用docker-compose搭建

## 前置准备

运行WallE的服务器上提前准备：

* docker
* docker-compose
* harbor镜像管理仓库
* Nexus组件管理仓库
* MySql数据库服务，从dump文件中恢复相关数据。
* 服务器上安装WSGI服务[gunicorn](https://gunicorn.org/)

基础镜像使用公司镜像仓库制作好的`python:3.6.8-alpine-mysql`基础镜像，所以需要提前搭建好harbor镜像仓库，配置`registry-dev.youle.game`域名。如果域名有调整，需要更新WallE4项目根目录下的Dockerfile中的镜像引用。
提前搭建好nexus repository组件管理服务，缓存镜像制作过程中使用到的第三方组件。

## 容器环境

### Dockerfile

跳转到Dockerfile目录，执行`docker build -t WallE4 ./`验证Dockerfile正确。

```dockerfile
FROM registry-dev.youle.game/devops/python:3.6.8-alpine-mysql

ENV TZ=Asia/Shanghai
ENV FLASK_APP=run.py
EXPOSE 5000

ADD requirements.txt /tmp/requirements.txt
RUN set -ex \
    && sed -i 's/dl-cdn.alpinelinux.org/alpine.youle.game/g' /etc/apk/repositories \
    && apk update \
    && apk add --no-cache rsync tzdata \
    && pip install -r /tmp/requirements.txt --trusted-host nexus.youle.game -i http://nexus.youle.game/repository/pypi-public/simple \
    # clean
    && rm -rf /var/cache/apk/*

ADD ./ /app/
WORKDIR /app

CMD flask run -h 0.0.0.0 --no-reload
```

### Gunicon config

添加以下内容到`/etc/gunicorn.conf`配置文件中。

```conf
# 并行工作进程数
workers = 1

# 指定每个工作者的线程数
threads = 20

# 监听内网端口5000
bind = '0.0.0.0:5000'

# 设置守护进程,将进程交给supervisor管理
daemon = 'false'

# 工作模式协程
worker_class = 'eventlet'

# 设置最大并发量
worker_connections = 200

# 设置进程文件目录
pidfile = '/var/run/gunicorn.pid'

# 设置访问日志和错误信息日志路径
accesslog = '/data/logs/walle4_acess.log'
errorlog = '/data/logs/walle4_error.log'

# 设置日志记录水平
loglevel = 'warning'
```

### docker-compose

复制项目根目录下的`env.sample`到`./compose/env`, 并根据实际环境部署情况调整env配置中的值。

```yaml
version: '3'
services:
    walle:
        build:
            context: .
            dockerfile: Dockerfile
        ports:
            - "5000:5000"
        env_file:
            - ./compose/env
        environment:
            - MEMCACHED_HOST=memcache
        volumes:
            - ./compose/gunicorn/conf/gunicorn.conf:/etc/gunicorn.conf
            - ./compose/gunicorn/logs:/data/logs
        # 线上环境
        # command:
            # ["tail", "-f", "/dev/null"]
            # ["gunicorn", "-c", "/etc/gunicorn.conf", "wsgi:app"]
        # 开发环境
        command:
              - /bin/sh
              - -c
              - |
                flask deploy && flask run -h 0.0.0.0 --no-reload
    memcache:
        image: mirror.youle.game/memcached:latest
```

### 启动服务

* 首次启动服务先执行`docker-compose up`
* 启动服务`docker-compose start`
* 停止服务`docker-compose down`
* 重启服务`docker-compose restart`
* 单独重启WallE`docker-compose up walle`
* 升级数据库`docker-compose exec walle flask db init`
