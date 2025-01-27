# space
ui_print " "

# var
UID=`id -u`
[ ! "$UID" ] && UID=0
FIRARCH=`grep_get_prop ro.bionic.arch`
SECARCH=`grep_get_prop ro.bionic.2nd_arch`
ABILIST=`grep_get_prop ro.product.cpu.abilist`
if [ ! "$ABILIST" ]; then
  ABILIST=`grep_get_prop ro.system.product.cpu.abilist`
fi
if [ "$FIRARCH" == arm64 ]\
&& ! echo "$ABILIST" | grep -q arm64-v8a; then
  if [ "$ABILIST" ]; then
    ABILIST="$ABILIST,arm64-v8a"
  else
    ABILIST=arm64-v8a
  fi
fi
if [ "$FIRARCH" == x64 ]\
&& ! echo "$ABILIST" | grep -q x86_64; then
  if [ "$ABILIST" ]; then
    ABILIST="$ABILIST,x86_64"
  else
    ABILIST=x86_64
  fi
fi
if [ "$SECARCH" == arm ]\
&& ! echo "$ABILIST" | grep -q armeabi; then
  if [ "$ABILIST" ]; then
    ABILIST="$ABILIST,armeabi"
  else
    ABILIST=armeabi
  fi
fi
if [ "$SECARCH" == arm ]\
&& ! echo "$ABILIST" | grep -q armeabi-v7a; then
  if [ "$ABILIST" ]; then
    ABILIST="$ABILIST,armeabi-v7a"
  else
    ABILIST=armeabi-v7a
  fi
fi
if [ "$SECARCH" == x86 ]\
&& ! echo "$ABILIST" | grep -q x86; then
  if [ "$ABILIST" ]; then
    ABILIST="$ABILIST,x86"
  else
    ABILIST=x86
  fi
fi
ABILIST32=`grep_get_prop ro.product.cpu.abilist32`
if [ ! "$ABILIST32" ]; then
  ABILIST32=`grep_get_prop ro.system.product.cpu.abilist32`
fi
if [ "$SECARCH" == arm ]\
&& ! echo "$ABILIST32" | grep -q armeabi; then
  if [ "$ABILIST32" ]; then
    ABILIST32="$ABILIST32,armeabi"
  else
    ABILIST32=armeabi
  fi
fi
if [ "$SECARCH" == arm ]\
&& ! echo "$ABILIST32" | grep -q armeabi-v7a; then
  if [ "$ABILIST32" ]; then
    ABILIST32="$ABILIST32,armeabi-v7a"
  else
    ABILIST32=armeabi-v7a
  fi
fi
if [ "$SECARCH" == x86 ]\
&& ! echo "$ABILIST32" | grep -q x86; then
  if [ "$ABILIST32" ]; then
    ABILIST32="$ABILIST32,x86"
  else
    ABILIST32=x86
  fi
fi
if [ ! "$ABILIST32" ]; then
  [ -f /system/lib/libandroid.so ] && ABILIST32=true
fi

# log
if [ "$BOOTMODE" != true ]; then
  FILE=/data/media/"$UID"/$MODID\_recovery.log
  ui_print "- Log will be saved at $FILE"
  exec 2>$FILE
  ui_print " "
fi

# optionals
OPTIONALS=/data/media/"$UID"/optionals.prop
if [ ! -f $OPTIONALS ]; then
  touch $OPTIONALS
fi

# debug
if [ "`grep_prop debug.log $OPTIONALS`" == 1 ]; then
  ui_print "- The install log will contain detailed information"
  set -x
  ui_print " "
fi

# recovery
if [ "$BOOTMODE" != true ]; then
  MODPATH_UPDATE=`echo $MODPATH | sed 's|modules/|modules_update/|g'`
  rm -f $MODPATH/update
  rm -rf $MODPATH_UPDATE
fi

# run
. $MODPATH/function.sh

# info
MODVER=`grep_prop version $MODPATH/module.prop`
MODVERCODE=`grep_prop versionCode $MODPATH/module.prop`
ui_print " ID=$MODID"
ui_print " Version=$MODVER"
ui_print " VersionCode=$MODVERCODE"
if [ "$KSU" == true ]; then
  ui_print " KSUVersion=$KSU_VER"
  ui_print " KSUVersionCode=$KSU_VER_CODE"
  ui_print " KSUKernelVersionCode=$KSU_KERNEL_VER_CODE"
  sed -i 's|#k||g' $MODPATH/post-fs-data.sh
else
  ui_print " MagiskVersion=$MAGISK_VER"
  ui_print " MagiskVersionCode=$MAGISK_VER_CODE"
fi
ui_print " "

# architecture
if [ "$ABILIST" ]; then
  ui_print "- $ABILIST architecture"
  ui_print " "
fi
NAME=arm64-v8a
NAME2=armeabi-v7a
if ! echo "$ABILIST" | grep -q $NAME; then
  rm -rf $MODPATH/system/vendor/lib64
