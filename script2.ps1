# run these:
# Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
# powershell -File .\script2.ps1

flutter test .\test\unit_test.dart -d RK8WB005Z1
# Start-Process cmd -ArgumentList "/k", "adb -s 0a0806530105 shell screenrecord  sdcard/1stDevice.mp4" 
Start-Process cmd -ArgumentList "/k", "adb -s 0a0806530105 shell screenrecord --time-limit 180 sdcard/2ndDeviceP1.mp4 && adb -s 0a0806530105 shell screenrecord --time-limit 60 sdcard/2ndDeviceP2.mp4 && adb -s 0a0806530105  pull sdcard/2ndDeviceP1.mp4 && adb -s 0a0806530105 shell rm sdcard/2ndDeviceP1.mp4 && adb -s 0a0806530105  pull sdcard/2ndDeviceP2.mp4 && adb -s 0a0806530105 shell rm sdcard/2ndDeviceP2.mp4"
Start-Process cmd -ArgumentList "/k", "adb -s RK8WB005Z1F shell screenrecord --time-limit 180 sdcard/1stDevice.mp4 && adb -s RK8WB005Z1F  pull sdcard/1stDevice.mp4 && adb -s RK8WB005Z1F shell rm sdcard/1stDevice.mp4"
Start-Process cmd -ArgumentList "/k", "flutter drive --driver=test_driver/test_driver.dart --target=integration_test/app_test2.dart -d 0a0806530105"
Start-Process cmd -ArgumentList "/k", "flutter drive --driver=test_driver/test_driver.dart --target=integration_test/app_test.dart -d RK8WB005Z1F"

