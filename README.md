# Docker for robots

The instructions to set up a docker image for Franka/Tiago++ in ROS, with X11 forwarding to use stream GUI to the monitor of the host PC.

- [Docker for robots](#docker-for-robots)
  - [Linux installation:](#linux-installation)
  - [Isaac sim docker](#isaac-sim-docker)
  - [Usage instructions](#usage-instructions)

Additionally, you can find the [instructions to setup the docker in Windows and MacOS](https://github.com/pearl-robot-lab/Docker_env/blob/main/Windows_Mac.md)

## Linux installation:
Update `init-system-helpers`
```
wget http://ftp.kr.debian.org/debian/pool/main/i/init-system-helpers/init-system-helpers_1.60_all.deb
sudo apt install ./init-system-helpers_1.60_all.deb
```
Set up Docker's repository and install the Docker desktop, see [here](https://docs.docker.com/desktop/install/linux/ubuntu/) for more info 
```
sudo apt install curl qemu-system-x86 pass uidmap
sudo apt install -y ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update -y
sudo apt-get install docker-ce-cli
wget https://desktop.docker.com/linux/main/amd64/docker-desktop-4.14.1-amd64.deb
sudo dpkg -i docker-desktop-4.14.1-amd64.deb
sudo apt install containerd docker.io
```
Allow X11 forwarding via xhost
```
xhost +
```
Manage Docker as a non-root user
```
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```
Verify that you can run `docker` commands without `sudo`
```
docker run hello-world
```

Create aliases for running docker with and without Nvidia:
```
wget https://raw.githubusercontent.com/pearl-robot-lab/Docker_env/main/create_alias.sh
bash create_alias.sh
```

Then you have two options:

* If your PC has an Nvidia GPU:

    Run the scripts for Nvidia drivers
    ```
    wget https://raw.githubusercontent.com/pearl-robot-lab/Docker_env/main/nvidia-scripts.sh
    bash nvidia-scripts.sh
    sudo apt install -y nvidia-docker2
    sudo systemctl daemon-reload
    sudo systemctl restart docker
    ```
    Pull the docker image

    For **Tiago**:
    ```
    docker pull 3liyounes/pearl_robots:tiago
    ```
    For **Franka**:
    use the pre-built docker image available at dockerhub:
    ```
    docker pull 3liyounes/pearl_robots:franka
    ```
    OR build the given Dockerfile in the Docker_franka directory in this repository. Rename the `Dockerfile_nvidia` to `Dockerfile`, enter the Docker_franka folder and then build it:
    ```
    docker build -t projectlab .
    ```
    **Create a container with a name** to contain the pulled image (only once!)
    ```
    source ~/.bashrc
    docker_run_nvidia --name=container_name 3liyounes/pearl_robots:franka bash
    ```

* If your PC does not have an Nvidia GPU:

    Pull the docker image
  
    For **Tiago**:
    ```
    docker pull 3liyounes/pearl_robots:tiago_wo_nvidia
    ```
    For **Franka**:
    use the pre-built docker image available at dockerhub:
    ```
    docker pull 3liyounes/pearl_robots:franka_wo_nvidia
    ```
    OR build the given Dockerfile in the Docker_franka directory in this repository. Rename the `Dockerfile_no_GPU` to `Dockerfile`, enter the Docker_franka folder and then build it:
    ```
    docker build -t projectlab .
    ```
    **Create a container with a name** to contain the pulled image (only once!)
    ```
    source ~/.bashrc
    docker_run_no_gpu --name=container_name 3liyounes/pearl_robots:franka_wo_nvidia bash
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
docker start container_name
```
List existing containers and their names
```
docker ps -a 
```
Allow X11 forwarding via xhost
```
xhost +
```
For each new terminal, **connect to the built container**
```
docker exec -it container_name bash
```
You can stop the docker when you are done
```
docker stop container_name 
```
Remove a container if you want to delete everything in it
```
docker rm container_name
```
