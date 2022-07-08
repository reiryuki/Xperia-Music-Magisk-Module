MODPATH=${0%/*}
APP="`ls $MODPATH/system/priv-app` `ls $MODPATH/system/app`"
for APPS in $APP; do
  rm -f `find /data/dalvik-cache /data/resource-cache -type f -name *$APPS*.apk`
done
PKG="com.sonyericsson.music
     com.sonyericsson.suquashi.soundpicker
     com.sonymobile.music.googlelyricsplugin
     com.sonymobile.music.wikipediaplugin
     com.sonymobile.music.youtubekaraokeplugin
     com.sonymobile.music.youtubeplugin
     com.android.musicfx"
for PKGS in $PKG; do
  rm -rf /data/user/*/$PKGS/cache/*
done


