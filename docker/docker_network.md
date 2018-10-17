## Access to docker from host
Specify _-P_ or _-p_ options when run docker image to grant ability to access to the services provided by   
containers from host.
* when _-P_ specified, Docker will randomly pick up a port from 49000~49900 and map to a container port.
* using _-p_ tp map a specified port to one container port. 
    > ip:hostPort:containerPort | ip::containerPort | hostPort:containerPort
### Mapping all the interface address
* _docker run -d -p 5000:5000 training/webapp python app.py_
**all the ip addresses of the interface will bind to 5000:5000 port mapping.**

### Mapping specific address
* _docker run -d -p 127.0.0.1:5000:5000 training/webapp python app.py_

### Mapping specified address to any port
* _docker run -d -p 127.0.0.1::5000 training/webapp python app.py_
* Host will randomly pick up a port to map to container 5000 port 

### Check port mapping configuration
* docker port [container name]

Notes:
* Container has its own inner network and ip address, you can use _docker inspect [container name]_ to get everything.
* You can bind multiple port mapping with _-p_ option at a time

eg.  
```docker run -d -p 5000:5000 -p 3000:80 training/webapp python app.py```


## Link containers
Suggest to use adding docker into customized Docker network to connect multiple containers  
rather than using _--link_ parameter

### Create a docker network
* _docker network create -d bridge my-net_ 
**_-d_ option specifies the type of docker network; [_bridge, overlay_]. _overlay_ type is used in [Swarm mode]

### Connect containers
launch a container and connect it to the _my-net_ network
```docker run -it --rm --name [container1] --network my-net [image name] bash```

open another terminal, launch another container and join it to the _my-net_ network 
```docker run -it --rm --name [container2] --network my-net [image name] bash```

check out the container network status
run command in _container1_ and check
```bash
ping container2
```

### Docker compose
If there are more than two container need to be connected, it's better to use [Docker Compose](https://yeasy.gitbooks.io/docker_practice/compose/)  
We will unfold the knowledge in Docker Compose chapter.


## Config DNS
Mount 3 relative config file of tmpfs type to enable Docker DNS

Input _mount_ command in container to check file mount status

We expect that when host DNS info update, all of the relative container DNS update with it. By mounting  
with _tmpfs_ type, we can achieve our goal.

