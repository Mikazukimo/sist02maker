#!/bin/bash
set -e

# 以下サーバーを起動するスクリプト
echo "run nim server..."
cd /root/nim_lang && \
  nimble install -dy
  nim c -r src/sist02maker.nim
exec "$@"