# _Repository_ is a centralized place to store docker images.

## Docker Hub
[docker hub](https://hub.docker.com) is maintained by Docker official which can meet your requirements most of the time.

### Login and Logout
* _docker login_
* _docker logout_

### Pull docker image
* using _docker search [image id or name]_ to search in the official repository
* using _docker pull [image id or name]_ to pull images to local.
* specify _filter=starts={N}_ to show images which stars more than N times.

### Push docker image
* using _docker push [username/image name:tag]_ to push image to Docker Hub.
1. _docker tag [image name:tag] [username/image name:tag]_
2. _docker push [username/image name:tag]_
3. _docker search username_ to verify the image committed to Docker Hub or not.

### Automated Builds
Once there is a new commit or tag created for some project, Docker Hub will start the automated build and push the generated image to Docker Pub
It's useful for program which need to upgrade it's image.
* refer to [automated builds](https://yeasy.gitbooks.io/docker_practice/repository/dockerhub.html) for more details

## Personal repository
Official provided tool [docker-registry](https://docs.docker.com/registry/)

## Build up registry
* _docker run -d -p 5000:5000 --restart=always --name registry registry_
By default, the repository will be created in _/var/lib/registry_ directory of the container.
You can store images in local by providing __-v__ option.
* _docker run -d -p 5000:5000 -v gopt/data/registry:/var/lib/registry registry_

### Upload, search and download image from personal repository.
* _docker tag [image name:tag] [repository host:repository port/image name:tag]_
* _docker push [repository host:repository port/image name:tag]_

### Advanced personal repository setting
Please refer to [advanced personal repository setting](https://yeasy.gitbooks.io/docker_practice/repository/registry_auth.html) for more information