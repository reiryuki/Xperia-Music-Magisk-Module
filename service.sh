(

MODPATH=${0%/*}
API=`getprop ro.build.version.sdk`

# debug
exec 2>$MODPATH/debug.log
set -x

# property
#resetprop ro.semc.version.cust ""
#resetprop ro.semc.version.cust_revision ""
#resetprop ro.semc.version.sw_variant ""
#resetprop ro.somc.customerid ""
#resetprop ro.somc.dseehx.supported true

# wait
sleep 60

# grant
PKG=com.sonyericsson.music
UID=`pm list packages -U | grep $PKG | sed -n -e "s/package:$PKG uid://p"`
pm grant $PKG android.permission.READ_EXTERNAL_STORAGE
pm grant $PKG android.permission.WRITE_EXTERNAL_STORAGE
appops set --uid $UID LEGACY_STORAGE allow
appops set $PKG READ_EXTERNAL_STORAGE allow
appops set $PKG WRITE_EXTERNAL_STORAGE allow
appops set $PKG ACCESS_MEDIA_LOCATION allow
appops set $PKG READ_MEDIA_AUDIO allow
appops set $PKG READ_MEDIA_VIDEO allow
appops set $PKG READ_MEDIA_IMAGES allow
appops set $PKG WRITE_MEDIA_AUDIO allow
appops set $PKG WRITE_MEDIA_VIDEO allow
appops set $PKG WRITE_MEDIA_IMAGES allow
if [ "$API" -ge 30 ]; then
  appops set $PKG MANAGE_EXTERNAL_STORAGE allow
  appops set $PKG NO_ISOLATED_STORAGE allow
  appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
fi

# grant
PKG=com.sonyericsson.suquashi.soundpicker
pm grant $PKG android.permission.READ_EXTERNAL_STORAGE
pm grant $PKG android.permission.ACCESS_MEDIA_LOCATION
if [ "$API" -ge 30 ]; then
  appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
fi

# grant
#PKG=com.sonymobile.musicslideshow
#pm grant $PKG android.permission.READ_EXTERNAL_STORAGE
#pm grant $PKG android.permission.WRITE_EXTERNAL_STORAGE
#pm grant $PKG android.permission.ACCESS_MEDIA_LOCATION
#if [ "$API" -ge 30 ]; then
#  appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
#fi

# grant
#PKG=com.sonyericsson.musicvisualizer
#UID=`pm list packages -U | grep $PKG | sed -n -e "s/package:$PKG uid://p"`
#pm grant $PKG com.sonyericsson.permission.MUSICSERVICE
#pm grant $PKG android.permission.READ_EXTERNAL_STORAGE
#pm grant $PKG android.permission.WRITE_EXTERNAL_STORAGE
#pm grant $PKG android.permission.ACCESS_MEDIA_LOCATION
#appops set --uid $UID LEGACY_STORAGE allow
#appops set --uid $UID READ_EXTERNAL_STORAGE allow
#appops set --uid $UID WRITE_EXTERNAL_STORAGE allow
#appops set $PKG ACCESS_MEDIA_LOCATION allow
#appops set $PKG READ_MEDIA_AUDIO allow
#appops set $PKG READ_MEDIA_VIDEO allow
#appops set $PKG READ_MEDIA_IMAGES allow
#appops set $PKG WRITE_MEDIA_AUDIO allow
#appops set $PKG WRITE_MEDIA_VIDEO allow
#appops set $PKG WRITE_MEDIA_IMAGES allow
#if [ "$API" -ge 30 ]; then
#  appops set $PKG MANAGE_EXTERNAL_STORAGE allow
#  appops set $PKG NO_ISOLATED_STORAGE allow
#  appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
#fi

) 2>/dev/null





