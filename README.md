# Praktikum zur intelligenten Robotermanipulation

The instructions to setup a docker image for Tiago++ in ROS, with X11 forwarding to use stream GUI to the monitor of the host PC

## MacOS:
Follow the instructions [here](https://docs.docker.com/desktop/install/mac-install/)

Build the docker image
```
docker build -t tiago_dual https://raw.githubusercontent.com/iROSA-lab/Docker_env_Tiago/master/Dockerfile_no_GPU
```

Start a terminal inside docker
```
docker run -it --net=host \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    -v "$SSH_AUTH_SOCK:$SSH_AUTH_SOCK" -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK\
    --name="tiago_dual_project"\
    --privileged tiago_dual \
    bash
```

## Linux:
Update `init-system-helpers`
```
wget http://ftp.kr.debian.org/debian/pool/main/i/init-system-helpers/init-system-helpers_1.60_all.deb
sudo apt install ~/Downloads/init-system-helpers_1.60_all.deb
```
Install docker
```
wget https://desktop.docker.com/linux/main/amd64/docker-desktop-4.14.1-amd64.deb
sudo apt install ~/Downloads/docker-desktop-4.14.1-amd64.deb
```
The instruction differs if your PC has an NVIDIA card or not:

### If your PC has an NVIDIA GPU
Run the scripts for nvidia drivers
```
bash nvidia-scripts.sh
```

Build the docker image
```
docker build -t tiago_dual https://raw.githubusercontent.com/iROSA-lab/Docker_env_Tiago/master/Dockerfile_nvidia
```

Start a terminal inside docker
```
docker run -it --net=host --gpus all \
    --privileged \
    --env="NVIDIA_DRIVER_CAPABILITIES=all" \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    -v "$SSH_AUTH_SOCK:$SSH_AUTH_SOCK" -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK\
    --name="tiago_dual_project"\
    tiago_dual \
    bash
```

### If your PC does not have NVIDIA

Build the docker image
```
docker build -t tiago_dual https://raw.githubusercontent.com/iROSA-lab/Docker_env_Tiago/master/Dockerfile_no_GPU
```

Start a terminal inside docker
```
docker run -it --net=hos \
    --privileged \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    -v "$SSH_AUTH_SOCK:$SSH_AUTH_SOCK" -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK\
    --name="tiago_dual_project"\
    tiago_dual \
    bash
```

# Usage

Start the docker container
```
docker start tiago_dual
```
Then open a new terminal and connect to the running container
```
docker exec -it tiago_dual_project bash
```

Next, Try the [Pick and place tutorial](http://wiki.ros.org/Robots/TIAGo/Tutorials/MoveIt/Pick_place)

You can stop the docker when you are done
```
docker stop tiago_dual_project
```