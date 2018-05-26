#!/usr/bin/env bash
set -e
echo `pwd`

ip=`ifconfig wlan0|grep -Po 'inet \K[\d.]+'`
echo "got ip address:"
echo $ip

trap 'kill $serverpid; kill $ffmpegpid; exit' SIGINT

ffserver -d -f ffserver2.conf &
serverpid=$!
sleep 1
ffmpeg -y -f alsa -ac 2 -i hw:0 http://127.0.0.1:8090/feed1.ffm -f mp3 -q:a 0 out.mp3 &
ffmpegpid=$!
sleep 10
./cast --name "Big Speakers" media play http://${ip}/test.mp3

echo "server pid ${serverpid}"
echo "ffmpeg pid ${ffmpegpid}"

wait $serverpid
wait $ffmpegpid
