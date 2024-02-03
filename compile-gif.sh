#!/bin/bash

function __cleanup {
  rm *.gif.???
  rm temp.gif
  exit 0
}

function __help {
  echo $0
}

function __check_req {
  if ! command -v $1 > /dev/null 2>&1; then
    echo "Command $1 required but not installed, aborting."
    exit 1
  fi
}

__check_req gifsicle
__check_req img2txt

trap __cleanup SIGINT

gifsicle --unoptimize $1 > temp.gif
gifsicle --explode temp.gif

RESULT_FILE="result.sh"
rm -f $RESULT_FILE
echo "clear" >> $RESULT_FILE
echo "while true;" >> $RESULT_FILE
echo "do" >> $RESULT_FILE

for frame in temp.gif.???
do
  echo "tput cup 0 0" >> $RESULT_FILE
  echo -n 'echo "' >> $RESULT_FILE
  img2txt $frame | gzip | base64 -w 0 >> $RESULT_FILE
  echo '" | base64 --decode | gzip -d' >> $RESULT_FILE
  echo "sleep 0.06" >> $RESULT_FILE
done

echo "done" >> $RESULT_FILE


__cleanup