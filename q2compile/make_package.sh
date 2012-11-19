#!/usr/bin/env bash
#Paul Klumpp 2012-11-19

ver=1.0

cwd=$(pwd)
pkg_dir=$cwd/../


# clean q2compile
gits="aq2-tng q2admin q2a_mvd gs_starter q2pro"
for s in $gits; do

	if [ -d "${s}" ]; then
		rm -rf "$s"
	fi
done

# tar
cd $pkg_dir 
tar czvf aq2-basesrv-pkg-$ver.tgz *
