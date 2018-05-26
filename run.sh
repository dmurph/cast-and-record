#!/bin/bash


# example usage: ./run.sh "Big Speakers" /media/pi/KINGSTON/set.mp3
echo `pwd`

echo "killing all old processes"
pkill ffserver
pkill ffmpeg

echo "casting to name ${1}"
echo "saving to file ${2}"

rm ffserver.log
ffserver -d -f ffserver2.conf &>ffserver.log 2>&1 &
serverpid=$!
echo "server pid "
echo $serverpid

rm ffmpeg.log
ffmpeg -y -f alsa -ac 2 -i hw:0 http://127.0.0.1:8090/feed1.ffm -f mp3 -q:a 0 $2 &>ffmpeg.log 2>&1 &
ffmpegpid=$!
echo "ffmpeg pid "
echo $ffmpegpid

echo "about to cast"

sleep 2
until [ ! -z "$address" ]
do
	ip=`ifconfig wlan0|grep -Po 'inet \K[\d.]+'`
	echo "got ip address:"
	echo $ip
	address="http://${ip}:8090/test.mp3"
	echo "connecting address"
	echo $address
	sleep 2
	echo "trying again"
done

./cast --name "${1}" media play $address &>cast.log 2>&1

echo "done"

wait $ffmpegpid
