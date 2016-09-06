#A simple popup showing system information

VNSTAT=$(vnstat  --style 0)
(
echo "Network Statistics" # Fist line goes to title
echo "$VNSTAT"

) | dzen2 -p '6' -x "752" -y "16" -w "416" -l "6" -sa 'c' -ta 'c' -bg '#220000' -h '16' -fn Inconsolata-12 -fg '#EEEEEE' -e 'onstart=uncollapse;button1=exit;button3=exit'

# "onstart=uncollapse" ensures that slave window is visible from start.
