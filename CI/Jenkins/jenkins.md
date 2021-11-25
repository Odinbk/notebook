# Jenkins

## Running multiple steps

* steps
* _sh_ stands for a step in Jenkinsfile
* wrappers:
  * retry
  * timeout

## Finishing up

* post
  * always
  * success
  * failure
  * unstable
  * changed

## Defining execution environments

* agent. eg.
  >```json
  > agent {
  >   docker {image 'ubuntu'}
  > }
  >```

## Using Environment variables

* environment. eg.

  >```json
  > environment {
  >    DISABLE_AUTH = 'true'
  >    DB_ENIGNE = 'sqlite'
  >  }
  >```

## Recording tests and artifacts

* testing report and artifacts

  > ```json
  >     post {
  >         always {
  >             archiveArtifacts artifacts: 'build/libs/**/*.jar', fingerprint: true
  >             junit 'build/reports/**/*.xml'
  >         }
  >     }
  > ```

## Notification

* [DingDing](http://www.cnblogs.com/jianxuanbing/p/7211006.html)
* Email
  > ```json
  > post {
  >     failure {
  >         mail to: 'team@example.com',
  >              subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
  >              body: "Something is wrong with ${env.BUILD_URL}"
  >     }
  > }
  > ```

## Jenkins account management for gitlab credential

* **?** pulling code from relative repository in Jenkins job need a way to manage.


## Launch a Jenkins in docker
  > ```bash
  >    docker run \
  >      --rm \
  >      --name vmsapi \
  >      -u root \
  >      -p 8080:8080 \
  >      -v jenkins-data:/var/jenkins_home \
  >      -v /var/run/docker.sock:/var/run/docker.sock \
  >      -v "$HOME":/home \
  > ```

### Vega 前端SVN地址

* svn://svn.youle.game/Vega/