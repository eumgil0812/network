#!/bin/bash
# ============================================
# Stop tinet containers safely
# ============================================
echo "🛑 Stopping containers..."
docker stop R1 R2 C1 C2 C3 C4 >/dev/null 2>&1
echo "✅ All containers stopped."
