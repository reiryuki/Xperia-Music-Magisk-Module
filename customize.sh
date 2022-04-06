ui_print " "

# boot mode
if [ "$BOOTMODE" != true ]; then
  abort "- Please flash via Magisk Manager only!"
fi

# magisk
if [ -d /sbin/.magisk ]; then
  MAGISKTMP=/sbin/.magisk
else
  MAGISKTMP=`find /dev -mindepth 2 -maxdepth 2 -type d -name .magisk`
fi

# info
MODVER=`grep_prop version $MODPATH/module.prop`
MODVERCODE=`grep_prop versionCode $MODPATH/module.prop`
ui_print " ID=$MODID"
ui_print " Version=$MODVER"
ui_print " VersionCode=$MODVERCODE"
ui_print " MagiskVersion=$MAGISK_VER"
ui_print " MagiskVersionCode=$MAGISK_VER_CODE"
ui_print " "

# bit
if [ "$IS64BIT" != true ]; then
  ui_print "- 32 bit"
  rm -rf `find $MODPATH/system -type d -name *64`
else
  ui_print "- 64 bit"
fi
ui_print " "

# sdk
NUM=17
if [ "$API" -lt $NUM ]; then
  ui_print "! Unsupported SDK $API. You have to upgrade your Android"
  ui_print "  version at least SDK API $NUM to use this module."
  abort
else
  ui_print "- SDK $API"
  ui_print " "
fi

# sepolicy.rule
if [ "$BOOTMODE" != true ]; then
  mount -o rw -t auto /dev/block/bootdevice/by-name/persist /persist
  mount -o rw -t auto /dev/block/bootdevice/by-name/metadata /metadata
fi
FILE=$MODPATH/sepolicy.sh
DES=$MODPATH/sepolicy.rule
if [ -f $FILE ] && ! getprop | grep -Eq "sepolicy.sh\]: \[1"; then
  mv -f $FILE $DES
  sed -i 's/magiskpolicy --live "//g' $DES
  sed -i 's/"//g' $DES
fi

# cleaning
ui_print "- Cleaning..."
APP="`ls $MODPATH/system/priv-app` `ls $MODPATH/system/app`"
for APPS in $APP; do
  rm -f `find /data/dalvik-cache /data/resource-cache -type f -name *$APPS*.apk`
done
rm -f $MODPATH/LICENSE
rm -rf /metadata/magisk/$MODID
rm -rf /mnt/vendor/persist/magisk/$MODID
rm -rf /persist/magisk/$MODID
rm -rf /data/unencrypted/magisk/$MODID
rm -rf /cache/magisk/$MODID
ui_print " "

# function
permissive() {
  SELINUX=`getenforce`
  if [ "$SELINUX" == Enforcing ]; then
    setenforce 0
    SELINUX=`getenforce`
    if [ "$SELINUX" == Enforcing ]; then
      ui_print "  ! Your device can't be turned to Permissive state."
    fi
    setenforce 1
  fi
  sed -i '1i\
SELINUX=`getenforce`\
if [ "$SELINUX" == Enforcing ]; then\
  setenforce 0\
fi\' $MODPATH/post-fs-data.sh
}

# permissive
if getprop | grep -Eq "permissive.mode\]: \[1"; then
  ui_print "- Using permissive method"
  rm -f $MODPATH/sepolicy.rule
  permissive
  ui_print " "
elif getprop | grep -Eq "permissive.mode\]: \[2"; then
  ui_print "- Using both permissive and SE policy patch"
  permissive
  ui_print " "
fi

# function
file_check_vendor_grep() {
  for NAMES in $NAME; do
    if [ "$BOOTMODE" == true ]; then
      if [ "$IS64BIT" == true ]; then
        FILE=$MAGISKTMP/mirror/vendor/lib64/$NAMES
      else
        FILE=$MAGISKTMP/mirror/vendor/lib/$NAMES
      fi
    else
      if [ "$IS64BIT" == true ]; then
        FILE=/vendor/lib64/$NAMES
      else
        FILE=/vendor/lib/$NAMES
      fi
    fi
    if [ -f $FILE ]; then
      #rm -f `find $MODPATH -type f -name $NAMES`
      rm -rf $MODPATH/system/vendor
    else
      if grep -Eq $NAMES $DES; then
        ui_print "- Added $NAMES"
        ui_print " "
      else
        #rm -f `find $MODPATH -type f -name $NAMES`
        rm -rf $MODPATH/system/vendor
      fi
    fi
  done
}

# check
NAME=`ls $MODPATH/system/vendor/lib`
if [ "$BOOTMODE" == true ]; then
  DES=$MAGISKTMP/mirror/vendor/lib*/librs_adreno.so
else
  DES=/vendor/lib*/librs_adreno.so
fi
if ! getprop | grep -Eq "xperia.vendor\]: \[0"; then
  file_check_vendor_grep
else
  rm -rf $MODPATH/system/vendor
fi

# /priv-app
if [ "$BOOTMODE" == true ]; then
  DIR=$MAGISKTMP/mirror/system/priv-app
else
  DIR=/system/priv-app
fi
if [ ! -d $DIR ]; then
  ui_print "- /system/priv-app is not supported"
  ui_print "  Moving to /system/app..."
  cp -rf $MODPATH/system/priv-app/* $MODPATH/system/app
  rm -rf $MODPATH/system/priv-app
  ui_print " "
fi

# permission
ui_print "- Setting permission..."
DIR=`find $MODPATH/system/vendor -type d`
for DIRS in $DIR; do
  chown 0.2000 $DIRS
done
if [ "$API" -ge 26 ]; then
  magiskpolicy --live "type vendor_file"
  magiskpolicy --live "dontaudit vendor_file labeledfs filesystem associate"
  magiskpolicy --live "allow     vendor_file labeledfs filesystem associate"
  magiskpolicy --live "dontaudit init vendor_file dir relabelfrom"
  magiskpolicy --live "allow     init vendor_file dir relabelfrom"
  magiskpolicy --live "dontaudit init vendor_file file relabelfrom"
  magiskpolicy --live "allow     init vendor_file file relabelfrom"
  chcon -R u:object_r:vendor_file:s0 $MODPATH/system/vendor
fi
ui_print " "

# library
NAME=com.sony.device
if ! pm list libraries | grep -Eq $NAME; then
  echo 'rm -rf /data/user/*/com.android.vending/*' >> $MODPATH/cleaner.sh
  ui_print "- Play Store data will be cleared automatically on"
  ui_print "  next reboot for app updates."
  ui_print " "
fi



