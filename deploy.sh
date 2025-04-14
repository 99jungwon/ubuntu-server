#!/bin/bash

# 커밋 메시지 직접 입력받기
read -p "🔧 커밋 메시지를 입력하세요: " MSG

# 시스템 종류 간단하게 판별
if grep -qi ubuntu /etc/os-release; then
    SYS="Ubuntu"
else
    SYS="Local"
fi

# 현재 시간
NOW=$(date '+%Y-%m-%d %H:%M')

# Git 워크플로우
git pull origin main --no-rebase
git add .
git commit -m "$MSG [$SYS, $NOW]"
git push origin main

