#!/bin/bash

#relative:
ACTIONDIR=./..

cd $ACTIONDIR
ACTIONDIR=$(pwd)
# now it's absolute

SNDDIR=$ACTIONDIR/sound/user
CFGDIR=$ACTIONDIR/config
cd $SNDDIR
find -type f -iname "*wav" | sed -e 's/\.\///' $CFGDIR/sndlist.ini.current
cd $CFGDIR
cp sndlist.ini.header sndlist.ini
sort sndlist.ini.current >> sndlist.ini
