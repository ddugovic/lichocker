# lichocker - [lidraughts.org](https://lidraughts.org) run in a [Docker](https://www.docker.com/) container

## Prerequisites

* [Install Git](https://git-scm.com/downloads).
* [Install Docker](https://docs.docker.com/install/]).
* *Recommended*: Increase your Docker runtime memory to 4GB and your CPUs to 4 ([Mac](https://docs.docker.com/docker-for-mac/#advanced), [Windows](https://docs.docker.com/docker-for-windows/#advanced), and configure the `docker-machine` assigned memory and CPUs for VirtualBox).
* Check out lichocker and open the directory in your terminal: `cd /YOUR/PATH/TO/lichocker`
* Check out [lidraughts](https://github.com/RoepStoep/lidraughts), the main project behind Lidraughts: `git clone --recursive https://github.com/RoepStoep/lidraughts.git`
* Use the default dev console script: `cp lidraughts/bin/dev.default lidraughts/bin/dev && chmod +x lidraughts/bin/dev`
* Use the default application configuration: `cp lidraughts/conf/application.conf.default lidraughts/conf/application.conf`
* Add the following line to your `/etc/hosts` file: `127.0.0.1 lidraughts-assets.local`

## Obtaining the Docker image

### Building the image

Run the following while in the lichocker directory: `docker build --tag ddugovic/lidraughts .`

### Retrieving from Docker Hub

```
docker login
docker pull ddugovic/lidraughts
```

The Docker Hub repository can be found [here](https://hub.docker.com/r/ddugovic/lidraughts/).

## Running

* Run lidraughts in a Docker container using the image obtained above, replacing the path to your local lidraughts repository in the following command:

```
docker run \
    --volume ~/YOUR/PATH/TO/lidraughts:/home/lidraughts/projects/lidraughts \
    --publish 80:80 \
    --publish 9663:9663 \
    --name lidraughts \
    --interactive \
    --tty \
    ddugovic/lidraughts
```

* Enter `run` when you see the [Scala Build Tool](https://www.scala-sbt.org/) console appear: `[lidraughts] $`

* Wait until you see the following message:

```
--- (Running the application, auto-reloading is enabled) ---

[info] p.c.s.NettyServer - Listening for HTTP on /0.0.0.0:9663

(Server started, use Ctrl+D to stop and go back to the console...)
```

* Navigate to http://localhost:9663 in your host machine's browser.

* Enter `evicted` in the `sbt` console and re-run if you see the following error: `[error]     version 2.11.12, library jar: /home/lidraughts/.ivy2/cache/org.scala-lang/scala-library/jars/scala-library-2.11.12.jar, compiler jar: /home/lidraughts/.ivy2/cache/org.scala-lang/scala-compiler/jars/scala-compiler-2.11.12.jar`

## Rebuilding Lidraughts

Because your lidraughts directory exists on your host machine and is mounted onto the container, you can modify the code and rebuild on the host machine and it will take effect on the container. Run `~/YOUR/PATH/TO/lidraughts/ui/build` to update the client side modules. Auto-reloading is enabled for the server side Scala code via sbt.

For more information, including the guide used to create lichocker, please see the [Lidraughts Development Onboarding](https://github.com/RoepStoep/lidraughts/wiki/Lidraughts-Development-Onboarding) instructions.

## Other Commands

* Exiting the Docker container: Ctrl+C
* Stopping the Docker container: `docker stop lidraughts`
* Restarting the Docker container: `docker start lidraughts --attach --interactive`
* View the output of the running Docker container that you previously exited: `docker attach lidraughts`
* Remove the Docker container to mount a different volume: `docker rm lidraughts`
