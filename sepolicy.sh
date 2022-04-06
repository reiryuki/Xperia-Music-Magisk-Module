# type
magiskpolicy --live "type vendor_file"

# dir
magiskpolicy --live "dontaudit { priv_app platform_app system_app untrusted_app_29 untrusted_app_27 untrusted_app_25 untrusted_app } blkio_dev dir search"
magiskpolicy --live "allow     { priv_app platform_app system_app untrusted_app_29 untrusted_app_27 untrusted_app_25 untrusted_app } blkio_dev dir search"

# file
magiskpolicy --live "dontaudit { priv_app platform_app system_app untrusted_app_29 untrusted_app_27 untrusted_app } vendor_file file { read open execute }"
magiskpolicy --live "allow     { priv_app platform_app system_app untrusted_app_29 untrusted_app_27 untrusted_app } vendor_file file { read open execute }"
magiskpolicy --live "dontaudit { priv_app platform_app system_app untrusted_app_29 untrusted_app_27 untrusted_app } privapp_data_file file execute"
magiskpolicy --live "allow     { priv_app platform_app system_app untrusted_app_29 untrusted_app_27 untrusted_app } privapp_data_file file execute"






