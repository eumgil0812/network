docker run -td --net none --name green_R1 --rm --privileged --hostname green_R1 -v /tmp/tinet:/tinet slankdev/ubuntu:18.04 > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect green_R1 --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/green_R1 > /dev/null
docker run -td --net none --name green_R2 --rm --privileged --hostname green_R2 -v /tmp/tinet:/tinet slankdev/ubuntu:18.04 > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect green_R2 --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/green_R2 > /dev/null
ip link add net0 netns green_R1 type veth peer name net0 netns green_R2 > /dev/null
ip netns exec green_R1 ip link set net0 up > /dev/null
ip netns exec green_R2 ip link set net0 up > /dev/null
ip netns del green_R1 > /dev/null
ip netns del green_R2 > /dev/null
