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

# function
grant_permission() {
UID=`pm list packages -U | grep $PKG | sed -n -e "s/package:$PKG uid://p"`
pm grant $PKG android.permission.READ_EXTERNAL_STORAGE
pm grant $PKG android.permission.WRITE_EXTERNAL_STORAGE
pm grant $PKG android.permission.ACCESS_MEDIA_LOCATION 2>/dev/null
if [ "$API" -ge 33 ]; then
  pm grant $PKG android.permission.READ_MEDIA_AUDIO
  pm grant $PKG android.permission.READ_MEDIA_VIDEO
  pm grant $PKG android.permission.READ_MEDIA_IMAGES
fi
appops set --uid $UID LEGACY_STORAGE allow
appops set $PKG LEGACY_STORAGE allow
appops set $PKG READ_EXTERNAL_STORAGE allow
appops set $PKG WRITE_EXTERNAL_STORAGE allow
appops set $PKG ACCESS_MEDIA_LOCATION allow
appops set --uid $UID ACCESS_MEDIA_LOCATION allow
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
if [ "$API" -ge 31 ]; then
  appops set $PKG MANAGE_MEDIA allow
fi
}

# grant
PKG=com.sonyericsson.music
grant_permission
if [ "$API" -ge 33 ]; then
  pm grant $PKG android.permission.POST_NOTIFICATIONS
fi
appops set $PKG SYSTEM_ALERT_WINDOW allow

# grant
PKG=com.sonyericsson.suquashi.soundpicker
pm grant $PKG android.permission.READ_EXTERNAL_STORAGE
pm grant $PKG android.permission.ACCESS_MEDIA_LOCATION
if [ "$API" -ge 30 ]; then
  appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
fi

# grant
PKG=com.sonymobile.musicslideshow
if pm list packages | grep $PKG ; then
  pm grant $PKG android.permission.READ_EXTERNAL_STORAGE
  pm grant $PKG android.permission.WRITE_EXTERNAL_STORAGE
  pm grant $PKG android.permission.ACCESS_MEDIA_LOCATION
  if [ "$API" -ge 30 ]; then
    appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
  fi
fi

# grant
PKG=com.sonyericsson.musicvisualizer
if pm list packages | grep $PKG ; then
  grant_permission
  pm grant $PKG com.sonyericsson.permission.MUSICSERVICE
fi


