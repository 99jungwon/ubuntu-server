#!/bin/bash

OS=$(uname -a)
git pull origin main
git add .
git commit -m "Auto deploy from: $OS"
git push origin main
