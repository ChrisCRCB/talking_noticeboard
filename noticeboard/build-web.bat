@echo off
rm -rf ..\docs & flutter build web --release --base-href /talking_noticeboard/ & mv build\web .. & rename ..\web docs & git add ..\docs & git commit -m "Rebuilt web." & git push