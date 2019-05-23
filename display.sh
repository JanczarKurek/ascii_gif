#!/bin/bash

function __cleanup {
  rm *.gif.???
  rm *.ascii
  rm temp.gif
  exit 0
}

trap __cleanup SIGINT

gifsicle --unoptimize $1 > temp.gif
gifsicle --explode temp.gif
for frame in temp.gif.???
do
  img2txt $frame > $frame.ascii
done
clear
while true; do
  for frame in temp.gif.???.ascii
  do
    tput cup 0 0
    cat $frame
    sleep 0.06
  done
done
