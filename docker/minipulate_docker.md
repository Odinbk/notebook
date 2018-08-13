## Start container
There are two ways to start a container:
1. new a container based on image
2. start a stopped container

### Init a new docker container
* _docker run_
* _docker run -it --name {container} {image} bash_
* -t option asks Docker to start a pseudo-tty and bind it to the container's STDOUT
* -i option is to let the container's STDIN keep opening (for interaction purpose) 

### Start a stopped container
* _docker container start_

## Run container in daemon
**specify -d option to let the container run in daemon**
* container will output running result in host's STDOUT
* with **-d** option, the output won't show in the host's STDOUT
* check the daemon container's output by _docker logs_
* get the container output by _docker container logs [container ids or names]_

## Stop container
* using _docker container stop_ to stop a running container.
* using _docker container start_ to start a stopped container.
* _docker container restart_ will stop a container first then start it.

## Enter container
*with __-d__ option, docker will go into background model*

1. docker attach
* _docker run -dit ubuntu --name myubuntu_
* _docker attach myubuntu_
* exit from here will stop the running docker
2. docker exec
* _docker exec -it myubuntu bash_
* exit from here won't stop the running docker. That why exec is recommended.

## Export and Import container
### Export
**docker export**
* _docker export myubuntu > myubuntu.tar_

### Import
**docker import**
* _cat myubuntu.tar | docker import - {repository}/{image name}:tag_
*ps. docker import support import from specified net URL or directory*
* _docker import http://example/com/exampleimage.tgz {repository}/{image name}:tag_

## Delete container
**using _docker container rm_ to delete a stopped container**
* docker container rm myubuntu
**you can specify -f option to delete a running container. Docker client will send SIGKILL to container to stop it first.**

## Clean up all the stopped containers
* using _docker container ls -a_ to check all the containers.
* _docker container prune_ will delete all the stopped ones.


