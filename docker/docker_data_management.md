# Docker data management
Introduction of how to manage data between Dockers and container. 
There are two ways in using practical:
1. Volumes
2. Bind mounts

**Volume is a special directory can be used and shared by multiple containers.**
1. Volume can be shared and reused by containers
2. Changes made to Volume reflect to each container on the fly
3. Changes made to Volume won't impact images.
4. Volume will be kept by default even through containers has been destroyed.

## Create a Volume
* Create a volume _docker volume create my_vol_
* Check all the volumes _docker volume ls_
* Check specified volume info in the host _docker volume inspect my_vol_

## Launch a container which mounts volume
**using _--mount_ option with _docker run_ command to mount volume, more than one volumes can be mounted**
* _docker run -d -P --name web --mount source=my-vol,target=/webapp tarining/web python app.py_

## Check volume information of a container
* _docker inspect web_

## Delete volume
* _docker volume rm my-vol_
**Volume is designed to persis data, it's life circle is independent to any container.**
**So, volumes will not be removed when container deleted.**
**If you indeed want to remove volume when container delete, _docker rm -v_ is designed for this.**
* clean up all host-less volume _docker volume prune_

## Mount Host directory to container
**using _--mount_ option to mount a host directory to containers.**
* _docker run -d -P --name web --mount type=bind,source=/src/webapp,target=/opt/webapp training/webapp python app.py_
* It's convenient to test whether a container works as expected or not. Note that the local directory must be absolute path.  
Docker will raise exception if the local directory is not existing. However, --volume won't, it will create the path for you. 
* The default permission of the mounted directory is RW, you can change it to readonly by add _readonly_ option in _target_ option.

## Mount single host file as data volume
**using _--mount_ to mount single file to containers**
* _docker run --rm -it --mount type=bind,source=$HOME/.bash_history,target=/root/.bash_history ubuntu:17.10 bash_  
by setting like this, we can record the command used in containers.

# Docker data management: volume, bind mount and tmpfs mount

我们可以将数据写到容器的可写入层，但是这种写入是有缺点的：

* 当容器停止运行时，写入的数据会丢失。你也很难将这些数据从容器中取出来给另外的应用程序使用。
* 容器的可写入层与宿主机是紧密耦合的。这些写入的数据在可以轻易地被删掉。
* 写入容器的可写入层需要一个存储驱动（storage driver）来管理文件系统。这个存储驱动通过linux内核提供了一个union filesystem。相比于数据卷（data volume），这种额外的抽象会降低性能。
Docker提供了3种方法将数据从Docker宿主机挂载（mount）到容器：volumes，bind mounts和tmpfs mounts。一般来说，volumes总是最好的选择。

##选择合适的挂载方式

不管你选择哪种挂载方式，从容器中看都是一样的。数据在容器的文件系统中被展示为一个目录或者一个单独的文件。

一个简单区分volumes，bind mounts和tmpfs mounts不同点的方法是：思考数据在宿主机上是如何存在的。

* Volumes由Docker管理，存储在宿主机的某个地方（在linux上是/var/lib/docker/volumes/）。非Docker应用程序不能改动这一位置的数据。Volumes是Docker最好的数据持久化方法。
* Bind mounts的数据可以存放在宿主机的任何地方。数据甚至可以是重要的系统文件或目录。非Docker应用程序可以改变这些数据。
* tmpfs mounts的数据只存储在宿主机的内存中，不会写入到宿主机的文件系统。

###更详细的Diff
* Volumes：由Docker创建和管理。你可以通过docker volume create命令显式地创建volume，Docker也可以在创建容器或服务是自己创建volume。  
当你创建了一个volume，它会被存放在宿主机的一个目录下。当你将这个volume挂载到某个容器时，这个目录就是挂载到容器的东西。这一点和bind mounts类似，除了volumes是由Docker创建的，和宿主机的核心（core functionality）隔离。  
一个volume可以同时被挂载到几个容器中。即使没有正在运行的容器使用这个volume，volume依然存在，不会被自动清除。可以通过docker volume prune清除不再使用的volumes。  
volumes也支持volume driver，可以将数据存放在另外的机器或者云上。

* Bind mounts：Docker早期就支持这个特性。与volumes相比，Bind mounts支持的功能有限。使用bind mounts时，宿主机上的一个文件或目录被挂载到容器上。

    > 警告：使用Bind mounts的一个副作用是，容器中运行的程序可以修改宿主机的文件系统，包括创建，修改，删除重要的系统文件或目录。这个功能可能会有安全问题。

* tmpfs mounts：tmpfs mounts的数据不会落盘。在容器的生命周期内，它可以被用来存储一些不需要持久化的状态或敏感数据。例如，swarm服务通过tmpfs mounts来将secrets挂载到一个服务的容器中去。

###适合Volumes的场景
* 在不同的容器中共享数据。If you don’t explicitly create it, a volume is created the first time it is mounted into a container. When that container stops or is removed, the volume still exists. Multiple containers can mount the same volume simultaneously, either read-write or read-only. Volumes are only removed when you explicitly remove them.
* When the Docker host is not guaranteed to have a given directory or file structure. Volumes help you decouple the configuration of the Docker host from the container runtime.
* When you want to store your container’s data on a remote host or a cloud provider, rather than locally.
* 当你需要备份或迁移数据的时候，When you need to be able to back up, restore, or migrate data from one Docker host to another, volumes are a better choice. You can stop containers using the volume, then back up the volume’s directory (such as /var/lib/docker/volumes/).

###适合bind mounts的场景
* 宿主机和容器共享配置文件。Docker提供的DNS解决方案就是如此，将宿主机的/etc/resolv.conf挂载到每个容器中。
* 开发环境需要在宿主机和容器中共享代码。docker的开发就是如此，毕竟容器中一般是没有编辑器的
* When the file or directory structure of the Docker host is guaranteed to be consistent with the bind mounts the containers require.

###适合tmpfs mounts的场景
* tmpfs mounts主要用在你既不想在容器内，又不想在宿主机文件系统保存数据的时候。这可能是出于安全原因，也可能是你的应用需要写非常多的非持久化数据，tmpfs mounts这时候可以保证容器性能。