#!/usr/bin/env bash

cwd=$(pwd)

cd $cwd


repo[1]="aq2-tng"
url[1]="https://github.com/hifi/aq2-tng.git"

repo[2]="q2admin"
url[2]="https://github.com/hifi/q2admin.git"

repo[3]="q2a_mvd"
url[3]="git://b4r.org/q2a_mvd"

repo[4]="gs_starter"
url[4]="git://b4r.org/gs_starter"

repo[5]="q2pro"
url[5]="http://git.skuller.net/q2pro"

for idx in ${!repo[*]}; do
	echo
	echo "$idx: ${repo[$idx]} from ${url[$idx]}"
	if [ ! -d "${repo[$idx]}" ]; then
		git clone ${url[$idx]}
	else
		cd $cwd/${repo[$idx]} 
		git pull
		cd ..
	fi
	echo
done

