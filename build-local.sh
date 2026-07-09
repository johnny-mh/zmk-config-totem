#!/bin/bash
# 로컬 ZMK 빌드 스크립트
# 사용법:
#   ./build-local.sh          # 왼쪽(central)만 빌드 — 키맵 변경은 이것만으로 충분
#   ./build-local.sh right    # 오른쪽 빌드
#   ./build-local.sh all      # 양쪽 다 빌드
set -e

WORKSPACE=~/Tools/zmk-workspace
CONFIG_REPO="$(cd "$(dirname "$0")" && pwd)"
export PATH="$WORKSPACE/.venv/bin:/opt/homebrew/bin:$PATH"

build() {
    local side="$1"
    echo "=== totem_$side 빌드 중 ==="
    (cd "$WORKSPACE/zmk" && west build -s app -d "build/$side" -b seeeduino_xiao_ble -- \
        -DSHIELD="totem_$side" \
        -DZMK_CONFIG="$CONFIG_REPO/config" \
        -DZMK_EXTRA_MODULES="$CONFIG_REPO")
    cp "$WORKSPACE/zmk/build/$side/zephyr/zmk.uf2" "$CONFIG_REPO/totem_$side.uf2"
    echo "=== 완료: $CONFIG_REPO/totem_$side.uf2 ==="
}

case "${1:-left}" in
    left)  build left ;;
    right) build right ;;
    all)   build left; build right ;;
    *)     echo "사용법: $0 [left|right|all]"; exit 1 ;;
esac
