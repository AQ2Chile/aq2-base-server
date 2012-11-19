#!/bin/bash
ACTIONDIR=./..
MAPDIR=$ACTIONDIR/maps
CFGDIR=$ACTIONDIR/config
cd $MAPDIR
ls -1 *bsp | sed s/.bsp// > $CFGDIR/maplist.bsp.current
cd $CFGDIR
sort maplist.bsp.current > maplist.ini
