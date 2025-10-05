docker run -td --net none --name S1 --rm --privileged --hostname S1 -v /tmp/tinet:/tinet slankdev/coredns:centos-7 > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect S1 --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/S1 > /dev/null
docker run -td --net none --name R1 --rm --privileged --hostname R1 -v /tmp/tinet:/tinet slankdev/coredns:centos-7 > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect R1 --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/R1 > /dev/null
docker run -td --net none --name KVS --rm --privileged --hostname KVS -v /tmp/tinet:/tinet slankdev/etcd:centos-7 > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect KVS --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/KVS > /dev/null
docker run -td --net bridge --name NS1 --rm --privileged --hostname NS1 -v /tmp/tinet:/tinet slankdev/coredns:centos-7 > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect NS1 --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/NS1 > /dev/null
docker run -td --net bridge --name NS2 --rm --privileged --hostname NS2 -v /tmp/tinet:/tinet slankdev/coredns:centos-7 > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect NS2 --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/NS2 > /dev/null
docker run -td --net bridge --name NS3 --rm --privileged --hostname NS3 -v /tmp/tinet:/tinet slankdev/coredns:centos-7 > /dev/null
mkdir -p /var/run/netns > /dev/null
PID=`docker inspect NS3 --format '{{.State.Pid}}'` > /dev/null
ln -s /proc/$PID/ns/net /var/run/netns/NS3 > /dev/null
ip link add net0 netns S1 type veth peer name net0 netns R1 > /dev/null
ip netns exec S1 ip link set net0 up > /dev/null
ip netns exec R1 ip link set net0 up > /dev/null
ip link add net1 netns S1 type veth peer name net0 netns NS1 > /dev/null
ip netns exec S1 ip link set net1 up > /dev/null
ip netns exec NS1 ip link set net0 up > /dev/null
ip link add net2 netns S1 type veth peer name net0 netns NS2 > /dev/null
ip netns exec S1 ip link set net2 up > /dev/null
ip netns exec NS2 ip link set net0 up > /dev/null
ip link add net3 netns S1 type veth peer name net0 netns NS3 > /dev/null
ip netns exec S1 ip link set net3 up > /dev/null
ip netns exec NS3 ip link set net0 up > /dev/null
ip link add net4 netns S1 type veth peer name net0 netns KVS > /dev/null
ip netns exec S1 ip link set net4 up > /dev/null
ip netns exec KVS ip link set net0 up > /dev/null
ip netns del S1 > /dev/null
ip netns del R1 > /dev/null
ip netns del KVS > /dev/null
ip netns del NS1 > /dev/null
ip netns del NS2 > /dev/null
ip netns del NS3 > /dev/null
docker cp Corefile.NS1 NS1:/Corefile > /dev/null
