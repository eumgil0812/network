#!/bin/bash
# ============================================
# Skylar's selective Tinet Clean Script
# blue_ / green_ 네트워크만 정리
# ============================================

set -e

echo "🧹 Tinet 컨테이너 정리 중..."

TARGETS=$(docker ps -a --format '{{.Names}}' | grep -E '^blue_|^green_' || true)

if [ -z "$TARGETS" ]; then
  echo "✅ 삭제할 blue_/green_ 컨테이너가 없습니다."
else
  echo "🧹 삭제 대상:"
  echo "$TARGETS"
  echo "$TARGETS" | xargs -r docker rm -f
  echo "✅ blue_/green_ 컨테이너 삭제 완료!"
fi

echo "🧹 남은 veth 인터페이스 정리..."
ip link | grep -E 'veth|tinet' | awk -F: '{print $2}' | xargs -r -I{} sudo ip link delete {} 2>/dev/null || true

echo "🧹 남은 netns 정리..."
ip netns list | grep -E 'blue_|green_' | awk '{print $1}' | xargs -r -I{} sudo ip netns delete {} || true

echo "✅ 정리 완료!"