fi
if ! echo "$ABILIST" | grep -q $NAME2; then
  rm -rf $MODPATH/system/vendor/lib
fi

# sdk
NUM=28
if [ "$API" -lt $NUM ]; then
  ui_print "! Unsupported SDK $API. You have to upgrade your Android"
  ui_print "  version at least SDK $NUM to use this module."
  abort
else
  ui_print "- SDK $API"
  ui_print " "
fi

# recovery
mount_partitions_in_recovery

# magisk
magisk_setup

# path
SYSTEM=`realpath $MIRROR/system`
VENDOR=`realpath $MIRROR/vendor`
PRODUCT=`realpath $MIRROR/product`
SYSTEM_EXT=`realpath $MIRROR/system_ext`
ODM=`realpath $MIRROR/odm`
MY_PRODUCT=`realpath $MIRROR/my_product`

# sepolicy
FILE=$MODPATH/sepolicy.rule
DES=$MODPATH/sepolicy.pfsd
if [ "`grep_prop sepolicy.sh $OPTIONALS`" == 1 ]\
&& [ -f $FILE ]; then
  mv -f $FILE $DES
fi

# cleaning
ui_print "- Cleaning..."
PKGS=`cat $MODPATH/package.txt\
       | sed 's|com.sonyericsson.music||g'`
if [ "$BOOTMODE" == true ]; then
  for PKG in $PKGS; do
    FILE=`find /data/app -name *$PKG*`
    if [ "$FILE" ]; then
      RES=`pm uninstall $PKG 2>/dev/null`
    fi
  done
fi
remove_sepolicy_rule
ui_print " "

# function
permissive_2() {
sed -i 's|#2||g' $MODPATH/post-fs-data.sh
}
permissive() {
FILE=/sys/fs/selinux/enforce
SELINUX=`cat $FILE`
if [ "$SELINUX" == 1 ]; then
  if ! setenforce 0; then
    echo 0 > $FILE
  fi
  SELINUX=`cat $FILE`
  if [ "$SELINUX" == 1 ]; then
    ui_print "  Your device can't be turned to Permissive state."
    ui_print "  Using Magisk Permissive mode instead."
    permissive_2
  else
    if ! setenforce 1; then
      echo 1 > $FILE
    fi
    sed -i 's|#1||g' $MODPATH/post-fs-data.sh
  fi
else
  sed -i 's|#1||g' $MODPATH/post-fs-data.sh
fi
}

# permissive
if [ "`grep_prop permissive.mode $OPTIONALS`" == 1 ]; then
  ui_print "- Using device Permissive mode."
  rm -f $MODPATH/sepolicy.rule
  permissive
  ui_print " "
elif [ "`grep_prop permissive.mode $OPTIONALS`" == 2 ]; then
  ui_print "- Using Magisk Permissive mode."
  rm -f $MODPATH/sepolicy.rule
  permissive_2
  ui_print " "
fi

# function
file_check_vendor() {
for FILE in $FILES; do
  DESS="$VENDOR$FILE $ODM$FILE"
  for DES in $DESS; do
    if [ -f $DES ]; then
      ui_print "- Detected"
      ui_print "$DES"
      rm -f $MODPATH/system/vendor$FILE
      ui_print " "
    fi
  done
done
}

# check
if [ "$IS64BIT" == true ]; then
  FILES=/lib64/librs_adreno_sha1.so
  file_check_vendor
fi
if [ "$ABILIST32" ]; then
  FILES=/lib/librs_adreno_sha1.so
  file_check_vendor
fi

# /priv-app
if [ "$API" -le 18 ]; then
  ui_print "- /system/priv-app is not supported in SDK 18 and bellow"
  ui_print "  Using /system/app instead"
  cp -rf $MODPATH/system/priv-app/* $MODPATH/system/app
  rm -rf $MODPATH/system/priv-app
  ui_print " "
fi

# function
hide_oat() {
for APP in $APPS; do
  REPLACE="$REPLACE
  `find $MODPATH/system -type d -name $APP | sed "s|$MODPATH||g"`/oat"
done
}

# hide
APPS="`ls $MODPATH/system/priv-app`
      `ls $MODPATH/system/app`"
hide_oat

# overlay
if [ ! -d /product/overlay ]; then
  ui_print "- Using /vendor/overlay/ instead of /product/overlay/"
  cp -rf $MODPATH/system/product/overlay $MODPATH/system/vendor
  rm -rf $MODPATH/system/product
  ui_print " "
fi

# library
NAME=com.sony.device
if [ "$BOOTMODE" == true ]\
&& ! pm list libraries | grep -q $NAME; then
  echo 'rm -rf /data/user*/"$UID"/com.android.vending/*' >> $MODPATH/cleaner.sh
  ui_print "- Play Store data will be cleared automatically"
  ui_print "  after reboot"
  ui_print " "
fi

# unmount
unmount_mirror


















