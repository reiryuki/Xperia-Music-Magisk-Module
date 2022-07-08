# debug
magiskpolicy --live "dontaudit system_server system_file file write"
magiskpolicy --live "allow     system_server system_file file write"

# context
magiskpolicy --live "type vendor_file"
magiskpolicy --live "dontaudit vendor_file labeledfs filesystem associate"
magiskpolicy --live "allow     vendor_file labeledfs filesystem associate"
magiskpolicy --live "dontaudit init vendor_file dir relabelfrom"
magiskpolicy --live "allow     init vendor_file dir relabelfrom"
magiskpolicy --live "dontaudit init vendor_file file relabelfrom"
magiskpolicy --live "allow     init vendor_file file relabelfrom"

# dir
magiskpolicy --live "dontaudit { priv_app platform_app system_app untrusted_app_29 untrusted_app_27 untrusted_app_25 untrusted_app } blkio_dev dir search"
magiskpolicy --live "allow     { priv_app platform_app system_app untrusted_app_29 untrusted_app_27 untrusted_app_25 untrusted_app } blkio_dev dir search"

# file
magiskpolicy --live "dontaudit { priv_app platform_app system_app untrusted_app_29 untrusted_app_27 untrusted_app } vendor_file file { read open execute }"
magiskpolicy --live "allow     { priv_app platform_app system_app untrusted_app_29 untrusted_app_27 untrusted_app } vendor_file file { read open execute }"
magiskpolicy --live "dontaudit { priv_app platform_app system_app untrusted_app_29 untrusted_app_27 untrusted_app } privapp_data_file file execute"
magiskpolicy --live "allow     { priv_app platform_app system_app untrusted_app_29 untrusted_app_27 untrusted_app } privapp_data_file file execute"


