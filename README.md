# Docker for robots

The instructions to setup a docker image for Tiago++ in ROS, with X11 forwarding to use stream GUI to the monitor of the host PC.
Table of contents
- [Docker for robots](#docker-for-robots)
  - [Linux installation:](#linux-installation)
  - [Isaac sim docker](#isaac-sim-docker)
  - [Usage instructions](#usage-instructions)

Additionally, you can find the [instructions to setup the docker in Windows and MacOS](https://github.com/iROSA-lab/Docker_env/blob/main/Windows_Mac.md)

## Linux installation:
Update `init-system-helpers`
```
wget http://ftp.kr.debian.org/debian/pool/main/i/init-system-helpers/init-system-helpers_1.60_all.deb
sudo apt install ./init-system-helpers_1.60_all.deb
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

Create aliases for running docker with and without Nvidia:
```
wget https://raw.githubusercontent.com/iROSA-lab/Docker_env/main/create_alias.sh
bash create_alias.sh
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
    docker pull 3liyounes/pearl_robots:tiago
    ```
    For **Franka**:
    ```
    docker pull 3liyounes/pearl_robots:franka
    ```

    Create a container
    ```
    docker_run_nvidia --name="<docker-name>" <docker-name> bash
    ```

* If your PC does not have NVIDIA
    Pull the docker image <br>
    For **Tiago**:
    ```
    docker pull 3liyounes/pearl_robots:tiago_wo_nvidia
    ```
    For **Franka**:
    ```
    docker pull 3liyounes/pearl_robots:franka_wo_nvidia
    ```

    Create a container
    ```
    docker_run_no_gpu --name="<docker_name>" <docker_name> bash
    ```

## Isaac sim docker
* Sign in to the NGC website:
go to [https://ngc.nvidia.com/signin/email](https://ngc.nvidia.com/signin/email) and then enter your email and password
* Click your user account icon in the top right corner and select **Setup**.
* Click Get API key to open the **Setup > API Key** page.
* Click **Generate API Key** to generate your API key.
* Use the command line to log in to NGC before pulling the Isaac Sim container.
    ```
    docker login nvcr.io
    ```
* Pull the Isaac Sim container:
    ```
    docker pull nvcr.io/nvidia/isaac-sim:2022.2.1
    ```
* Run the Isaac Sim container with an interactive Bash session:
    ```
    docker_run_isaac
    ```
    or if you want to run it headless:
    ```
    docker_run_isaac_headless
    ```
## Usage instructions

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
