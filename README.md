# Xperia Music Magisk Module

## DISCLAIMER
- Sony apps and blobs are owned by Sony™.
- The MIT license specified here is for the Magisk Module only, not for Sony apps and blobs.

## Descriptions
Music app and Sound Picker by Sony Mobile Communications Inc. integrated as a Magisk Module for all supported and rooted devices with Magisk

## Sources
- https://apkmirror.com com.sonyericsson.music, com.sonyericsson.suquashi.soundpicker, com.sonymobile.music.googlelyricsplugin, com.sonymobile.music.wikipediaplugin, com.sonymobile.music.youtubeplugin, & com.sonymobile.music.youtubekaraokeplugin by Sony Mobile Communications Inc.
- /system/framework/: https://dumps.tadiphone.dev/dumps/sony/i4113 kirin_dsds-user-10-53.1.A.2.2-053001A00020000200894138764-release-keys
- librs_adreno_sha1.so: https://github.com/Aknx77/vendor_xiaomi_vince
- libmagiskpolicy.so: Magisk (stable) 30.7 (30700)

## Changelog

v3.8
- Prepare directories in /storage/emulated/"$UID"/Android/data/
- Update libmagiskpolicy.so from Magisk (stable) 30.7 (30700)
- Resets module folders/files permissions at post-fs-data
- Move _uninstall.log to /data/adb/logs/

v3.7
- Fix wrong target in latest KernelSU
- Abort installation if fail to mount mirror system
- Update SemcMusic.apk version 9.4.16.A.0.11 build 19529739 in Minimum SDK 28 varian

v3.6
- Move apk to priv-app
- Update SemcMusic.apk v9.4.15.A.0.22
- Fix permissions
- Fix architecture detection
- Add Action button to clear apps caches
- Fix bug in uninstall.sh

v3.5
- New Magisk and Kitsune Mask support (independent mirror)
- Remount partitions before mounting mirror to prevent mount failure caused by device/resource busy
- Fix MagiskHide & SUList
- Fix permissions
- Update SemcMusic.apk version

v3.4
- Update apk version
- Redirect /sdcard to /data/media/"$UID"
- Add optional debug.log=1 for more detailed install log
- Minimum SDK API 19
- Fix MagiskHide & SUList
- Fix permission

v3.3
- Fix mount partitions
- Move uninstall log to /data/media/0/..._uninstall.log
- Show data usage warning and option

v3.2
- KernelSU support
- Cleaning protected storage
- Save install log at /sdcard/..._recovery.log while installing via Recovery
- Creates /sdcard/optionals.prop file if it doesn't exist
- Using magiskpolicy --live --apply sepolicy.pfsd if sepolicy.sh=1
- Removed SemcMusicFX.apk
- Fix optional permissive mode
- Add mora WALKMAN support for Japan region
- Using sys.boot_completed=1 detection
- Fix permissions
- Set blacklist/whitelist
- Fix mount required partitions while installing via Recovery
- Using framework dex version 035 fix for Android Oreo and bellow
- Save uninstall log in /data/adb/modules/..._uninstall.log
- Update SemcMusic.apk version 9.4.12.A.0.6 (19496966)

v3.1
- package_cache deletion
- Script enhancements
- Update SemcMusic.apk version
- Add SemcMusicFX.apk
- Fix permissions
- Move dalvik cache cleaning to cleaner.sh
- Using /sdcard/optionals.prop instead of terminal commands for any optional installation
- Move set context to post-fs-data.sh

v3.0
- Enable debug log
- Fix uninstall.sh bug

v2.9
- Add option whether to use sepolicy.rule or sepolicy.sh
- Remove hide functions
- Add permissive optional command

## Requirements
Magisk or Kitsune Mask or KernelSU or Apatch installed

## Installation Guide & Download Link
- If you are using KernelSU, you need to disable Unmount Modules by Default in KernelSU app settings and install https://github.com/KernelSU-Modules-Repo/meta-overlayfs or https://github.com/KernelSU-Modules-Repo/magic_mount_rs or https://github.com/KernelSU-Modules-Repo/hybrid_mount or https://github.com/maxsteeel/nomount first depending on ROM compatibility
- Download the right module file according to your ROM SDK API level:
  - Minimum SDK 28: https://github.com/reiryuki/Xperia-Music-Magisk-Module
  - Minimum SDK 19: https://github.com/reiryuki/Xperia-Music-Magisk-Module
- Install the module via Magisk/Kitsune Mask/KernelSU/Apatch app or Recovery if Magisk/Kitsune Mask installed
- Reboot
- If you are using KernelSU, you need to allow superuser list manually all package name listed in package.txt (and your home launcher app also) (enable show system apps) and reboot after
- If you are using SUList, you need to allow list manually your home launcher app (enable show system apps) and reboot after
- Go to app info of this Music app and allow the network access
- You can even update this Music app via Play Store if there is an update
- If this Music app does not show up in Play Store, then clear Play Store data first

## Optionals
Global: https://t.me/ryukinotes/35

## Troubleshootings
Global: https://t.me/ryukinotes/34

## Support & Bug Report
- https://t.me/ryukinotes/54
- If you don't do above, issues will be closed immediately

## Credits and Contributors
- @repey6
- @HuskyDG
- https://t.me/androidryukimodsdiscussions
- https://t.me/androidappsportdevelopment

## Sponsors
https://t.me/ryukinotes/25


