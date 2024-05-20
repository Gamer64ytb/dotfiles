killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
polybar left-1 &
polybar left-2 &
polybar left-3 &
polybar middle &
polybar right-1 &
polybar right-2 &
polybar right-3 &
