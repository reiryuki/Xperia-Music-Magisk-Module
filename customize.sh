# check android
if [ "$API" -lt 24 ]; then
  abort "- ! Unsupported sdk: $API. You have to upgrade your Android version at least Lollipop sdk API 24 to use this module!"
else
  ui_print "- Device sdk: $API"
fi

# remove unused file
rm -f $MODPATH/LICENSE

# check file
PRIV=$(getprop ro.control_privapp_permissions)
ui_print "- ro.control_privapp_permissions=$PRIV"
TEST=$MODPATH/test
echo $MODPATH > $TEST
MODPATHM=$(sed 's/_update//g' $TEST)
rm -f $TEST
if [ ! -e "$MODPATHM/system.prop" ]; then
  if [ "$PRIV" == "enforce" ] || [ "$PRIV" == "log" ]; then
    rm -f $MODPATH/system.prop
  fi
fi

