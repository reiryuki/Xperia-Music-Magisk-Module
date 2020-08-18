# check android
if [ "$API" -lt 21 ]; then
  abort "- ! Unsupported sdk: $API. You have to upgrade your Android version at least Lollipop sdk API 21 to use this module!"
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

