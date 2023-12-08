#! /bin/sh
set -e
killall 'Playdate Simulator' || true
cd ..
PRODUCT=$(sed -n '/^PRODUCT :=/s///p' Makefile)
make 
~/Developer/PlaydateSDK/bin/Playdate\ Simulator.app/Contents/MacOS/Playdate\ Simulator $PRODUCT
