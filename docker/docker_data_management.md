# Docker data management
Introduction of how to manage data between Dockers and container. 
There are two ways in using practical:
1. Volumns
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

## delete volume
* _docker volume rm my-vol_
**Volume is designed to persis data, it's life circle is independent to any container.**
**So, volumes will not be removed when container deleted.**
**If you indeed want to remove volume when container delete, _docker rm -v_ is designed for this.**
* clean up all host-less volume _docker volume prune_

