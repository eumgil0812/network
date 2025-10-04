docker run -td --net none --name R1 --rm --privileged --hostname R1 -v /tmp/tinet:/tinet slankdev/frr > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect R1 --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/R1 > /dev/null
docker run -td --net none --name R2 --rm --privileged --hostname R2 -v /tmp/tinet:/tinet slankdev/frr > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect R2 --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/R2 > /dev/null
docker run -td --net none --name C1 --rm --privileged --hostname C1 -v /tmp/tinet:/tinet slankdev/frr > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect C1 --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/C1 > /dev/null
docker run -td --net none --name C2 --rm --privileged --hostname C2 -v /tmp/tinet:/tinet slankdev/frr > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect C2 --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/C2 > /dev/null
docker run -td --net none --name C3 --rm --privileged --hostname C3 -v /tmp/tinet:/tinet slankdev/frr > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect C3 --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/C3 > /dev/null
docker run -td --net none --name C4 --rm --privileged --hostname C4 -v /tmp/tinet:/tinet slankdev/frr > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect C4 --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/C4 > /dev/null
ip link add net0 netns R1 type veth peer name net0 netns R2 > /dev/null
ip netns exec R1 ip link set net0 up > /dev/null
ip netns exec R2 ip link set net0 up > /dev/null
ip link add net1 netns R1 type veth peer name net0 netns C1 > /dev/null
ip netns exec R1 ip link set net1 up > /dev/null
ip netns exec C1 ip link set net0 up > /dev/null
ip link add net2 netns R1 type veth peer name net0 netns C2 > /dev/null
ip netns exec R1 ip link set net2 up > /dev/null
ip netns exec C2 ip link set net0 up > /dev/null
ip link add net1 netns R2 type veth peer name net0 netns C3 > /dev/null
ip netns exec R2 ip link set net1 up > /dev/null
ip netns exec C3 ip link set net0 up > /dev/null
ip link add net2 netns R2 type veth peer name net0 netns C4 > /dev/null
ip netns exec R2 ip link set net2 up > /dev/null
ip netns exec C4 ip link set net0 up > /dev/null
ip netns del R1 > /dev/null
ip netns del R2 > /dev/null
ip netns del C1 > /dev/null
ip netns del C2 > /dev/null
ip netns del C3 > /dev/null
ip netns del C4 > /dev/null
