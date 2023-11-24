#!/bin/bash
xhost +local:

docker run --name ros2_control_demo --entrypoint bash -it --gpus all -e "ACCEPT_EULA=Y" --rm --network=host --privileged \
    -v ~/docker/isaac-sim/cache/kit:/isaac-sim/kit/cache/Kit:rw \
    -v ~/docker/isaac-sim/cache/ov:/root/.cache/ov:rw \
    -v ~/docker/isaac-sim/cache/pip:/root/.cache/pip:rw \
    -v ~/docker/isaac-sim/cache/glcache:/root/.cache/nvidia/GLCache:rw \
    -v ~/docker/isaac-sim/cache/computecache:/root/.nv/ComputeCache:rw \
    -v ~/docker/isaac-sim/logs:/root/.nvidia-omniverse/logs:rw \
    -v ~/docker/isaac-sim/data:/root/.local/share/ov/data:rw \
    -v ~/docker/isaac-sim/documents:/root/Documents:rw \
    --env="DISPLAY" \
    -v $HOME/.Xauthority:/root/.Xauthority:rw \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --workdir="/root/colcon_ws" \
    --volume="/home/ubuntu/workspace/1.code/1.arm/ws_ros2_control:/root/colcon_ws" \
    isaac-sim_test:v0.6	
