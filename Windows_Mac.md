# Docker for robots

The instructions to setup a docker image for Tiago++ and Franka in ROS, with X11 forwarding to stream GUI to the monitor of the host PC.
Table of contents
1. [Setup the docker container in Windows](#windows)
2. [Setup the docker container in MacOS](#macos) (Gazebo Does not work)

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
    docker run -it --net=host --gpus all ^
        --privileged ^
        --env="NVIDIA_DRIVER_CAPABILITIES=all" ^
        --env="QT_X11_NO_MITSHM=1" ^
        --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" ^
        --env="DISPLAY=<windows_ip>:0" ^
        --name="<docker_name>"^
        <docker_name> ^
        bash
    ```

* If your PC does not have an NVIDIA GPU
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
    docker run -it --net=host ^
        --privileged ^
        --env="DISPLAY=<windows_ip>:0" ^
        --env="QT_X11_NO_MITSHM=1" ^
        --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" ^
        --name="<docker_name>"^
        <docker_name> ^
        bash
    ```


### MacOS:
(Gazebo does not work on MAC)

Follow the instructions to [install docker](https://docs.docker.com/desktop/install/mac-install/)

Setup X server for X11 forwarding, follow the instructions in [this gist](https://gist.github.com/sorny/969fe55d85c9b0035b0109a31cbcb088)

Build the docker image <br>
For **Tiago**:
```
docker build -t <docker_name> https://raw.githubusercontent.com/iROSA-lab/Docker_env/main/Docker_tiago/Dockerfile_no_GPU
```
For **Franka**:
```
docker build -t <docker_name> https://raw.githubusercontent.com/iROSA-lab/Docker_env/main/Docker_franka/Dockerfile_no_GPU
```
Then run
```
defaults write org.xquartz.X11 enable_iglx -bool true
```

Create a container
```
ip=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
docker run -it --net=host \
    --env="DISPLAY=$ip:0" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    -v "$SSH_AUTH_SOCK:$SSH_AUTH_SOCK" -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK\
    --name="<docker_name>"\
    --privileged <docker_name> \
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