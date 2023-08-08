@echo off
title ngrok & ngrok http 8080 --host-header rewrite --response-header-add "Access-Control-Allow-Origin:*" --response-header-add "Access-Control-Allow-Headers:*"