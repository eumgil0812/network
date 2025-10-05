docker run -td --net none --name blue_R1 --rm --privileged --hostname blue_R1 -v /tmp/tinet:/tinet slankdev/ubuntu:18.04 > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect blue_R1 --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/blue_R1 > /dev/null
docker run -td --net none --name blue_R2 --rm --privileged --hostname blue_R2 -v /tmp/tinet:/tinet slankdev/ubuntu:18.04 > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect blue_R2 --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/blue_R2 > /dev/null
ip link add net0 netns blue_R1 type veth peer name net0 netns blue_R2 > /dev/null
ip netns exec blue_R1 ip link set net0 up > /dev/null
ip netns exec blue_R2 ip link set net0 up > /dev/null
ip netns del blue_R1 > /dev/null
ip netns del blue_R2 > /dev/null
