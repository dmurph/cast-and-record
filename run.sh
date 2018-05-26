#!/usr/bin/env bash
set -e
echo `pwd`

echo "casting to name ${1}"
echo "saving to file ${2}"

ip=`ifconfig wlan0|grep -Po 'inet \K[\d.]+'`
echo "got ip address:"
echo $ip

address="http://${ip}:8090/test.mp3"
echo "connecting address"
echo $address

trap 'pkill ffserver; pkill ffmpeg; exit' SIGINT

ffserver -d -f ffserver2.conf &
serverpid=$!
sleep 5
./cast --name "${1}" media play $address &

echo "server pid "
echo $serverpid
echo "ffmpeg pid "
echo $ffmpegpid

ffmpeg -y -f alsa -ac 2 -i hw:0 http://127.0.0.1:8090/feed1.ffm -f mp3 -q:a 0 $2
