#!/bin/bash
# ============================================
# TINET persistent + auto IP setup version
# ============================================

# 1️⃣ Create containers (without --rm)
for node in R1 R2 C1 C2 C3 C4; do
  docker run -td --net none --name $node --privileged --hostname $node -v /tmp/tinet:/tinet slankdev/frr > /dev/null
  mkdir -p /var/run/netns > /dev/null
  PID=$(docker inspect $node --format '{{.State.Pid}}')
  ln -sf /proc/$PID/ns/net /var/run/netns/$node
done

# 2️⃣ Create links
ip link add net0 netns R1 type veth peer name net0 netns R2
ip link add net1 netns R1 type veth peer name net0 netns C1
ip link add net2 netns R1 type veth peer name net0 netns C2
ip link add net1 netns R2 type veth peer name net0 netns C3
ip link add net2 netns R2 type veth peer name net0 netns C4

# 3️⃣ Bring interfaces up
for ns in R1 R2 C1 C2 C3 C4; do
  ip netns exec $ns ip link set lo up
done

for link in \
  "R1 net0" "R1 net1" "R1 net2" \
  "R2 net0" "R2 net1" "R2 net2" \
  "C1 net0" "C2 net0" "C3 net0" "C4 net0"
do
  set -- $link
  ip netns exec $1 ip link set $2 up
done

# 4️⃣ Assign IP addresses
ip netns exec R1 ip addr add 10.0.0.1/24 dev net0
ip netns exec R2 ip addr add 10.0.0.2/24 dev net0

ip netns exec R1 ip addr add 10.0.1.1/24 dev net1
ip netns exec C1 ip addr add 10.0.1.2/24 dev net0

ip netns exec R1 ip addr add 10.0.2.1/24 dev net2
ip netns exec C2 ip addr add 10.0.2.2/24 dev net0

ip netns exec R2 ip addr add 10.0.3.1/24 dev net1
ip netns exec C3 ip addr add 10.0.3.2/24 dev net0

ip netns exec R2 ip addr add 10.0.4.1/24 dev net2
ip netns exec C4 ip addr add 10.0.4.2/24 dev net0

echo "✅ Network up and IPs assigned successfully!"
