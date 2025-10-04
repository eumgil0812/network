#!/bin/bash
# ============================================
# Start existing tinet containers (if any)
# or recreate if they don't exist
# ============================================

echo "🚀 Starting network containers..."

EXIST=$(docker ps -a --format '{{.Names}}' | grep -E '^(R1|R2|C1|C2|C3|C4)$')

if [ -z "$EXIST" ]; then
  echo "⚠️  Containers not found. Running setup..."
  sudo bash ./up_with_ip.sh
else
  docker start R1 R2 C1 C2 C3 C4 >/dev/null 2>&1
  echo "✅ Containers started."
fi

# recreate /var/run/netns links (important after reboot)
for node in R1 R2 C1 C2 C3 C4; do
  PID=$(docker inspect $node --format '{{.State.Pid}}' 2>/dev/null)
  if [ -n "$PID" ]; then
    mkdir -p /var/run/netns
    ln -sf /proc/$PID/ns/net /var/run/netns/$node
  fi
done

echo "🔗 Network namespaces linked and ready."
