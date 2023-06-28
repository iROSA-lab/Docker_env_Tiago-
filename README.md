# Docker for robots

The instructions to setup a docker image for Tiago++ in ROS, with X11 forwarding to use stream GUI to the monitor of the host PC.
Table of contents
1. [Setup the docker container in Linux](#linux)
2. [Using the docker container](#usage)

Additionally, you can find the [instructions to setup the docker in Windows and MacOS](https://github.com/iROSA-lab/Docker_env/blob/main/Windows_Mac.md)

### Linux:
Update `init-system-helpers`
```
wget http://ftp.kr.debian.org/debian/pool/main/i/init-system-helpers/init-system-helpers_1.60_all.deb
sudo apt install init-system-helpers_1.60_all.deb
```
Install docker
```
sudo apt install curl qemu-system-x86 pass uidmap
sudo apt install -y ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y
wget https://desktop.docker.com/linux/main/amd64/docker-desktop-4.14.1-amd64.deb
sudo dpkg -i docker-desktop-4.14.1-amd64.deb
sudo apt install containerd docker.io
```
Allow X11 forwarding via xhost
```
xhost +
```
Docker setup
```
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

Then you have two options:

* If your PC has an NVIDIA GPU
    Run the scripts for nvidia drivers
    ```
    wget https://raw.githubusercontent.com/iROSA-lab/Docker_env/main/nvidia-scripts.sh
    bash nvidia-scripts.sh
    sudo apt install -y nvidia-docker2
    sudo systemctl daemon-reload
    sudo systemctl restart docker
    ```

    Build the docker image <br>
    For **Tiago**:
    ```
    docker build -t <docker_name> https://raw.githubusercontent.com/iROSA-lab/Docker_env/main/Docker_tiago/Dockerfile_nvidia
    ```
    For **Franka**:
    ```
    docker build -t <docker_name> https://raw.githubusercontent.com/iROSA-lab/Docker_env/main/Docker_franka/Dockerfile_nvidia
    ```

    Create a container
    ```
    docker run -it --net=host --gpus all \
        --privileged \
        --env="NVIDIA_DRIVER_CAPABILITIES=all" \
        --env="DISPLAY" \
        --env="QT_X11_NO_MITSHM=1" \
        --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
        -v "$SSH_AUTH_SOCK:$SSH_AUTH_SOCK" -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK\
        --name="<docker_name>"\
        <docker_name> \
        bash
    ```

* If your PC does not have NVIDIA
    Build the docker image <br>
    For **Tiago**:
    ```
    docker build -t <docker_name> https://raw.githubusercontent.com/iROSA-lab/Docker_env/main/Docker_tiago/Dockerfile_no_GPU
    ```
    For **Franka**:
    ```
    docker build -t <docker_name> https://raw.githubusercontent.com/iROSA-lab/Docker_env/main/Docker_franka/Dockerfile_no_GPU
    ```

    Create a container
    ```
    docker run -it --net=host \
        --privileged \
        --env="DISPLAY" \
        --env="QT_X11_NO_MITSHM=1" \
        --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
        -v "$SSH_AUTH_SOCK:$SSH_AUTH_SOCK" -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK\
        --name="<docker_name>"\
        <docker_name> \
        bash
    ```

## Usage

Start the docker container (only once)
```
docker start <docker_name>
```
Allow X11 forwarding via xhost
```
xhost +
```
For each new terminal, connect to the running container
```
docker exec -it <docker_name> bash
```
You can stop the docker when you are done
```
docker stop <docker_name> 
```
