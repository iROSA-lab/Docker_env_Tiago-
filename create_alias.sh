echo 'alias docker_run_no_gpu="docker run -it --net=host \
        --privileged \
        --env="DISPLAY" \
        --env="QT_X11_NO_MITSHM=1" \
        --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
        -v "$SSH_AUTH_SOCK:$SSH_AUTH_SOCK" -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK"' >> ~/.bashrc

echo 'alias docker_run_nvidia="docker run -it --net=host --gpus all \
        --privileged \
        --env="NVIDIA_DRIVER_CAPABILITIES=all" \
        --env="DISPLAY" \
        --env="QT_X11_NO_MITSHM=1" \
        --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
        -v "$SSH_AUTH_SOCK:$SSH_AUTH_SOCK" -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK"' >> ~/.bashrc

echo 'alias docker_run_isaac="docker run -it --name isaac-sim --entrypoint bash --gpus all -e "ACCEPT_EULA=Y" --network=host \
        -v $HOME/.Xauthority:/root/.Xauthority \
        -e DISPLAY \
        -v ~/docker/isaac-sim/kit/cache/Kit:/isaac-sim/kit/cache/Kit:rw \
        -v ~/docker/isaac-sim/cache/ov:/root/.cache/ov:rw \
        -v ~/docker/isaac-sim/cache/pip:/root/.cache/pip:rw \
        -v ~/docker/isaac-sim/cache/glcache:/root/.cache/nvidia/GLCache:rw \
        -v ~/docker/isaac-sim/cache/computecache:/root/.nv/ComputeCache:rw \
        -v ~/docker/isaac-sim/logs:/root/.nvidia-omniverse/logs:rw \
        -v ~/docker/isaac-sim/data:/root/.local/share/ov/data:rw \
        -v ~/docker/isaac-sim/documents:/root/Documents:rw \
        nvcr.io/nvidia/isaac-sim:2022.2.1"' >> ~/.bashrc

echo 'alias docker_run_isaac_headless="docker run --name isaac-sim --entrypoint bash -it --gpus all -e "ACCEPT_EULA=Y" --network=host \
        -v ~/docker/isaac-sim/cache/kit:/isaac-sim/kit/cache/Kit:rw \
        -v ~/docker/isaac-sim/cache/ov:/root/.cache/ov:rw \
        -v ~/docker/isaac-sim/cache/pip:/root/.cache/pip:rw \
        -v ~/docker/isaac-sim/cache/glcache:/root/.cache/nvidia/GLCache:rw \
        -v ~/docker/isaac-sim/cache/computecache:/root/.nv/ComputeCache:rw \
        -v ~/docker/isaac-sim/logs:/root/.nvidia-omniverse/logs:rw \
        -v ~/docker/isaac-sim/data:/root/.local/share/ov/data:rw \
        -v ~/docker/isaac-sim/documents:/root/Documents:rw \
        nvcr.io/nvidia/isaac-sim:2022.2.1"' >> ~/.bashrc

source ~/.bashrc