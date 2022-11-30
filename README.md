# Praktikum zur intelligenten Robotermanipulation

The instructions to setup a docker image for Tiago++ in ROS, with X11 forwarding to use stream GUI to the monitor of the host PC.
Table of contents
1. [Setup the docker container in Windows](#windows)
2. [Setup the docker container in MacOS](#macos)
3. [Setup the docker container in Linux](#linux)
4. [Using the docker container](#usage)

### Windows:
Follow the instructions to [install docker](https://docs.docker.com/desktop/install/windows-install/)

Open the command line and install choco
```
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command " [System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
```
Then install X serever
```
choco install vcxsrv
```
Launch the X server from the command line
```
"C:\Program Files\VcXsrv\vcxsrv.exe" :0 -multiwindow -clipboard -nowgl -ac
``` 

Run `ipconfig` and keep the **IPv4 address** to use it as `<windows_ip>`

Then you have two options:
* If your PC has an NVIDIA GPU
    Build the docker image
    ```
    docker build -t tiago https://raw.githubusercontent.com/Alonso94/Tiago_project/master/Dockerfile_nvidia
    ```
    Create a container
    ```
    docker run -it --net=host --gpus all ^
        --privileged ^
        --env="NVIDIA_DRIVER_CAPABILITIES=all" ^
        --env="QT_X11_NO_MITSHM=1" ^
        --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" ^
        --env="DISPLAY=<windows_ip>:0" ^
        --name="tiago_dual_project"^
        tiago_dual ^
        bash
    ```

* If your PC does not have an NVIDIA GPU
    Build the docker image
    ```
    docker build -t tiago https://raw.githubusercontent.com/Alonso94/Tiago_project/master/Dockerfile_no_GPU
    ```
    Create a container
    ```
    docker run -it --net=host ^
        --privileged ^
        --env="DISPLAY=<windows_ip>:0" ^
        --env="QT_X11_NO_MITSHM=1" ^
        --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" ^
        --name="tiago_dual_project"^
        tiago_dual ^
        bash
    ```


### MacOS:
Follow the instructions Follow the instructions to [install docker](https://docs.docker.com/desktop/install/mac-install/)

Setup X server for X11 forwarding, follow the instructions in [this gist](https://gist.github.com/sorny/969fe55d85c9b0035b0109a31cbcb088)
Build the docker image
```
docker build -t tiago_dual https://raw.githubusercontent.com/iROSA-lab/Docker_env_Tiago/master/Dockerfile_no_GPU
```

Create a container
```
ip=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
docker run -it --net=host \
    --env="DISPLAY=$ip:0" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    -v "$SSH_AUTH_SOCK:$SSH_AUTH_SOCK" -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK\
    --name="tiago_dual_project"\
    --privileged tiago_dual \
    bash
```

### Linux:
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
Allow X11 forwarding via xhost
```
xhost +
```

Then you have two options:
* If your PC has an NVIDIA GPU
    Run the scripts for nvidia drivers
    ```
    bash nvidia-scripts.sh
    ```

    Build the docker image
    ```
    docker build -t tiago_dual https://raw.githubusercontent.com/iROSA-lab/Docker_env_Tiago/master/Dockerfile_nvidia
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
        --name="tiago_dual_project"\
        tiago_dual \
        bash
    ```

* If your PC does not have NVIDIA
    Build the docker image
    ```
    docker build -t tiago_dual https://raw.githubusercontent.com/iROSA-lab/Docker_env_Tiago/master/Dockerfile_no_GPU
    ```

    Create a container
    ```
    docker run -it --net=host \
        --privileged \
        --env="DISPLAY" \
        --env="QT_X11_NO_MITSHM=1" \
        --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
        -v "$SSH_AUTH_SOCK:$SSH_AUTH_SOCK" -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK\
        --name="tiago_dual_project"\
        tiago_dual \
        bash
    ```

## Usage

Start the docker container (only once)
```
docker start tiago_dual_project
```
For each new terminal, connect to the running container
```
docker exec -it tiago_dual_project bash
```

Next, Try the [Pick and place tutorial](http://wiki.ros.org/Robots/TIAGo/Tutorials/MoveIt/Pick_place)

You can stop the docker when you are done
```
docker stop tiago_dual_project
```