rc/rc-http 添加游戏

以 payment 为例

> 实际操作请根据 game 修改文中的 payment 字串



### rc 挂载机上的操作

1. 添加 payment 目录

> 在 172.16.153.52 或 172.16.153.53 任一台机器上操作

~~~
cd /data/ResourceCenter

mkdir payment
~~~



2. 修改 rsyncd 配置，添加模块

> 在 172.16.153.52 或 172.16.153.53 任一台机器上操做

`vi /etc/rsyncd.conf`，添加以下内容

~~~
[payment]
path = /data/ResourceCenter/payment/
ignore errors
incoming chmod = Du=rwx,Dog=rx,Fu=rw,Fgo=r
secrets file = /data/ResourceCenter/.rsync/secrets/payment.rsyncd.secrets
auth users = payment
~~~



3. 设置 secret

> 在 172.16.153.52 或 172.16.153.53 任一台机器上操做

`vi /data/ResourceCenter/.rsync/secrets/payment.rsyncd.secrets`， 添加以下内容

~~~
payment:LbiyswsJ
~~~

目前随机八位密码规则如下(不强制):

~~~
# 产生随机密码 8位，python3 
import random,string
passwd = ''.join(random.choices(string.ascii_letters + string.digits, k=8))
~~~

修改secrets 权限

~~~
chmod 600 /data/ResourceCenter/.rsync/secrets/payment.rsyncd.secrets
~~~



### rc-http 上的操作

目前 rc-http 服务器和 rc 挂载机是同样的两台机器： 172.16.153.52 或 172.16.153.53

> 172.16.153.52 或 172.16.153.53 上都需要如下操作

进入  /data/rc-http， 执行 docker-compose down， 修改 /data/rc-http/docker-compose，参考其他游戏添加 payment

~~~

	payment:
    container_name: http-payment
    image: codeskyblue/gohttpserver
    restart: always
    environment:
      - TZ=Asia/Shanghai
    # ports:
    #   - '8004:8000'
    volumes:
      - /data/ResourceCenter/payment:/app/public/payment
      - ./assets/index.html:/app/assets/index.html
    command: 
      - --xheaders
      - --auth-type=http
      - --auth-http=payment:beb00370
      - --title=payment
~~~

其中的 `--auth-http=payment:beb00370` 的规则为

~~~
hashlib.md5('https://jenkinsrc.youle.game/{game}/').hexdigest()[-8:] 
~~~



修改 `/data/rc-http/conf/default.conf` 添加如下内容

~~~

   location ^~/payment/ {
     proxy_pass http://payment:8000;
     proxy_redirect off;
     proxy_set_header  Host    $host;
     proxy_set_header  X-Real-IP $remote_addr;
     proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
     proxy_set_header  X-Forwarded-Proto $scheme;
 
     client_max_body_size 0;
   }
~~~

修改完后，回到  /data/rc-http ，执行 `docker-compose up`



执行 /data/scp-rc-http 同步到 53，53 上需要先关闭服务

