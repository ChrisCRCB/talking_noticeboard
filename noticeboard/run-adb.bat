@echo off
adb shell input keyevent KEYCODE_WAKEUP & adb shell am start -n uk.org.crcb.noticeboard/uk.org.crcb.noticeboard.MainActivity