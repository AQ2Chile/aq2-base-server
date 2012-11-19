#!/usr/bin/env bash
#Paul Klumpp 2012-11-19

ver=1.0

cwd=$(pwd)
q2dir=$cwd/../q2srv/
pkg_dir=$cwd/../


# clean q2compile
gits="aq2-tng q2admin q2a_mvd gs_starter q2pro"
for s in $gits; do

	if [ -d "${s}" ]; then
		rm -rf "$s"
	fi
done

# q2dir cleanup
cd $q2dir
rm q2proded
rm gs_starter.sh
rm action/game*.so

# tar
cd $pkg_dir 
rm aq2-basesrv-pkg-$ver.tgz
tar czvf aq2-basesrv-pkg-$ver.tgz *
