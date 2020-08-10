# check android
if [ "$API" -lt 24 ]; then
  abort "- ! Unsupported sdk: $API. You have to upgrade your Android version at least Lollipop sdk API 24 to use this module!"
else
  ui_print "- Device sdk: $API"
fi

# remove unused file
rm -f $MODPATH/LICENSE

