#!/usr/bin/env bash

cwd=$(pwd)
q2srv=$cwd/../q2srv/
cd $cwd

function checkinstalled {
	if [ "$1" != "" ]; then
		I=$(which "$1")
		if [ -f "$I" ]; then
			echo 1
		else
			echo 0
		fi
	fi
}
					
software="git make cc realpath lua screen"

for s in $software; do

	if [ ! $(checkinstalled "$s") ]; then
		echo "'$s' not found on your system. Please have a system administrator install it!"
		return 0
	fi
done

echo "Before continuing, make sure you have the following installed:"
echo "* Lua 5.1, only 5.1!, dev headers"
echo "* libz, also known as zlib"
echo 
echo "  PRESS ENTER"
echo
read


repo[1]="aq2-tng"
url[1]="https://github.com/hifi/aq2-tng.git"
makeit[1]="cd source && pwd && make clean && make"

repo[2]="q2admin"
url[2]="https://github.com/hifi/q2admin.git"
makeit[2]="make clean && make"

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
			cp game$ARCH.so $q2srv/action/game$ARCH.real.so
		;;
		q2admin)
			cp game$ARCH.so $q2srv/action/game$ARCH.so
			cp -r plugins/ $q2srv/
		;;
		q2a_mvd)
			cp mvd.lua $q2srv/plugins/
		;;
		gs_starter)
			cp gs_starter.sh $q2srv/
			if [ ! -f "$q2srv/gs_starter.cfg" ]; then
				cp gs_starter.cfg $q2srv
			fi
		;;
		q2pro)
			cp q2proded $q2srv/
		;;

	esac


	echo
done

