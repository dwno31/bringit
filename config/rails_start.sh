#!/bin/sh

set -e

# Feel free to change any of the following variables for your app:
TIMEOUT=${TIMEOUT-60}
APP_ROOT=~/bringit
PID=$APP_ROOT/tmp/pids/server.pid
CMD="cd $APP_ROOT;rvmsudo rails s -e production -d -p 80 -b 0.0.0.0 --pid $PID"
AS_USER=ubuntu
set -u

startme() {
    run "$CMD"
}

stopme() {
    run "sudo kill -9 $PID"
}

run () {
  if [ "$(id -un)" = "$AS_USER" ]; then
    eval $1
  else
    su -c "$1" - $AS_USER
  fi
}

case "$1" in
    start)   startme ;;
    stop)    stopme ;;    
    restart) stopme; startme ;;
    *) echo "usage: $0 start|stop|restart" >&2
       exit 1
       ;;
esac
