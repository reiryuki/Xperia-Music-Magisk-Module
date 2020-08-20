# check android
if [ "$API" -lt 17 ]; then
  abort "- ! Unsupported sdk: $API. You have to upgrade your Android version at least Jelly Bean sdk API 17 to use this module!"
else
  ui_print "- Device sdk: $API"
fi

# remove unused file
rm -f $MODPATH/LICENSE

# remove sound picker
if [ "$API" -lt 23 ]; then
  ui_print "- Removing Xperia Sound Picker, because it only for Marshmallow sdk 23 and up..."
  rm -rf $MODPATH/system/priv-app/XperiaSoundPicker
fi

# priv-app unsupported
if [ ! -e "/system/priv-app" ]; then
  ui_print "- /system/priv-app not supported"
  ui_print "- Moving to /system/app..."
  mv $MODPATH/system/priv-app $MODPATH/system/app
fi

