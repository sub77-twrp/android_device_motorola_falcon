#!/sbin/sh
#
check(){
if [ -f /persist/wpa_supplicant_conf ]; then
	test1=$(grep ssid /data/misc/wifi/wpa_supplicant.conf)
	test2=$(grep ssid /persist/wpa_supplicant_conf)
fi;
if [ "$test1" = "$test2" ]; then
	exit 1;
fi;
}

mountrw(){
	mount -o rw,remount /persist
	mount -o rw,remount /system
}

mountro(){
	mount -o ro,remount /persist
	mount -o ro,remount /system
}

mountsystem(){
	mount /system
}

mountpersist(){
	mount /persist
}

if [ "$1" = "backup" ]; then
	check
	mountpersist
	mountrw
	mv /persist/wpa_supplicant_conf /persist/wpa_supplicant_conf.bak
	(echo "network={" ; sed -e '1,/network=/ d' /data/misc/wifi/wpa_supplicant.conf) > /persist/wpa_supplicant_conf
	mountro
fi;

if [ "$1" = "restore" ]; then
	check
	mountsystem
	mountrw
	sed -e '/network=/,$ d -i ' /system/etc/wifi/wpa_supplicant.conf
	cat /persist/wpa_supplicant_conf  >> /system/etc/wifi/wpa_supplicant.conf
	mountro
fi;

