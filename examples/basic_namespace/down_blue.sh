docker rm -f R1 || true > /dev/null
rm -rf /var/run/netns/R1 > /dev/null
docker rm -f R2 || true > /dev/null
rm -rf /var/run/netns/R2 > /dev/null
