#!/sbin/sh
#

checkpersist(){
	mountpersist
	if [ ! -f /persist/wpa_supplicant_conf ]; then
		backup
	fi;

	if [ -f /persist/wpa_supplicant_conf ]; then
		test1=$(grep ssid /data/misc/wifi/wpa_supplicant.conf)
		test2=$(grep ssid /persist/wpa_supplicant_conf)
		echo "comparing data"
		echo $test1
		echo $test2
		if [ "$test1" = "$test2" ]; then
			echo "no backup needed"
			umountpersist
			exit;
		else
			backup
		fi;
	fi;
	umountpersist
}

mountsystem(){
	mount /system
	echo "mounting /system"
}

mountpersist(){
	mount /persist
	echo "mounting /persist"
}

umountsystem(){
	umount /system
	echo "unmounting /system"
}

umountpersist(){
	umount /persist
	echo "unmounting /persist"
}

backup(){
	mountpersist
	(echo "network={" ; sed -e '1,/network=/ d' /data/misc/wifi/wpa_supplicant.conf) > /persist/wpa_supplicant_conf
	echo "wpasupp backup"
	umountpersist
	exit 1;
}

restore(){
	mountpersist
	mountsystem
	test1=$(grep ssid /system/etc/wifi/wpa_supplicant.conf)
	test2=$(grep ssid /persist/wpa_supplicant_conf)
	echo "comparing data"
	echo $test
	echo $test1
	echo $test2
	if [ "$test1" = "$test2" ]; then
		echo "no restore needed"
		umountpersist
		umountsystem
		exit;
	else
		cat /persist/wpa_supplicant_conf  >> /system/etc/wifi/wpa_supplicant.conf
		echo "restored"
		umountpersist
		umountsystem
		exit;
	fi;
}

restoremr(){
        mountpersist
        mountsystem
        test1=$(grep ssid $test)
        test2=$(grep ssid /persist/wpa_supplicant_conf)
        echo "comparing data"
        echo $test
        echo $test1
        echo $test2
        if [ "$test1" = "$test2" ]; then
                echo "no restore needed"
                umountpersist
                umountsystem
                exit;
        else
                cat /persist/wpa_supplicant_conf  >> $test
                echo "restored"
                umountpersist
                umountsystem
                exit;
        fi;
}


if [ "$1" = "backup" ]; then
	checkpersist
fi;

#if [ "$1" = "restore" ]; then
#	restore
#fi;

if [ "$1" = "restore" ] && [ "$2" ]; then
	test="$2"/system/etc/wifi/wpa_supplicant.conf
        restoremr
fi;

