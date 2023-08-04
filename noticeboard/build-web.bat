@echo off
rm -rf ..\docs & flutter build web --release & mv build\web .. & rename ..\web docs