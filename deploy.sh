#!/bin/bash

OS=$(uname -a)

# 병합 중이면 중단
if [ -f .git/MERGE_HEAD ]; then
  echo "🚫 병합이 완료되지 않아 중단됨. git merge --abort 또는 수동 해결 필요"
  exit 1
fi

git pull origin main --no-rebase
git add .
git commit -m "Auto deploy from: $OS"
git push origin main

