#!/usr/bin/env bash
set -e
ffserver -d -f ffserver2.config &
ffmpeg -f alsa -ac 2 -i hw:0 http://127.0.0.1:8090/feed1.ffm -f mp3 -q:a 0 out.mp3
