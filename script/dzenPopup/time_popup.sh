 #A simple popup showing system information

 WEATHER=$(exec /home/oskar/script/bar/weather.sh "EUR|SWE|Gothenburg")

 (
 echo "$(cal -w)"
 echo "Weather - Gothenburg"
 echo "$WEATHER" # Fist line goes to title
 ) | dzen2 -p '6' -x "1685" -y "16" -w "235" -l "9" -sa 'c' -ta 'c' -bg '#111100' -h '16' -fn Inconsolata-12 -fg '#EEEEEE' -e 'onstart=uncollapse;button1=exit;button3=exit'

 # "onstart=uncollapse" ensures that slave window is visible from start.
