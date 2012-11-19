#!/bin/bash

#relative:
ACTIONDIR=./..

cd $ACTIONDIR
ACTIONDIR=$(pwd)
# now it's absolute

SNDDIR=$ACTIONDIR/sound/user
CFGDIR=$ACTIONDIR/config
cd $SNDDIR
ls -1 *wav > $CFGDIR/sndlist.ini.current
cd $CFGDIR
cp sndlist.ini.header sndlist.ini
sort sndlist.ini.current >> sndlist.ini
