et -e

# Feel free to change any of the following variables for your app:
TIMEOUT=${TIMEOUT-60}
APP_ROOT=/home/ubuntu/bringit
PID=$APP_ROOT/tmp/pids/thin.pid
CMD="cd $APP_ROOT; rackup -D -P $PID $APP_ROOT/faye.ru -s thin -E production -o 0.0.0.0"
AS_USER=ubuntu
set -u

startme() {
    run "$CMD"
}

stopme() {
    run "sudo pkill -f $PID"
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
