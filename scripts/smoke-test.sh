#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-http://127.0.0.1:3000}"

check_status() {
  local url="$1"
  local expected="$2"
  local actual
  actual=$(curl -s -o /dev/null -w "%{http_code}" "$url")

  if [[ "$actual" != "$expected" ]]; then
    echo "❌ $url expected $expected, got $actual"
    return 1
  fi

  echo "✅ $url -> $actual"
}

echo "[smoke] building app"
npm run build >/tmp/mission-control-build.log

echo "[smoke] starting app"
npm start >/tmp/mission-control-start.log 2>&1 &
APP_PID=$!

cleanup() {
  if kill -0 "$APP_PID" >/dev/null 2>&1; then
    kill "$APP_PID" >/dev/null 2>&1 || true
  fi
}
trap cleanup EXIT

for _ in {1..30}; do
  if curl -s "$BASE_URL/login" >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

echo "[smoke] running endpoint checks"
check_status "$BASE_URL/login" "200"
check_status "$BASE_URL/api/health" "200"
check_status "$BASE_URL/api/system" "401"

echo "[smoke] PASS"
