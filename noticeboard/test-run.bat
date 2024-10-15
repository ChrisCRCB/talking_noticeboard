@echo off
cls & flutter run -d windows --dart-define="client_hostname=tnb.backstreets.site" --dart-define="client_protocol=http" & title CMD