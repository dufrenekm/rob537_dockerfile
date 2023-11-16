docker run -it -d \
    --name rob537_melodic \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --net=host \
    --privileged \
    rob537

export containerId=$(docker ps -l -q)
