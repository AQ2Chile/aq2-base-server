#!/usr/bin/env bash
#Paul Klumpp 2012-11-19

cwd=$(pwd)
q2srv=$cwd/../q2srv/
cd $cwd

function checkinstalled {
	if [ "$1" != "" ]; then
		woot=$(which "$1" 2> /dev/null)
		if [ -f "$woot" ]; then
			echo 1
		else
			echo 0
		fi
	fi
}

echo "Before continuing, make sure you have the following installed:"
echo "* git"
echo "* make"
echo "* cc"
echo "* screen"
echo "* Lua 5.1, only 5.1!, dev headers"
echo "* libz, also known as zlib1g-dev on Debian/Ubuntu"
echo 
echo "  PRESS ENTER"
echo
read



software="git make cc realpath lua screen"
for soft in $software; do

	see=$(checkinstalled "$soft")
	if [ $see -eq 0 ]; then
		echo "'$soft' not found on your system. Please have a system administrator install it!"
		exit
	fi
done


repo[1]="q2admin"
url[1]="https://github.com/hifi/q2admin.git"
makeit[1]="make clean && make"

repo[2]="aq2-tng"
url[2]="https://github.com/hifi/aq2-tng.git"
makeit[2]="cd source && pwd && make clean && make"

repo[3]="q2a_mvd"
url[3]="git://b4r.org/q2a_mvd"
makeit[3]=""

repo[4]="gs_starter"
url[4]="git://b4r.org/gs_starter"
makeit[4]=""

repo[5]="q2pro"
url[5]="http://git.skuller.net/q2pro"
makeit[5]="cp ../q2proconfig ./.config && make clean && INCLUDES='-DUSE_PACKETDUP=1' make q2proded"

ARCH=$(uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc/ -e s/sparc64/sparc/ -e s/arm.*/arm/ -e s/sa110/arm/ -e s/alpha/axp/)

for idx in ${!repo[*]}; do
	echo

	# get it
	echo "$idx: ${repo[$idx]} from ${url[$idx]}"
	if [ ! -d "${repo[$idx]}" ]; then
		git clone ${url[$idx]}
	else
		echo "Dir exists, we begin making"
		cd $cwd/${repo[$idx]} 
		git pull
		cd ..
	fi

	# make it
	cd $cwd/${repo[$idx]}
	eval ${makeit[$idx]}

	# install it
	case "${repo[$idx]}" in
		aq2-tng)
			cp -v game$ARCH.so $q2srv/action/game$ARCH.real.so
			cd ..
			cd action
			cp -v prules.ini $q2srv/action/
			cp -vr doc/ $q2srv/action/
			cp -vr models/ $q2srv/action/
			cp -vr pics/ $q2srv/action/
			cp -vr players/ $q2srv/action/
			cp -vr sound/ $q2srv/action/
			cp -vr tng/ $q2srv/action/
		;;
		q2admin)
			if [ -f "game$ARCH.so" ]; then
				cp -v game$ARCH.so $q2srv/action/game$ARCH.so
				cp -vr plugins/ $q2srv/
			else
				echo "W0000000t .. q2admin did not compile. Something was wrong."
				echo "It is most possible because Lua5.1 is missing."
				echo
				echo "If you are on Debian or Ubuntu, please try to install the following"
				echo "package server wide: liblua5.1-0-dev"
				echo
				echo "To do that, try: 'sudo apt-get install liblua5.1-0-dev'"
				echo
				echo "Then start this script again."
				echo
				exit
			fi
		;;
		q2a_mvd)
			cp mvd.lua $q2srv/plugins/
		;;
		gs_starter)
			cp -v gs_starter.sh $q2srv/
			if [ ! -f "$q2srv/gs_starter.cfg" ]; then
				cp -v gs_starter.cfg $q2srv
			fi
		;;
		q2pro)
			cp -v q2proded $q2srv/
		;;

	esac

	cd $cwd

	echo
done

